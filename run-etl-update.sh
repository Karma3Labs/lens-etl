#!/bin/bash
WORK_DIR=${WORK_DIR:-"/home/ubuntu/lens-etl"}; source $WORK_DIR/.env
GCS_BUCKET_NAME=${GCS_BUCKET_NAME:-${GCS_BUCKET_UPDATE:-""}}
GCP_ACTIVE_ACCT=$(gcloud auth list|grep "*"|awk {'print $2'})
GCP_TASK_ACCT=${GCP_TASK_ACCT:-"$(gcloud config get account --quiet)"}
DB_HOST=${DB_HOST:-172.17.0.1}
DB_PORT=${DB_PORT:-5432}
DB_USER=${DB_USER:-postgres}
DB_NAME=${DB_NAME:-lens_bigquery}
SQL_TEMPLATE=${SQL_TEMPLATE:-sql-import-update}
SQL_WORKDIR=sql-workdir
SQL_UPSERT=sql-upsert
EXPORT_DIR=buckets-update
LOG_DIR=${LOG_DIR:-"/var/log/lens-etl"}
LOG=${LOG_DIR}/$(basename "$0").log
BQ_DATASET=${BQ_DATASET:-lens-public-data:polygon}

# Remove the comment below to debug
set -x

# Create the log directory it, this is an idempotent task
USER=${USER:-ubuntu}
sudo mkdir -p $LOG_DIR
sudo chown $USER: $LOG_DIR

JOBTIME=$(date +%Y%m%d%H%M%S)

# Declare which tables are to be updated, and which needs to be replaced
declare -A bq_table_behavior=( \
  [public_follower]=REPLACE \
  [public_post_comment]=BLOCK_TIMESTAMP \
  [public_profile]=BLOCK_TIMESTAMP \
  [public_profile_post]=BLOCK_TIMESTAMP \
  [public_profile_stats]=REPLACE \
  [public_profile_curated]=REPLACE \
  [public_publication_collect_module_collected_records]=REPLACE \
  [public_publication_collect_module_details]=REPLACE \
  [public_publication_reaction_records]=ACTION_AT \
  [public_publication_stats]=REPLACE \
)

if [ $GCP_TASK_ACCT != $GCP_ACTIVE_ACCT ]; then
  echo "Setting GCS account as $GCP_TASK_ACCT"
  gcloud config set account "$GCP_TASK_ACCT" --quiet
fi

log() {
    echo "*******************************************************************************************************" >> $LOG
    echo "`date` - $1" >> $LOG
}

starting_point=''

function getStartingPoint() {
  local_table=${1/public_/public.}
  sql="SELECT ${2,,} FROM $local_table ORDER BY ${2,,} DESC LIMIT 1;"
  starting_point=`/usr/bin/psql -t -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$sql" | head -1 | xargs`
}

#log "Clear out Cloud Storage buckets"
/usr/bin/gsutil -m rm -r "gs://${GCS_BUCKET_NAME}/*" >> $LOG 2>&1

log "Run the queries in BigQuery to export data into Google Cloud Storage"
mkdir -p ${WORK_DIR}/${SQL_WORKDIR}

function process_sql_template() {
  local sql_template=$1
  working_sql=${WORK_DIR}/${SQL_WORKDIR}/$(basename $sql_template)
  cp $sql_template $working_sql
  sed -i "s/GCS_BUCKET_NAME/${GCS_BUCKET_NAME}/g" $working_sql

  # SQL template files should be named like the table names with .sql
  table_name=$(basename ${sql_template%.*})

  # Clear out the export data destination (Google Cloud Storage bucket)
  # parallel_process_count and parallel_thread_count added to address process hanging issue
  # reference - https://github.com/GoogleCloudPlatform/gsutil/issues/464
  /usr/bin/gsutil -m -o GSUtil:parallel_process_count=1 -o GSUtil:parallel_thread_count=24 \ 
    rm -r "gs://${GCS_BUCKET_NAME}/$table_name" >> $LOG 2>&1  

  if [ "${bq_table_behavior[$table_name]}" != "REPLACE" ]; then
    getStartingPoint $table_name ${bq_table_behavior[$table_name]}
    log "Import starting from ${bq_table_behavior[$table_name]} for table $table_name"
    sed -i "s/${bq_table_behavior[$table_name]}/$starting_point/g" $working_sql
  else
    log "Importing the entire table $table_name"
  fi

  log "Running $working_sql"
  /usr/bin/bq query --use_cache --nouse_legacy_sql --dataset_id "${BQ_DATASET}" "$(cat $working_sql)" >> $LOG 2>&1
}

declare -a pids

for sql_template in ${WORK_DIR}/${SQL_TEMPLATE}/*; do
  process_sql_template "$sql_template" &
  pids+=($!)
done

# Wait for all background processes to finish
for pid in "${pids[@]}"; do
  wait $pid
done

log "Remove folders in local drive and downloading CSV files from GCS"
mkdir -p ${WORK_DIR}/${EXPORT_DIR}
mkdir -p ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}
/usr/bin/gsutil -m cp -r "gs://${GCS_BUCKET_NAME}/*" ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/ >> $LOG 2>&1

if [ $GCP_TASK_ACCT != $GCP_ACTIVE_ACCT ]; then
  gcloud config set account "$GCP_ACTIVE_ACCT"
fi

# Define an array to store directory names
dirs=()

function process_db_updates() {
  local dir=$1
  # Remove the trailing slash from the directory name
  dir="${dir%/}"
  dirs+=("$dir")
  files=$(ls -1 "$dir")
  table=$dir
  table_name=$(basename ${table%.*})

  # Table names in BigQuery are "public_*" while Postgres are "public.*"
  local_table="${dir/public_/public.}"
  local_table=$(basename "$local_table")
  tmp_suffix=""

  if [ "${bq_table_behavior[$table_name]}" == 'REPLACE' ]; then
    tmp_suffix="_tmp"
    log "CREATE a new table $local_table${tmp_suffix} and make sure it is clean"
    /usr/bin/psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "CREATE TABLE IF NOT EXISTS $local_table${tmp_suffix} (LIKE $local_table INCLUDING ALL); TRUNCATE TABLE $local_table${tmp_suffix};" >> $LOG 2>&1
  fi

  for file in ${files[@]}; do
    log "Importing $dir/$file"
    /usr/bin/psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\COPY $local_table${tmp_suffix} FROM '$dir/$file' WITH (DELIMITER ',', FORMAT csv, HEADER true)" >> $LOG 2>&1
  done

  if [ "${bq_table_behavior[$table_name]}" == 'REPLACE' ]; then
    log "Run the INSERT or UPDATE query in ${WORK_DIR}/${SQL_UPSERT}/$table_name.sql"
    /usr/bin/psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f ${WORK_DIR}/${SQL_UPSERT}/$table_name.sql >> $LOG 2>&1
    /usr/bin/psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "DROP TABLE $local_table${tmp_suffix}" >> $LOG 2>&1
  fi
}

declare -a db_pids

# Loop through all directories in the current directory and add them to the array
for dir in ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/*/; do
  process_db_updates "$dir" &
  db_pids+=($!)
done

# Wait for all background processes to finish
for db_pids in "${db_pids[@]}"; do
  wait $db_pids
done

log "Backup work directory for audit purposes and clean it up the temporary folder"
rm -fr ${WORK_DIR}/${EXPORT_DIR}/*
cp -pr ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/* ${WORK_DIR}/${EXPORT_DIR}/
rm -fr ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}

log "Refreshing materialized views"
/usr/bin/psql -e -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f ${WORK_DIR}/refresh_materialized_view.sql >> $LOG 2>&1

log "Script $0 COMPLETED!"

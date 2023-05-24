#!/bin/bash
WORK_DIR=${WORK_DIR:-/home/ubuntu/lens-etl}
GCS_BUCKET_NAME=${GCS_BUCKET_NAME:-k3l-lens-bigquery-update}
DB_HOST=${DB_HOST:-172.17.0.1}
DB_PORT=${DB_PORT:-5432}
DB_USER=${DB_USER:-postgres}
DB_NAME=${DB_NAME:-lens_bigquery}
DB_PASS=${DB_PASS:-some_safe_password}
SQL_TEMPLATE=sql-import-update
SQL_WORKDIR=sql-workdir
SQL_UPSERT=sql-upsert
EXPORT_DIR=buckets-update
LOG_DIR=/var/log/lens-etl
LOG=${LOG_DIR}/$(basename "$0").log

# Remove the comment below to debug
set -x

# Create the log directory it, this is an idempotent task
USER=${USER:-ubuntu}
sudo mkdir -p $LOG_DIR
sudo chown $USER: $LOG_DIR

JOBTIME=$(date +%Y%m%d%H%M%S)

# Declare which tables are to be updated, and which needs to be replaced
declare -A bq_table_behavior=( \
  [public_follower]=BLOCK_TIMESTAMP \
  [public_post_comment]=BLOCK_TIMESTAMP \
  [public_profile]=BLOCK_TIMESTAMP \
  [public_profile_post]=BLOCK_TIMESTAMP \
  [public_profile_stats]=REPLACE \
  [public_publication_collect_module_collected_records]=BLOCK_TIMESTAMP \
  [public_publication_collect_module_details]=BLOCK_TIMESTAMP \
  [public_publication_collect_module_multirecipient_details]=REPLACE \
  [public_publication_reaction_records]=ACTION_AT \
  [public_publication_stats]=REPLACE \
)


log() {
    echo "*******************************************************************************************************" >> $LOG
    echo "`date` - $1" >> $LOG
}

starting_point=''

getStartingPoint() {
  local_table=${1/public_/public.}
  sql="SELECT ${2,,} FROM $local_table ORDER BY ${2,,} DESC LIMIT 1;"
  starting_point=`/usr/bin/psql -t -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$sql" | head -1 | xargs`
}

#log "Clear out Cloud Storage buckets"
/usr/bin/gsutil -m rm -r "gs://${GCS_BUCKET_NAME}/*" >> $LOG 2>&1

log "Run the queries in BigQuery to export data into Google Cloud Storage"
mkdir -p ${WORK_DIR}/${SQL_WORKDIR}

for sql_template in ${WORK_DIR}/${SQL_TEMPLATE}/*; do
  working_sql=${WORK_DIR}/${SQL_WORKDIR}/$(basename $sql_template)
  cp $sql_template $working_sql
  sed -i "s/GCS_BUCKET_NAME/${GCS_BUCKET_NAME}/g" $working_sql

  # SQL template files should be named like the table names with .sql
  table_name=$(basename ${sql_template%.*})

  # Clear out the export data destination (Google Cloud Storage bucket)
  /usr/bin/gsutil -m rm -r "gs://${GCS_BUCKET_NAME}/$table_name" >> $LOG 2>&1  

  if [ "${bq_table_behavior[$table_name]}" != "REPLACE" ]; then
    getStartingPoint $table_name ${bq_table_behavior[$table_name]}
    log "Import starting from ${bq_table_behavior[$table_name]} for table $table_name"
    sed -i "s/${bq_table_behavior[$table_name]}/$starting_point/g" $working_sql
  else
    log "Importing the entire table $table_name"
  fi

  log "Running $working_sql"
  /usr/bin/bq query --apilog stdout --use_legacy_sql=false --dataset_id lens-public-data:polygon "$(cat $working_sql)" >> $LOG 2>&1
done

log "Remove folders in local drive and downloading CSV files from GCS "
mkdir -p ${WORK_DIR}/${EXPORT_DIR}
mkdir -p ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}
/usr/bin/gsutil -m cp -r "gs://${GCS_BUCKET_NAME}/*" ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/ >> $LOG 2>&1

# Define an array to store directory names
dirs=()

# Loop through all directories in the current directory and add them to the array
for dir in ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/*/; do
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
done

log "Backup work directory for audit purposes and clean it up the temporary folder"
rm -fr ${WORK_DIR}/${EXPORT_DIR}/*
cp -pr ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/* ${WORK_DIR}/${EXPORT_DIR}/
rm -fr ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}

log "Script $0 COMPLETED!"

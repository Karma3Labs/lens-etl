#!/bin/bash
WORK_DIR=${WORK_DIR:-"/home/ubuntu/lens-etl"}; source $WORK_DIR/.env
GCS_BUCKET_NAME=${GCS_BUCKET_NAME:-${GCS_BUCKET_FULL:-""}}
GCP_ACTIVE_ACCT=$(gcloud auth list|grep "*"|awk {'print $2'})
GCP_TASK_ACCT=${GCP_TASK_ACCT:-"$(gcloud config get account --quiet)"}
DB_HOST=${DB_HOST:-172.17.0.1}
DB_PORT=${DB_PORT:-5432}
DB_USER=${DB_USER:-postgres}
DB_NAME=${DB_NAME:-lens_bigquery}
SQL_TEMPLATE=${SQL_TEMPLATE:-sql-import-full}
EXPORT_DIR=buckets-full
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

function log() {
    echo "*******************************************************************************************************" >> $LOG
    echo "`date` - $1" >> $LOG
}

# Switch to a task-related GCP account if it is different with the active account
if [ $GCP_TASK_ACCT != $GCP_ACTIVE_ACCT ]; then
  gcloud config set account "$GCP_TASK_ACCT"
fi

log "Clear out Cloud Storage buckets"
/usr/bin/gsutil -m rm -r "gs://${GCS_BUCKET_NAME}/*" >> $LOG 2>&1

declare -a pids

function process_sqlfile() {
  local sqlfile=$1
  log "Running $sqlfile"
  sed "s/GCS_BUCKET_NAME/${GCS_BUCKET_NAME}/g" $sqlfile > $sqlfile-${JOBTIME}
  /usr/bin/bq query --use_cache --nouse_legacy_sql --dataset_id "${BQ_DATASET}" "$(cat $sqlfile-${JOBTIME})" >> $LOG 2>&1 &
  rm $sqlfile-${JOBTIME}
}

log "Run the queries in BigQuery to export data into Google Cloud Storage"
for sqlfile in ${WORK_DIR}/${SQL_TEMPLATE}/*; do
  process_sqlfile "$sqlfile" &
  pids+=($!)
done

# Wait for all background processes to finish
for pid in "${pids[@]}"; do
  wait $pid
done

log "Importing files from Cloud Storage and remove the old ones"
mkdir -p ${WORK_DIR}/${EXPORT_DIR}
mkdir -p ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}
/usr/bin/gsutil -m cp -r "gs://${GCS_BUCKET_NAME}/*" ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/ >> $LOG 2>&1

# Switch back to your current active account if it is different
if [ $GCP_TASK_ACCT != $GCP_ACTIVE_ACCT ]; then
  echo "Setting GCS account as $GCP_TASK_ACCT"
  gcloud config set account "$GCP_ACTIVE_ACCT"
fi

# Define an array to store directory names
dirs=()
tables=()

process_db_updates() {
  local dir=$1
  # Remove the trailing slash from the directory name
  dir="${dir%/}"
  dirs+=("$dir")
  files=$(ls -1 "$dir")

  # Table names in BigQuery are "public_*" while Postgres are "public.*"
  table="${dir/public_/public.}"
  table=$(basename "$table")
  tables+=("$table")

  # We have to TRUNCATE the table every time since ON CONFLICT UPDATE is not supported in most Postgres versions
  log "CREATE a new table ${table}_new"
  /usr/bin/psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "CREATE TABLE IF NOT EXISTS ${table}_new (LIKE $table);" >> $LOG 2>&1
  for file in ${files[@]}; do
    log "Importing $file into ${table}_new"
    /usr/bin/psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\COPY ${table}_new FROM '$dir/$file' WITH (DELIMITER ',', FORMAT csv, HEADER true)" >> $LOG 2>&1
  done
  log "INSERT records from ${table}_new to $table"
  /usr/bin/psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "TRUNCATE TABLE $table; INSERT INTO $table SELECT * FROM ${table}_new ON CONFLICT DO NOTHING; DROP TABLE ${table}_new CASCADE;" >> $LOG 2>&1
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
/usr/bin/psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f ${WORK_DIR}/refresh_materialized_view.sql

log "Script $0 COMPLETED!"

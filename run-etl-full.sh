#!/bin/bash
WORK_DIR=/home/ubuntu/lens-etl
SQL_TEMPLATE=sql-import-full
GCS_BUCKET_NAME=k3l-lens-bigquery-full
EXPORT_DIR=buckets-full
LOG=/var/log/lens-etl/$(basename "$0").log
DB_HOST=172.17.0.1
DB_USER=postgres
DB_NAME=lens_bigquery

JOBTIME=$(date +%Y%m%d%H%M%S)

function log() {
    echo "*******************************************************************************************************" >> $LOG
    echo "`date` - $1" >> $LOG
}

log "Clear out Cloud Storage buckets"
/usr/bin/gsutil -m rm -r "gs://${GCS_BUCKET_NAME}/*" >> $LOG 2>&1

log "Run the queries in BigQuery to export data into Google Cloud Storage"
for sqlfile in ${WORK_DIR}/${SQL_TEMPLATE}/*; do
  log "Running $sqlfile"
  /usr/bin/bq query --apilog stdout --use_legacy_sql=false --dataset_id lens-public-data:polygon "$(cat $sqlfile)" >> $LOG 2>&1
done

log "Importing files from Cloud Storage and remove the old ones"
mkdir -p ${WORK_DIR}/${EXPORT_DIR}
mkdir -p ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}
/usr/bin/gsutil -m cp -r "gs://${GCS_BUCKET_NAME}/*" ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/ >> $LOG 2>&1

# Define an array to store directory names
dirs=()
tables=()

# Loop through all directories in the current directory and add them to the array
for dir in ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/*/; do
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
  /usr/bin/psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "CREATE TABLE IF NOT EXISTS ${table}_new (LIKE $table INCLUDING ALL);" >> $LOG 2>&1
  for file in ${files[@]}; do
    log "Importing $file into ${table}_new"
    /usr/bin/psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "\COPY ${table}_new FROM '$dir/$file' WITH (DELIMITER ',', FORMAT csv, HEADER true)" >> $LOG 2>&1
  done
  log "INSERT records from ${table}_new to $table"
  # /usr/bin/psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "DROP TABLE IF EXISTS $table; ALTER TABLE IF EXISTS ${table}_new RENAME TO ${table##*.}" >> $LOG 2>&1
  /usr/bin/psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "TRUNCATE TABLE $table; INSERT INTO $table SELECT * FROM ${table}_new ON CONFLICT DO NOTHING; DROP TABLE ${table}_new;" >> $LOG 2>&1
done

log "Backup work directory for audit purposes and clean it up the temporary folder"
rm -fr ${WORK_DIR}/${EXPORT_DIR}/*
cp -pr ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}/* ${WORK_DIR}/${EXPORT_DIR}/
rm -fr ${WORK_DIR}/${EXPORT_DIR}-${JOBTIME}

log "Script $0 COMPLETED!"

# Overview
This is the Extract-Transform-Load (ETL) scripts to migrate a copy of Lens BigQuery dataset into a local Postgres DB. The 
process is exhaustive, involving extraction from Lens BigQuery into CSVs exported into Google Cloud Storage (GCS) buckets, 
then retrieving the CSVs into your local drive to then be loaded into Postgres DB.  There are two types of jobs, one involving
a full refresh and a second using partial updates depending on the last relevant timestamp field in some select tables.  Not
all tables can be supported by partial updates, such as those that have analytics data (stats counting followers, for example).

# Setting up the ETL

## Pre-requisites
The following are the necessary pre-requisites to begin.  Please go through these steps to setup your environment and necessary accounts properly.
- a Linux-based server, preferably Ubuntu
- a good understanding of `bash` scripting, Docker management and `crontab` to manage the scripts, maintain the database and run scheduled cron jobs
- a Google Cloud account, with a private key configured via [gsutil](https://cloud.google.com/storage/docs/gsutil/commands/config), with IAM privileges to access BigQuery and GCS
- gain a general understanding of the [Lens BigQuery](https://docs.lens.xyz/docs/public-big-query) setup
- an installed [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) to run `gcloud`, `gutil` and `bq` commands
- an installed Docker binary (you'll need a DockerHub account too)
- a Postgres database, available via [Docker Hub](https://hub.docker.com/_/postgres)
- enable [.pgpass](https://tableplus.com/blog/2019/09/how-to-use-pgpass-in-postgresql.html) to run Postgres CLI such as `psql` without a password challenge
- preferably sudo capability, to setup create log folders at `/var/log/lens-etl`, adding new accounts like `postgres`, and target data folders for the database like `/var/lib/postgresql`

## Step 1 - Setup your environment
The following is an example of the setup steps necessary to get things going
```
# Environment setting
DB_PASS=(your-password)
DB_NAME=lens_db
NETWORK=lens-net
BUFFER_SIZE=16GB  # Set this to half of your server's memory

# Prometheus via Docker
sudo useradd -rs /bin/false postgres
sudo mkdir -p /var/lib/postgresql/data/${DB_NAME}
sudo chown -R postgres:postgres /var/lib/postgresql

# This is optional, assuming you already have a DockerHub account
sudo docker login
sudo docker create network ${NETWORK}

# Find Linux User & Group ID, since username does not work in Docker (bug?)
UIDGID=`grep postgres /etc/passwd | awk -F[:] '{print $3":"$4}'`

docker run --name ${DB_NAME} -p 5432:5432 --network ${NETWORK} \
--user $UIDGID -d \
-e POSTGRES_PASSWORD=$DB_PASS \
-e PGDATA=/var/lib/postgresql/data/${DB_NAME} \
-v /var/lib/postgresql/data/${DB_NAME}:/var/lib/postgresql/data/${DB_NAME} \
-v /etc/postgresql:/etc/postgresql \
-v /usr/share/postgresql:/usr/share/postgresql \
postgres \
-c shared_buffers=${BUFFER_SIZE} -c max_connections=1000
```

## Step 2 - Setup your local database
Once you have Postgres up and running, run a script to create a database called `lens_db`.  Then populate it with the default schema that will be used as part of the ETL process.
```
# Check via ipconfig to see what your Docker's internal host IP address is
HOST=172.17.0.1
psql -h ${HOST} -U postgres -c 'CREATE DATABASE lens_db;'
```

Bootstrap the database by creating tables necessary to receive the dataset from Lens BigQuery
```
psql -h ${HOST} -U postgres -f lens_bigquery_schema.sql
```


## Step 3 - Review ETL scripts
`run-etl-full.sh` - This script will perform a full export of several tables at Lens BigQuery as specified in the `sql-import-full/` 
folder.  Each SQL script will request BigQuery to `EXPORT DATA` in a form of comma-separated values (CSVs) into Google Cloud Service (GCS) 
in an orderly manner, based on the primary key of each table.  This will help the export process be repeatable and not run into any duplicate 
records, as the exports are partitioned into multiple CSV files when the exports approaches on 1GB per CSV file.

`run-etl-update.sh` - This script will retrieve only records that are not available or are different in your local Postgres DB tables.  
As you inspect the script, the process depends on SQL templates in `sql-import-update/` to only request BigQuery for data that isn't 
available in your local DB based on timestamps, usually the `block_timestamp` field.  For example, if there are new users that joined Lens 
since the last ETL was run, then only retrieve `profile` records that have `block_timestamp` that's greater than the latest `profile` record.
On the other hand, for tables that are periodically updated, such as `profile_stats`, then the entire table is exported and updated locally as 
you run the ETL script.

## Step 4 - Automate the ETL scripts (optional)
Once you've successfully tested the scripts and review the data imported, you may wish to automate the script to run on a periodic basis.  Below is an 
example of an import strategy to retrieve Lens BigQuery data on an hourly basis, and perform a full update at 2300 hours (local server time)
```
HOME=/home/ubuntu
# Run full import from Lens BQ at 11PM PST daily and every hour for updates
(crontab -l 2>/dev/null; echo "0 23 * * * $HOME/lens-etl/run-etl-refresh.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 0-22 * * * $HOME/lens-etl/run-etl-update.sh") | crontab -
```

# Next Steps
These ETL scripts can be repurposed for other BigQuery datasets that developers may need in order to run computation which regularly queries 
the database.  Running a local copy will avoid the cloud transfer latencies and the cost of running on BigQuery.  Feel free to fork this script 
or improve upon it by submitting a pull request.

If there are any questions, reach out to us on [Discord](https://k3l.io/discord) or [Telegram](https://t.me/Karma3Labs), and follow us on [Twitter](https://twitter.com/Karma3Labs).


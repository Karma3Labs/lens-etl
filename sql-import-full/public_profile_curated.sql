EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_profile_curated/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    profile_id,
    created_on,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_profile_curated
  ORDER BY
    profile_id
);


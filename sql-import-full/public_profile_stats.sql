EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_profile_stats/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    profile_id,
    total_posts,
    total_comments,
    total_mirrors,
    total_publications,
    total_collects,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_profile_stats
  ORDER BY
    profile_id
);


EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_publication_stats/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    publication_id,
    total_amount_of_collects,
    total_amount_of_mirrors,
    total_amount_of_comments,
    total_upvotes,
    total_downvotes,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_publication_stats
  ORDER BY
    publication_id
);

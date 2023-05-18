EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_follower/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    address, 
    follow_profile_id, 
    block_timestamp, 
    created_block_hash,
    is_finalised_on_chain, 
    optimistic_id, 
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_follower
  WHERE
    block_timestamp > 'BLOCK_BLOCK_TIMESTAMP'
  ORDER BY
    block_timestamp DESC
);

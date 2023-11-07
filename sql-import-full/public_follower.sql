EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_follower/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    pf.profile_id,
    pf.profile_follower_id AS follow_profile_id, 
    pf.block_timestamp, 
    pf.block_hash AS created_block_hash,
    true AS is_finalised_on_chain, 
    NULL as optimistic_id, 
    pf.datastream_metadata.uuid, 
    pf.datastream_metadata.source_timestamp 
  FROM
    profile_follower AS pf
  ORDER BY
    profile_id, follow_profile_id
);

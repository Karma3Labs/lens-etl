EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_follower/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    pr.owned_by AS address, 
    pf.profile_follower_id AS follow_profile_id, 
    pf.block_timestamp, 
    pf.block_hash AS created_block_hash,
    true AS is_finalised_on_chain, 
    NULL as optimistic_id, 
    pf.datastream_metadata.uuid, 
    pf.datastream_metadata.source_timestamp 
  FROM
    profile_follower AS pf
    JOIN profile_record AS pr ON pf.profile_id = pr.profile_id
  ORDER BY
    address, follow_profile_id
);

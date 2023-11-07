EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_publication_collect_module_collected_records/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    publication_id,
    owner_address as collected_by,
    NULL as referral_id,
    token_id as collect_publication_nft_id,
    block_timestamp,
    block_hash as created_block_hash,
    publication_id || '-' || token_id as record_id,
    true as is_finalised_on_chain,
    NULL as optimistic_id,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    publication_open_action_module_collect_nft_ownership
  ORDER BY
    record_id
);






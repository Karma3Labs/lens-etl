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
    collected_by,
    referral_id,
    collect_publication_nft_id,
    block_timestamp,
    created_block_hash,
    record_id,
    is_finalised_on_chain,
    optimistic_id,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_publication_collect_module_collected_records
  WHERE
    block_timestamp > 'BLOCK_BLOCK_TIMESTAMP'
  ORDER BY
    block_timestamp DESC
);

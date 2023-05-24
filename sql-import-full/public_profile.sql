EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_profile/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    profile_id, 
    name, 
    handle,
    profile_with_weights, 
    profile_picture_s3_url, 
    cover_picture_s3_url, 
    is_profile_picture_onchain,
    owned_by,
    is_burnt,
    nft_contract,
    nft_token_id,
    nft_owner,
    nft_chain_id,
    is_default,
    metadata_url,
    metadata_s3_url,
    is_metadata_processed,
    has_error,
    timeout_request,
    metadata_error_reason,
    app_id,
    metadata_block_timestamp,
    metadata_created_block_hash,
    metadata_tx_hash,
    block_timestamp,
    created_block_hash,
    datastream_metadata.uuid,
    datastream_metadata.source_timestamp
  FROM
    public_profile
  ORDER BY
    profile_id
);

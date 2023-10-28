EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_profile/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    pr.profile_id,
    pm.name,
    nh.local_name AS handle,
    pm.profile_with_weights,
    pm.profile_picture_snapshot_location_url AS profile_picture_s3_url,
    pm.cover_picture_snapshot_location_url AS cover_picture_s3_url,
    false AS is_profile_picture_onchain,
    pr.owned_by,
    pr.is_burnt,
    NULL AS nft_contract,
    NULL AS nft_token_id,
    NULL AS nft_owner,
    NULL AS nft_chain_id,
    false AS is_default,
    pm.metadata_uri AS metadata_url,
    pm.metadata_snapshot_location_url AS metadata_s3_url,
    NULL AS is_metadata_processed,
    NULL AS has_error,
    NULL AS timeout_request,
    NULL AS metadata_error_reason,
    pm.app AS app_id,
    pm.block_timestamp AS metadata_block_timestamp,
    pm.block_hash AS metadata_created_block_hash,
    pm.tx_hash AS metadata_tx_hash,
    pr.block_timestamp AS block_timestamp,
    pr.block_hash AS created_block_hash,
    pr.datastream_metadata.uuid, 
    pr.datastream_metadata.source_timestamp 
  FROM
    profile_record AS pr
    JOIN profile_metadata AS pm ON pm.profile_id = pr.profile_id
    JOIN namespace_handle AS nh ON nh.owned_by = pr.owned_by
  WHERE
    block_timestamp > 'BLOCK_TIMESTAMP'
  ORDER BY
    block_timestamp DESC
);

EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_post_comment/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    comment_id,
    contract_publication_id,
    comment_by_profile_id,
    post_id,
    content_uri,
    s3_metadata_location,
    related_to_comment_id,
    collect_nft_address,
    reference_implementation,
    reference_return_data,
    is_metadata_processed,
    has_error,
    metadata_error_reason,
    tx_hash,
    is_hidden,
    app_id,
    timeout_request,
    block_timestamp,
    created_block_hash,
    metadata_version,
    language,
    region,
    content_warning,
    main_content_focus,
    tags_vector,
    custom_filters_gardener_flagged,
    content,
    is_gated,
    is_data_availability,
    data_availability_proofs,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_post_comment
  WHERE
    block_timestamp > 'BLOCK_BLOCK_TIMESTAMP'
  ORDER BY
    block_timestamp DESC
);

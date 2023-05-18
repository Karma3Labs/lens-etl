EXPORT DATA
  OPTIONS (
    uri = 'gs://k3l-lens-bigquery-jack/public_profile_post/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    post_id,
    contract_publication_id,
    profile_id,
    content_uri,
    s3_metadata_location,
    collect_nft_address,
    reference_implementation,
    reference_return_data,
    is_related_to_post,
    is_related_to_comment,
    is_metadata_processed,
    has_error,
    metadata_error_reason,
    tx_hash,
    is_hidden,
    timeout_request,
    app_id,
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
    public_profile_post
  ORDER BY
    post_id
);

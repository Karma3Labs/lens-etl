EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_profile_post/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  WITH
    _posts AS (
      SELECT
        publication_id
      FROM
        publication_record
      WHERE
        publication_type = 'POST'
    ),
    _comments AS (
      SELECT
        publication_id
      FROM
        publication_record
      WHERE
        publication_type = 'COMMENT'
    )
  SELECT 
    pr.publication_id AS post_id,
    pr.contract_publication_id,
    pr.profile_id,
    pr.content_uri,
    pr.content_uri AS s3_metadata_location,
    cn.nft_address AS collect_nft_address,
    rm.implementation AS reference_implementation,
    rm.init_return_data AS reference_return_data,
    _posts.publication_id AS is_related_to_post,
    _comments.publication_id AS is_related_to_comment,
    true AS is_metadata_processed,
    (
      CASE 
        WHEN pf.id IS NOT NULL THEN true
        ELSE false
      END
    ) AS has_error,
    pf.failed_reason AS metadata_error_reason,
    pr.tx_hash,
    pr.is_hidden,
    pf.timeout_request,
    pr.app AS app_id,
    pr.block_timestamp,
    pr.block_hash AS created_block_hash,
    pm.metadata_version,
    pm.language,
    pm.region,
    pm.content_warning,
    pm.main_content_focus,
    pm.tags_vector,
    pr.gardener_flagged AS custom_filters_gardener_flagged,
    pm.content,
    false AS is_gated,
    pr.is_momoka AS is_data_availability,
    pr.momoka_proof AS data_availability_proofs,
    pr.datastream_metadata.uuid, 
    pr.datastream_metadata.source_timestamp
  FROM
    publication_record AS pr
    LEFT JOIN publication_open_action_module_collect_nft AS cn ON cn.publication_id = pr.publication_id
    LEFT JOIN publication_reference_module AS rm ON rm.publication_id = pr.publication_id
    LEFT JOIN publication_failed AS pf ON pf.tx_hash = pr.tx_hash
    LEFT JOIN publication_metadata AS pm ON pm.publication_id = pr.publication_id
    LEFT JOIN _comments ON _comments.publication_id = pr.parent_publication_id
    LEFT JOIN _posts ON _posts.publication_id = pr.parent_publication_id
  WHERE
    block_timestamp > 'BLOCK_TIMESTAMP'
    AND pr.publication_type <> 'COMMENT'
  ORDER BY
    block_timestamp DESC
);

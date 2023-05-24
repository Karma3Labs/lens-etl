EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_publication_collect_module_details/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    publication_id,
    implementation,
    collect_raw_data,
    collect_limit,
    amount,
    follower_only,
    currency,
    recipient,
    referral_fee,
    end_timestamp,
    block_timestamp,
    created_block_hash,
    vault,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_publication_collect_module_details
  ORDER BY
    publication_id
);

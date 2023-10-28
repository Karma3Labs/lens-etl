-- BQ has duplicates whereas in PG we don't want duplicates
EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_publication_collect_module_details/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT * except(row_num) FROM (
    SELECT 
      publication_id,
      implementation,
      init_data as collect_raw_data,
      collect_limit,
      amount,
      follower_only,
      currency,
      recipient,
      referral_fee,
      end_timestamp,
      block_timestamp,
      block_hash as created_block_hash,
      vault,
      datastream_metadata.uuid, 
      datastream_metadata.source_timestamp 
    FROM
      publication_open_action_module
    WHERE
      amount IS NOT NULL
    ORDER BY
      publication_id
  ) t
  WHERE row_num=1
);

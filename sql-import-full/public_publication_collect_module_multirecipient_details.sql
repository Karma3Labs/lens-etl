EXPORT DATA
  OPTIONS (
    uri = 'gs://k3l-lens-bigquery-jack/public_publication_collect_module_multirecipient_details/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    publication_id,
    recipient,
    split,
    index,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_publication_collect_module_multirecipient_details
  ORDER BY
    publication_id, recipient
);

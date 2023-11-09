EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_publication_reaction_records/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    pr.publication_id,
    pr.type as reaction,
    pr.actioned_by_profile_id,
    pr.action_at,
    null AS undone_on,
    false AS has_undone,
    null AS record_id,
    datastream_metadata.uuid,
    datastream_metadata.source_timestamp
  FROM
    publication_reaction AS pr
  ORDER BY
    publication_id
);

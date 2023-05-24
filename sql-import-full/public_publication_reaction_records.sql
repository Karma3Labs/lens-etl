EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_publication_reaction_records/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  SELECT 
    publication_id,
    reaction,
    actioned_by_profile_id,
    action_at,
    undone_on,
    has_undone,
    record_id,
    datastream_metadata.uuid, 
    datastream_metadata.source_timestamp 
  FROM
    public_publication_reaction_records
  ORDER BY
    record_id
);

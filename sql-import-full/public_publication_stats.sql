EXPORT DATA
  OPTIONS (
    uri = 'gs://GCS_BUCKET_NAME/public_publication_stats/*.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ',')
AS (
  WITH reaction AS (
    select
      publication_id,
      SUM(CASE WHEN reaction_type='UPVOTE' THEN total ELSE 0 END) as total_upvotes,
      SUM(CASE WHEN reaction_type='DOWNVOTE' THEN total ELSE 0 END) as total_downvotes
    from 
      global_stats_publication_reaction
    group by publication_id
  )
  SELECT
    stats.publication_id,
    stats.total_amount_of_collects,
    stats.total_amount_of_mirrors,
    stats.total_amount_of_comments,
    ifnull(reaction.total_upvotes, 0) as total_upvotes,
    ifnull(reaction.total_downvotes, 0) as total_downvotes,
    stats.datastream_metadata.uuid, 
    stats.datastream_metadata.source_timestamp 
  FROM
  global_stats_publication as stats
  LEFT JOIN reaction
            ON (stats.publication_id=reaction.publication_id)
  ORDER BY
    publication_id
);

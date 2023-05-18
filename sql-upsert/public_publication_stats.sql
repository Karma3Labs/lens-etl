-- For publication_stats table
INSERT INTO public.publication_stats
SELECT * FROM public.publication_stats_tmp
ON CONFLICT (publication_id)
DO UPDATE SET
    total_amount_of_collects = EXCLUDED.total_amount_of_collects,
    total_amount_of_mirrors = EXCLUDED.total_amount_of_mirrors,
    total_amount_of_comments = EXCLUDED.total_amount_of_comments,
    total_upvotes = EXCLUDED.total_upvotes,
    total_downvotes = EXCLUDED.total_downvotes,
    uuid = EXCLUDED.uuid,
    source_timestamp = EXCLUDED.source_timestamp;

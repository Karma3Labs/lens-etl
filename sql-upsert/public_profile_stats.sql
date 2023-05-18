-- For profile_stats table
INSERT INTO public.profile_stats
SELECT * FROM public.profile_stats_tmp
ON CONFLICT (profile_id)
DO UPDATE SET
    total_posts = EXCLUDED.total_posts,
    total_comments = EXCLUDED.total_comments,
    total_mirrors = EXCLUDED.total_mirrors,
    total_publications = EXCLUDED.total_publications,
    total_collects = EXCLUDED.total_collects,
    uuid = EXCLUDED.uuid,
    source_timestamp = EXCLUDED.source_timestamp;

-- For profile_stats table
INSERT INTO public.profile_curated
SELECT * FROM public.profile_curated_tmp
ON CONFLICT (profile_id)
DO UPDATE SET
    created_on = EXCLUDED.created_on,
    uuid = EXCLUDED.uuid,
    source_timestamp = EXCLUDED.source_timestamp;

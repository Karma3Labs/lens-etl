-- For follower table
-- INSERT INTO public.follower
-- SELECT * FROM public.follower_tmp
-- ON CONFLICT (address, follow_profile_id)
-- DO UPDATE SET
--     block_timestamp = EXCLUDED.block_timestamp,
--     created_block_hash = EXCLUDED.created_block_hash,
--     is_finalised_on_chain = EXCLUDED.is_finalised_on_chain,
--     optimistic_id = EXCLUDED.optimistic_id,
--     uuid = EXCLUDED.uuid,
--     source_timestamp = EXCLUDED.source_timestamp;
TRUNCATE TABLE public.follower; 
INSERT INTO public.follower 
    SELECT * FROM public.follower_tmp ON CONFLICT DO NOTHING;
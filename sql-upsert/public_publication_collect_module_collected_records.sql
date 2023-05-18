-- For publication_collect_module_collected_records table
INSERT INTO public.publication_collect_module_collected_records
SELECT * FROM public.publication_collect_module_collected_records_tmp
ON CONFLICT (record_id)
DO UPDATE SET
    publication_id = EXCLUDED.publication_id,
    collected_by = EXCLUDED.collected_by,
    referral_id = EXCLUDED.referral_id,
    collect_publication_nft_id = EXCLUDED.collect_publication_nft_id,
    block_timestamp = EXCLUDED.block_timestamp,
    created_block_hash = EXCLUDED.created_block_hash,
    is_finalised_on_chain = EXCLUDED.is_finalised_on_chain,
    optimistic_id = EXCLUDED.optimistic_id,
    uuid = EXCLUDED.uuid,
    source_timestamp = EXCLUDED.source_timestamp;

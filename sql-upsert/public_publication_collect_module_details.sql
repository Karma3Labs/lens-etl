-- For publication_collect_module_details table
INSERT INTO public.publication_collect_module_details
SELECT * FROM public.publication_collect_module_details_tmp
ON CONFLICT (publication_id)
DO UPDATE SET
    implementation = EXCLUDED.implementation,
    collect_raw_data = EXCLUDED.collect_raw_data,
    collect_limit = EXCLUDED.collect_limit,
    amount = EXCLUDED.amount,
    follower_only = EXCLUDED.follower_only,
    currency = EXCLUDED.currency,
    recipient = EXCLUDED.recipient,
    referral_fee = EXCLUDED.referral_fee,
    end_timestamp = EXCLUDED.end_timestamp,
    block_timestamp = EXCLUDED.block_timestamp,
    created_block_hash = EXCLUDED.created_block_hash,
    vault = EXCLUDED.vault,
    uuid = EXCLUDED.uuid,
    source_timestamp = EXCLUDED.source_timestamp;

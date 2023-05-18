-- For publication_collect_module_multirecipient_details table
INSERT INTO public.publication_collect_module_multirecipient_details
SELECT * FROM public.publication_collect_module_multirecipient_details_tmp
ON CONFLICT (publication_id, recipient)
DO UPDATE SET
    split = EXCLUDED.split,
    index = EXCLUDED.index,
    uuid = EXCLUDED.uuid,
    source_timestamp = EXCLUDED.source_timestamp;

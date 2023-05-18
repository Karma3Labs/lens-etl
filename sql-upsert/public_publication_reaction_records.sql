INSERT INTO public.publication_reaction_records
SELECT * FROM public.publication_reaction_records_tmp
ON CONFLICT (record_id)
DO UPDATE SET
    publication_id = EXCLUDED.publication_id,
    reaction = EXCLUDED.reaction,
    actioned_by_profile_id = EXCLUDED.actioned_by_profile_id,
    action_at = EXCLUDED.action_at,
    undone_on = EXCLUDED.undone_on,
    has_undone = EXCLUDED.has_undone,
    uuid = EXCLUDED.uuid,
    source_timestamp = EXCLUDED.source_timestamp;

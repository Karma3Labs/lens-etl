-- For publication_collect_module_collected_records table
TRUNCATE TABLE public.publication_collect_module_collected_records; 
INSERT INTO public.publication_collect_module_collected_records 
    SELECT * FROM public.publication_collect_module_collected_records_tmp ON CONFLICT DO NOTHING;

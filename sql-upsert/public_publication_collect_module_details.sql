-- For publication_collect_module_details table
TRUNCATE TABLE public.publication_collect_module_details; 
INSERT INTO public.publication_collect_module_details 
    SELECT * FROM public.publication_collect_module_details_tmp ON CONFLICT DO NOTHING;

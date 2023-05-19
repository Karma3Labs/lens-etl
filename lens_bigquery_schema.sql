--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Ubuntu 15.2-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: follower; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.follower (
    address character varying(42) NOT NULL,
    follow_profile_id character varying(66) NOT NULL,
    block_timestamp timestamp with time zone,
    created_block_hash character varying(66),
    is_finalised_on_chain boolean,
    optimistic_id character varying(1000),
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.follower OWNER TO postgres;

--
-- Name: profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile (
    profile_id character varying(66) NOT NULL,
    name character varying(8000),
    handle character varying,
    profile_with_weights character varying,
    profile_picture_s3_url character varying(400),
    cover_picture_s3_url character varying(400),
    is_profile_picture_onchain boolean,
    owned_by character varying(42),
    is_burnt boolean,
    nft_contract character varying(42),
    nft_token_id character varying(500),
    nft_owner character varying(42),
    nft_chain_id integer,
    is_default boolean,
    metadata_url character varying(400),
    metadata_s3_url character varying(400),
    is_metadata_processed boolean,
    has_error boolean,
    timeout_request boolean,
    metadata_error_reason character varying,
    app_id character varying(500),
    metadata_block_timestamp timestamp with time zone,
    metadata_created_block_hash character varying(66),
    metadata_tx_hash character varying(66),
    block_timestamp timestamp with time zone,
    created_block_hash character varying(66),
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.profile OWNER TO postgres;

--
-- Name: publication_collect_module_collected_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publication_collect_module_collected_records (
    publication_id character varying(133),
    collected_by character varying(42),
    referral_id character varying(133),
    collect_publication_nft_id character varying(66),
    block_timestamp timestamp with time zone,
    created_block_hash character varying(66),
    record_id character varying NOT NULL,
    is_finalised_on_chain boolean,
    optimistic_id character varying(1000),
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.publication_collect_module_collected_records OWNER TO postgres;

--
-- Name: post_comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_comment (
    comment_id character varying(133) NOT NULL,
    contract_publication_id character varying(66),
    comment_by_profile_id character varying(66),
    post_id character varying(133),
    content_uri character varying(500),
    s3_metadata_location character varying(500),
    related_to_comment_id character varying(133),
    collect_nft_address character varying(42),
    reference_implementation character varying(42),
    reference_return_data character varying(1000),
    is_metadata_processed boolean,
    has_error boolean,
    metadata_error_reason character varying,
    tx_hash character varying(66),
    is_hidden boolean,
    app_id character varying(500),
    timeout_request boolean,
    block_timestamp timestamp with time zone,
    created_block_hash character varying(66),
    metadata_version character varying(5),
    language character varying(2),
    region character varying(2),
    content_warning character varying(50),
    main_content_focus character varying(50),
    tags_vector character varying,
    custom_filters_gardener_flagged boolean,
    content character varying,
    is_gated boolean,
    is_data_availability boolean,
    data_availability_proofs character varying(200),
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.post_comment OWNER TO postgres;

--
-- Name: profile_post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile_post (
    post_id character varying(133) NOT NULL,
    contract_publication_id character varying(66),
    profile_id character varying(66),
    content_uri character varying,
    s3_metadata_location character varying(500),
    collect_nft_address character varying(42),
    reference_implementation character varying(42),
    reference_return_data character varying(1000),
    is_related_to_post character varying(133),
    is_related_to_comment character varying(133),
    is_metadata_processed boolean,
    has_error boolean,
    metadata_error_reason character varying,
    tx_hash character varying(66),
    is_hidden boolean,
    timeout_request boolean,
    app_id character varying(500),
    block_timestamp timestamp with time zone,
    created_block_hash character varying(66),
    metadata_version character varying(5),
    language character varying(2),
    region character varying(2),
    content_warning character varying(50),
    main_content_focus character varying(50),
    tags_vector character varying,
    custom_filters_gardener_flagged boolean,
    content character varying,
    is_gated boolean,
    is_data_availability boolean,
    data_availability_proofs character varying(200),
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.profile_post OWNER TO postgres;

--
-- Name: profile_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile_stats (
    profile_id character varying(66) NOT NULL,
    total_posts bigint,
    total_comments bigint,
    total_mirrors bigint,
    total_publications bigint,
    total_collects bigint,
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.profile_stats OWNER TO postgres;

--
-- Name: publication_collect_module_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publication_collect_module_details (
    publication_id character varying(133) NOT NULL,
    implementation character varying(42),
    collect_raw_data character varying(3000),
    collect_limit character varying(66),
    amount character varying(100),
    follower_only boolean,
    currency character varying(42),
    recipient character varying(42),
    referral_fee character varying,
    end_timestamp timestamp with time zone,
    block_timestamp timestamp with time zone,
    created_block_hash character varying(66),
    vault character varying(42),
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.publication_collect_module_details OWNER TO postgres;

--
-- Name: publication_collect_module_multirecipient_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publication_collect_module_multirecipient_details (
    publication_id character varying(133) NOT NULL,
    recipient character varying(42) NOT NULL,
    split character varying,
    index bigint,
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.publication_collect_module_multirecipient_details OWNER TO postgres;

--
-- Name: publication_reaction_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publication_reaction_records (
    publication_id character varying(133),
    reaction character varying(300),
    actioned_by_profile_id character varying(66),
    action_at timestamp with time zone,
    undone_on timestamp with time zone,
    has_undone boolean,
    record_id character varying NOT NULL,
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.publication_reaction_records OWNER TO postgres;

--
-- Name: publication_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publication_stats (
    publication_id character varying(133) NOT NULL,
    total_amount_of_collects bigint,
    total_amount_of_mirrors bigint,
    total_amount_of_comments bigint,
    total_upvotes bigint,
    total_downvotes bigint,
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.publication_stats OWNER TO postgres;


--
-- Name: follower follower_new_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_new_pkey PRIMARY KEY (address, follow_profile_id);


--
-- Name: post_comment post_comment_new_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comment
    ADD CONSTRAINT post_comment_new_pkey PRIMARY KEY (comment_id);


--
-- Name: profile_post profile_post_new_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_post
    ADD CONSTRAINT profile_post_new_pkey1 PRIMARY KEY (post_id);


--
-- Name: profile_stats profile_stats_new_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_stats
    ADD CONSTRAINT profile_stats_new_pkey PRIMARY KEY (profile_id);


--
-- Name: profile public_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT public_profile_pkey PRIMARY KEY (profile_id);


--
-- Name: publication_collect_module_collected_records publication_collect_module_collected_records_new_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication_collect_module_collected_records
    ADD CONSTRAINT publication_collect_module_collected_records_new_pkey PRIMARY KEY (record_id);


--
-- Name: publication_collect_module_details publication_collect_module_details_new_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication_collect_module_details
    ADD CONSTRAINT publication_collect_module_details_new_pkey PRIMARY KEY (publication_id);


--
-- Name: publication_collect_module_multirecipient_details publication_collect_module_multirecipient_details_new_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication_collect_module_multirecipient_details
    ADD CONSTRAINT publication_collect_module_multirecipient_details_new_pkey PRIMARY KEY (publication_id, recipient);


--
-- Name: publication_stats publication_stats_new_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication_stats
    ADD CONSTRAINT publication_stats_new_pkey1 PRIMARY KEY (publication_id);


--
-- Name: publication_reaction_records record_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication_reaction_records
    ADD CONSTRAINT record_id PRIMARY KEY (record_id);

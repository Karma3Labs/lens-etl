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
-- Name: feed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feed (
    strategy_name text,
    post_id text NOT NULL,
    v double precision
);


ALTER TABLE public.feed OWNER TO postgres;

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
-- Name: globaltrust; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.globaltrust (
    strategy_name character varying(255),
    i character varying(255),
    v double precision,
    date date DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.globaltrust OWNER TO postgres;

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
-- Name: k3l_collect_nft; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_collect_nft AS
 SELECT concat(profile.profile_id, '-', publication_collect_module_collected_records.collect_publication_nft_id) AS collect_nft_id,
    profile.profile_id,
    publication_collect_module_collected_records.collect_publication_nft_id AS pub_id,
    "substring"((publication_collect_module_collected_records.publication_id)::text, 1, (POSITION(('-'::text) IN (publication_collect_module_collected_records.publication_id)) - 1)) AS to_profile_id,
    "substring"((publication_collect_module_collected_records.publication_id)::text, (POSITION(('-'::text) IN (publication_collect_module_collected_records.publication_id)) + 1)) AS to_pub_id,
    publication_collect_module_collected_records.record_id AS metadata,
    publication_collect_module_collected_records.block_timestamp AS created_at
   FROM (public.publication_collect_module_collected_records
     LEFT JOIN public.profile ON (((publication_collect_module_collected_records.collected_by)::text = (profile.owned_by)::text)))
  WITH NO DATA;


ALTER TABLE public.k3l_collect_nft OWNER TO postgres;

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
-- Name: k3l_comments; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_comments AS
 SELECT post_comment.comment_id,
    post_comment.comment_by_profile_id AS profile_id,
    post_comment.contract_publication_id AS pub_id,
    "substring"((post_comment.post_id)::text, 1, (POSITION(('-'::text) IN (post_comment.post_id)) - 1)) AS to_profile_id,
    "substring"((post_comment.post_id)::text, (POSITION(('-'::text) IN (post_comment.post_id)) + 1)) AS to_pub_id,
    post_comment.content_uri,
    post_comment.block_timestamp AS created_at
   FROM public.post_comment
  WITH NO DATA;


ALTER TABLE public.k3l_comments OWNER TO postgres;

--
-- Name: k3l_follows; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_follows AS
 SELECT profile.profile_id,
    follower.follow_profile_id AS to_profile_id,
    follower.block_timestamp AS created_at
   FROM (public.follower
     LEFT JOIN public.profile ON (((follower.address)::text = (profile.owned_by)::text)))
  WITH NO DATA;


ALTER TABLE public.k3l_follows OWNER TO postgres;

--
-- Name: k3l_follow_counts; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_follow_counts AS
 SELECT k3l_follows.to_profile_id,
    count(*) AS count
   FROM public.k3l_follows
  GROUP BY k3l_follows.to_profile_id
  WITH NO DATA;


ALTER TABLE public.k3l_follow_counts OWNER TO postgres;

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
-- Name: k3l_mirrors; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_mirrors AS
 SELECT related_posts.post_id,
    related_posts.profile_id,
    related_posts.pub_id,
    "substring"((related_posts.is_related_to)::text, 1, (POSITION(('-'::text) IN (related_posts.is_related_to)) - 1)) AS to_profile_id,
    "substring"((related_posts.is_related_to)::text, (POSITION(('-'::text) IN (related_posts.is_related_to)) + 1)) AS to_pub_id,
    related_posts.block_timestamp AS created_at
   FROM ( SELECT profile_post.post_id,
            profile_post.profile_id,
            profile_post.contract_publication_id AS pub_id,
            COALESCE(profile_post.is_related_to_post, profile_post.is_related_to_comment) AS is_related_to,
            profile_post.block_timestamp
           FROM public.profile_post
          WHERE ((profile_post.is_related_to_post IS NOT NULL) OR (profile_post.is_related_to_comment IS NOT NULL))) related_posts
  WITH NO DATA;


ALTER TABLE public.k3l_mirrors OWNER TO postgres;

--
-- Name: k3l_posts; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_posts AS
 SELECT profile_post.post_id,
    profile_post.profile_id,
    profile_post.contract_publication_id AS pub_id,
    profile_post.content_uri,
    profile_post.block_timestamp AS created_at
   FROM public.profile_post
  WITH NO DATA;


ALTER TABLE public.k3l_posts OWNER TO postgres;

--
-- Name: k3l_profiles; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_profiles AS
 SELECT profile.profile_id,
    profile.owned_by AS owner_address,
    profile.handle,
    profile.profile_picture_s3_url AS image_uri,
    profile.metadata_block_timestamp AS created_at
   FROM public.profile
  WITH NO DATA;


ALTER TABLE public.k3l_profiles OWNER TO postgres;

--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


ALTER TABLE public.knex_migrations OWNER TO postgres;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_id_seq OWNER TO postgres;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


ALTER TABLE public.knex_migrations_lock OWNER TO postgres;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_lock_index_seq OWNER TO postgres;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: localtrust; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.localtrust (
    strategy_name character varying(255),
    i character varying(255) NOT NULL,
    j character varying(255) NOT NULL,
    v double precision NOT NULL,
    date date DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.localtrust OWNER TO postgres;

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
-- Name: strategies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.strategies (
    id integer NOT NULL,
    pretrust text,
    localtrust text,
    alpha real
);


ALTER TABLE public.strategies OWNER TO postgres;

--
-- Name: strategies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.strategies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.strategies_id_seq OWNER TO postgres;

--
-- Name: strategies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.strategies_id_seq OWNED BY public.strategies.id;


--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Name: strategies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.strategies ALTER COLUMN id SET DEFAULT nextval('public.strategies_id_seq'::regclass);


--
-- Name: follower follower_new_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.follower
    ADD CONSTRAINT follower_new_pkey PRIMARY KEY (address, follow_profile_id);


--
-- Name: globaltrust globaltrust_strategy_name_date_i_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.globaltrust
    ADD CONSTRAINT globaltrust_strategy_name_date_i_unique UNIQUE (strategy_name, date, i);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


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


--
-- Name: strategies strategies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.strategies
    ADD CONSTRAINT strategies_pkey PRIMARY KEY (id);


--
-- Name: strategies strategies_pt_lt_a_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.strategies
    ADD CONSTRAINT strategies_pt_lt_a_idx UNIQUE (pretrust, localtrust, alpha);


--
-- Name: feed_strategy_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feed_strategy_name_index ON public.feed USING btree (strategy_name);


--
-- Name: feed_strategy_name_post_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feed_strategy_name_post_id_index ON public.feed USING btree (strategy_name, post_id);


--
-- Name: globaltrust_strategy_name_date_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX globaltrust_strategy_name_date_index ON public.globaltrust USING btree (strategy_name, date);


--
-- Name: k3l_follow_counts_profile_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX k3l_follow_counts_profile_id_idx ON public.k3l_follow_counts USING btree (to_profile_id);


--
-- Name: localtrust_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX localtrust_id_idx ON public.localtrust USING btree (strategy_name);


--
-- Name: profile_post_new_post_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX profile_post_new_post_id_idx ON public.profile_post USING btree (post_id);


--
-- Name: publication_collect_module_details_new_publication_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX publication_collect_module_details_new_publication_id_idx1 ON public.publication_collect_module_details USING btree (publication_id);


--
-- PostgreSQL database dump complete
--


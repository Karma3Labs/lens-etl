--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.4

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

--
-- Name: lenster; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA lenster;


ALTER SCHEMA lenster OWNER TO postgres;

--
-- Name: orb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA orb;


ALTER SCHEMA orb OWNER TO postgres;

--
-- Name: phaver; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA phaver;


ALTER SCHEMA phaver OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: globaltrust; Type: TABLE; Schema: lenster; Owner: postgres
--

CREATE TABLE lenster.globaltrust (
    strategy_name character varying(255),
    i character varying(255),
    v double precision,
    date date DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE lenster.globaltrust OWNER TO postgres;

--
-- Name: localtrust; Type: TABLE; Schema: lenster; Owner: postgres
--

CREATE TABLE lenster.localtrust (
    strategy_name character varying(255),
    i character varying(255) NOT NULL,
    j character varying(255) NOT NULL,
    v double precision NOT NULL,
    date date DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE lenster.localtrust OWNER TO postgres;

--
-- Name: globaltrust; Type: TABLE; Schema: orb; Owner: postgres
--

CREATE TABLE orb.globaltrust (
    strategy_name character varying(255),
    i character varying(255),
    v double precision,
    date date DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE orb.globaltrust OWNER TO postgres;

--
-- Name: localtrust; Type: TABLE; Schema: orb; Owner: postgres
--

CREATE TABLE orb.localtrust (
    strategy_name character varying(255),
    i character varying(255) NOT NULL,
    j character varying(255) NOT NULL,
    v double precision NOT NULL,
    date date DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE orb.localtrust OWNER TO postgres;

--
-- Name: globaltrust; Type: TABLE; Schema: phaver; Owner: postgres
--

CREATE TABLE phaver.globaltrust (
    strategy_name character varying(255),
    i character varying(255),
    v double precision,
    date date DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE phaver.globaltrust OWNER TO postgres;

--
-- Name: localtrust; Type: TABLE; Schema: phaver; Owner: postgres
--

CREATE TABLE phaver.localtrust (
    strategy_name character varying(255),
    i character varying(255) NOT NULL,
    j character varying(255) NOT NULL,
    v double precision NOT NULL,
    date date DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE phaver.localtrust OWNER TO postgres;

--
-- Name: feed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feed (
    strategy_name text NOT NULL,
    post_id text,
    v double precision NOT NULL
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
-- Name: hna_gt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hna_gt (
    params_id bigint,
    "for" text NOT NULL,
    value double precision NOT NULL
);


ALTER TABLE public.hna_gt OWNER TO postgres;

--
-- Name: hna_ids; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hna_ids (
    index bigint NOT NULL,
    id text NOT NULL
);


ALTER TABLE public.hna_ids OWNER TO postgres;

--
-- Name: hna_indices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hna_indices (
    index bigint NOT NULL,
    id text NOT NULL
);


ALTER TABLE public.hna_indices OWNER TO postgres;

--
-- Name: hna_indices_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hna_indices_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hna_indices_index_seq OWNER TO postgres;

--
-- Name: hna_indices_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hna_indices_index_seq OWNED BY public.hna_indices.index;


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
-- Name: hna_lt_components; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.hna_lt_components AS
 SELECT c.comment_by_profile_id AS "from",
    c.comment_id AS "to",
    'author_to_comment'::text AS kind
   FROM public.post_comment c
UNION
 SELECT p.profile_id AS "from",
    p.post_id AS "to",
    'author_to_post'::text AS kind
   FROM public.profile_post p
UNION
 SELECT c.comment_id AS "from",
    c.comment_by_profile_id AS "to",
    'comment_to_author'::text AS kind
   FROM public.post_comment c
UNION
 SELECT p.post_id AS "from",
    p.profile_id AS "to",
    'post_to_author'::text AS kind
   FROM public.profile_post p
UNION
 SELECT c.comment_id AS "from",
    c.post_id AS "to",
    'comment_to_post'::text AS kind
   FROM public.post_comment c
UNION
 SELECT p.post_id AS "from",
    p.is_related_to_post AS "to",
    'mirror_to_post'::text AS kind
   FROM public.profile_post p
  WHERE (p.is_related_to_post IS NOT NULL)
UNION
 SELECT p.post_id AS "from",
    p.is_related_to_comment AS "to",
    'mirror_to_comment'::text AS kind
   FROM public.profile_post p
  WHERE (p.is_related_to_comment IS NOT NULL);


ALTER TABLE public.hna_lt_components OWNER TO postgres;

--
-- Name: hna_lt_weights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hna_lt_weights (
    strategy text NOT NULL,
    kind text NOT NULL,
    value integer NOT NULL
);


ALTER TABLE public.hna_lt_weights OWNER TO postgres;

--
-- Name: hna_lt_weighted_components; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.hna_lt_weighted_components AS
 SELECT hna_lt_components.kind,
    hna_lt_components."from",
    hna_lt_components."to",
    hna_lt_weights.strategy,
    hna_lt_weights.value
   FROM (public.hna_lt_components
     JOIN public.hna_lt_weights USING (kind));


ALTER TABLE public.hna_lt_weighted_components OWNER TO postgres;

--
-- Name: hna_lt; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.hna_lt AS
 SELECT c.strategy,
    "from".index AS i,
    "to".index AS j,
    sum(c.value) AS v
   FROM ((public.hna_lt_weighted_components c
     JOIN public.hna_indices "from" ON (((c."from")::text = "from".id)))
     JOIN public.hna_indices "to" ON (((c."to")::text = "to".id)))
  GROUP BY c.strategy, "from".index, "to".index;


ALTER TABLE public.hna_lt OWNER TO postgres;

--
-- Name: hna_params; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hna_params (
    id bigint NOT NULL,
    alpha double precision NOT NULL,
    max_iterations integer NOT NULL
);


ALTER TABLE public.hna_params OWNER TO postgres;

--
-- Name: hna_pt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hna_pt (
    "for" text NOT NULL,
    value integer NOT NULL
);


ALTER TABLE public.hna_pt OWNER TO postgres;

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
-- Name: k3l_collect_nft; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_collect_nft AS
 WITH pub_prices AS (
         SELECT ((("left"((collect_dtls.amount)::text, 3))::integer)::numeric / 1000.0) AS matic_price,
            collect_dtls.publication_id AS post_id
           FROM (public.publication_collect_module_details collect_dtls
             JOIN public.profile_post post ON (((post.post_id)::text = (collect_dtls.publication_id)::text)))
          WHERE ((collect_dtls.amount IS NOT NULL) AND ((collect_dtls.currency)::text = '0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270'::text))
        ), collects AS (
         SELECT concat(profile.profile_id, '-', publication_collect_module_collected_records.collect_publication_nft_id) AS collect_nft_id,
            profile.profile_id,
            publication_collect_module_collected_records.collect_publication_nft_id AS pub_id,
            "substring"((publication_collect_module_collected_records.publication_id)::text, 1, (POSITION(('-'::text) IN (publication_collect_module_collected_records.publication_id)) - 1)) AS to_profile_id,
            "substring"((publication_collect_module_collected_records.publication_id)::text, (POSITION(('-'::text) IN (publication_collect_module_collected_records.publication_id)) + 1)) AS to_pub_id,
            publication_collect_module_collected_records.publication_id AS to_post_id,
            publication_collect_module_collected_records.record_id AS metadata,
            publication_collect_module_collected_records.block_timestamp AS created_at
           FROM (public.publication_collect_module_collected_records
             LEFT JOIN public.profile ON (((publication_collect_module_collected_records.collected_by)::text = (profile.owned_by)::text)))
        )
 SELECT row_number() OVER () AS pseudo_id,
    collects.collect_nft_id,
    collects.profile_id,
    collects.pub_id,
    collects.to_profile_id,
    collects.to_pub_id,
    collects.to_post_id,
    collects.metadata,
    collects.created_at,
    pub_prices.matic_price
   FROM (collects
     LEFT JOIN pub_prices ON (((pub_prices.post_id)::text = (collects.to_post_id)::text)))
  WITH NO DATA;


ALTER TABLE public.k3l_collect_nft OWNER TO postgres;

--
-- Name: k3l_comments; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_comments AS
 SELECT row_number() OVER () AS pseudo_id,
    post_comment.comment_id,
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
-- Name: profile_curated; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile_curated (
    profile_id character varying(66) NOT NULL,
    created_on timestamp with time zone,
    uuid character varying,
    source_timestamp bigint
);


ALTER TABLE public.profile_curated OWNER TO postgres;

--
-- Name: k3l_curated_profiles; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_curated_profiles AS
 SELECT profile.profile_id,
    profile.owned_by AS owner_address,
    profile.handle,
    profile.profile_picture_s3_url AS image_uri,
    profile.metadata_block_timestamp AS created_at
   FROM (public.profile
     JOIN public.profile_curated ON (((profile.profile_id)::text = (profile_curated.profile_id)::text)))
  WITH NO DATA;


ALTER TABLE public.k3l_curated_profiles OWNER TO postgres;

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
-- Name: k3l_feed; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_feed AS
 SELECT row_number() OVER () AS pseudo_id,
    k3l_posts.post_id,
    k3l_profiles.handle,
    gt.rank,
    publication_stats.total_amount_of_mirrors AS mirrors_count,
    publication_stats.total_amount_of_comments AS comments_count,
    publication_stats.total_amount_of_collects AS collects_count,
    publication_stats.total_upvotes AS upvotes_count,
    feed.v,
    k3l_posts.created_at,
    feed.strategy_name,
    k3l_posts.content_uri,
    profile_post.main_content_focus,
    profile_post.language
   FROM (((((public.feed
     JOIN public.k3l_posts ON (((k3l_posts.post_id)::text = feed.post_id)))
     JOIN public.publication_stats ON ((feed.post_id = (publication_stats.publication_id)::text)))
     JOIN public.k3l_profiles ON (((k3l_posts.profile_id)::text = (k3l_profiles.profile_id)::text)))
     JOIN ( SELECT row_number() OVER (ORDER BY globaltrust.v DESC) AS rank,
            globaltrust.i AS profile_id
           FROM public.globaltrust
          WHERE (((globaltrust.strategy_name)::text = 'engagement'::text) AND (globaltrust.date = ( SELECT max(globaltrust_1.date) AS max
                   FROM public.globaltrust globaltrust_1
                  WHERE ((globaltrust_1.strategy_name)::text = 'engagement'::text))))) gt ON (((gt.profile_id)::text = (k3l_posts.profile_id)::text)))
     JOIN public.profile_post ON (((k3l_posts.post_id)::text = (profile_post.post_id)::text)))
  WHERE ((profile_post.is_related_to_post IS NULL) AND (profile_post.is_related_to_comment IS NULL) AND (profile_post.has_error <> true) AND (profile_post.is_hidden <> true) AND (profile_post.is_gated <> true) AND (profile_post.custom_filters_gardener_flagged <> true) AND (profile_post.content_warning IS NULL))
  WITH NO DATA;


ALTER TABLE public.k3l_feed OWNER TO postgres;

--
-- Name: k3l_follow_counts; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_follow_counts AS
 SELECT row_number() OVER () AS pseudo_id,
    follower.follow_profile_id AS to_profile_id,
    count(*) AS count
   FROM public.follower
  GROUP BY follower.follow_profile_id
  WITH NO DATA;


ALTER TABLE public.k3l_follow_counts OWNER TO postgres;

--
-- Name: k3l_following_feed; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_following_feed AS
 SELECT row_number() OVER () AS pseudo_id,
    row_number() OVER (PARTITION BY pstats.profile_id ORDER BY pstats.v DESC) AS r_num,
    pstats.post_id,
    pstats.content_uri,
    pstats.profile_id,
    pstats.created_at,
    pstats.main_content_focus,
    pstats.language,
    pstats.handle,
    pstats.mirrors_count,
    pstats.comments_count,
    pstats.collects_count,
    pstats.upvotes_count,
    pstats.age_time,
    pstats.age_days,
    pstats.v,
    pstats.rank
   FROM ( SELECT p.post_id,
            p.content_uri,
            p.profile_id,
            p.created_at,
            post.main_content_focus,
            post.language,
            prof.handle,
            ps.total_amount_of_mirrors AS mirrors_count,
            ps.total_amount_of_comments AS comments_count,
            ps.total_amount_of_collects AS collects_count,
            ps.total_upvotes AS upvotes_count,
            (EXTRACT(epoch FROM (CURRENT_TIMESTAMP - p.created_at)))::integer AS age_time,
            ((EXTRACT(epoch FROM (CURRENT_TIMESTAMP - p.created_at)) / (((60 * 60) * 24))::numeric))::integer AS age_days,
            ((((((((2)::numeric * ((ps.total_amount_of_comments)::numeric / (max_values.max_comments_count)::numeric)) + ((5)::numeric * ((ps.total_amount_of_mirrors)::numeric / (max_values.max_mirrors_count)::numeric))) + ((3)::numeric * ((ps.total_amount_of_collects)::numeric / (max_values.max_collects_count)::numeric))) + (0.5 * ((ps.total_upvotes)::numeric / (max_values.max_upvotes_count)::numeric))))::double precision + ((10)::double precision * gt.gt_v)) - ((2 * (((EXTRACT(epoch FROM (CURRENT_TIMESTAMP - p.created_at)) / (((60 * 60) * 24))::numeric))::integer / max_values.max_age_days)))::double precision) AS v,
            gt.rank
           FROM ( SELECT (max((EXTRACT(epoch FROM (CURRENT_TIMESTAMP - k3l.created_at)) / (((60 * 60) * 24))::numeric)))::integer AS max_age_days,
                    max(publication_stats.total_amount_of_mirrors) AS max_mirrors_count,
                    max(publication_stats.total_amount_of_comments) AS max_comments_count,
                    max(publication_stats.total_amount_of_collects) AS max_collects_count,
                    max(publication_stats.total_upvotes) AS max_upvotes_count
                   FROM ((public.publication_stats
                     JOIN public.k3l_posts k3l ON (((publication_stats.publication_id)::text = (k3l.post_id)::text)))
                     JOIN public.profile_post post_1 ON (((publication_stats.publication_id)::text = (post_1.post_id)::text)))
                  WHERE ((k3l.created_at > (now() - '30 days'::interval)) AND (post_1.is_related_to_post IS NULL) AND (post_1.is_related_to_comment IS NULL))) max_values,
            ((((public.k3l_posts p
             JOIN public.publication_stats ps ON ((((ps.publication_id)::text = (p.post_id)::text) AND ((((ps.total_amount_of_mirrors + ps.total_amount_of_comments) + ps.total_amount_of_collects) + ps.total_upvotes) > 0))))
             JOIN public.profile_post post ON (((post.post_id)::text = (p.post_id)::text)))
             JOIN ( SELECT row_number() OVER (ORDER BY globaltrust.v DESC) AS rank,
                    globaltrust.v AS gt_v,
                    globaltrust.i AS profile_id
                   FROM public.globaltrust
                  WHERE (((globaltrust.strategy_name)::text = 'engagement'::text) AND (globaltrust.date = ( SELECT max(globaltrust_1.date) AS max
                           FROM public.globaltrust globaltrust_1
                          WHERE ((globaltrust_1.strategy_name)::text = 'engagement'::text))))) gt ON (((gt.profile_id)::text = (p.profile_id)::text)))
             JOIN public.k3l_profiles prof ON (((prof.profile_id)::text = (p.profile_id)::text)))
          WHERE ((p.created_at > (now() - '30 days'::interval)) AND (post.is_related_to_post IS NULL) AND (post.is_related_to_comment IS NULL) AND (post.has_error <> true) AND (post.is_hidden <> true) AND (post.is_gated <> true) AND (post.custom_filters_gardener_flagged <> true) AND (post.content_warning IS NULL))
          ORDER BY p.profile_id, ((((((((2)::numeric * ((ps.total_amount_of_comments)::numeric / (max_values.max_comments_count)::numeric)) + ((5)::numeric * ((ps.total_amount_of_mirrors)::numeric / (max_values.max_mirrors_count)::numeric))) + ((3)::numeric * ((ps.total_amount_of_collects)::numeric / (max_values.max_collects_count)::numeric))) + (0.5 * ((ps.total_upvotes)::numeric / (max_values.max_upvotes_count)::numeric))))::double precision + ((10)::double precision * gt.gt_v)) - ((2 * (((EXTRACT(epoch FROM (CURRENT_TIMESTAMP - p.created_at)) / (((60 * 60) * 24))::numeric))::integer / max_values.max_age_days)))::double precision) DESC) pstats
  WITH NO DATA;


ALTER TABLE public.k3l_following_feed OWNER TO postgres;

--
-- Name: k3l_follows; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_follows AS
 SELECT row_number() OVER () AS pseudo_id,
    profile.profile_id,
    follower.follow_profile_id AS to_profile_id,
    follower.block_timestamp AS created_at
   FROM (public.follower
     LEFT JOIN public.profile ON (((follower.address)::text = (profile.owned_by)::text)))
  WITH NO DATA;


ALTER TABLE public.k3l_follows OWNER TO postgres;

--
-- Name: k3l_mirrors; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_mirrors AS
 SELECT row_number() OVER () AS pseudo_id,
    related_posts.post_id,
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
-- Name: k3l_rank; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.k3l_rank AS
 SELECT row_number() OVER () AS pseudo_id,
    row_number() OVER (PARTITION BY globaltrust.date, globaltrust.strategy_name ORDER BY globaltrust.v DESC) AS rank,
    globaltrust.i AS profile_id,
    globaltrust.strategy_name,
    globaltrust.date
   FROM public.globaltrust
  WITH NO DATA;


ALTER TABLE public.k3l_rank OWNER TO postgres;

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
-- Name: raw_gt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.raw_gt (
    "for" bigint NOT NULL,
    value double precision NOT NULL
);


ALTER TABLE public.raw_gt OWNER TO postgres;

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
-- Name: hna_indices index; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hna_indices ALTER COLUMN index SET DEFAULT nextval('public.hna_indices_index_seq'::regclass);


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
-- Name: globaltrust globaltrust_strategy_name_date_i_unique; Type: CONSTRAINT; Schema: lenster; Owner: postgres
--

ALTER TABLE ONLY lenster.globaltrust
    ADD CONSTRAINT globaltrust_strategy_name_date_i_unique UNIQUE (strategy_name, date, i);


--
-- Name: globaltrust globaltrust_strategy_name_date_i_unique; Type: CONSTRAINT; Schema: orb; Owner: postgres
--

ALTER TABLE ONLY orb.globaltrust
    ADD CONSTRAINT globaltrust_strategy_name_date_i_unique UNIQUE (strategy_name, date, i);


--
-- Name: globaltrust globaltrust_strategy_name_date_i_unique; Type: CONSTRAINT; Schema: phaver; Owner: postgres
--

ALTER TABLE ONLY phaver.globaltrust
    ADD CONSTRAINT globaltrust_strategy_name_date_i_unique UNIQUE (strategy_name, date, i);


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
-- Name: hna_ids hna_ids_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hna_ids
    ADD CONSTRAINT hna_ids_id_key UNIQUE (id);


--
-- Name: hna_ids hna_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hna_ids
    ADD CONSTRAINT hna_ids_pkey PRIMARY KEY (index);


--
-- Name: hna_indices hna_indices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hna_indices
    ADD CONSTRAINT hna_indices_pkey PRIMARY KEY (index);


--
-- Name: hna_lt_weights hna_lt_weights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hna_lt_weights
    ADD CONSTRAINT hna_lt_weights_pkey PRIMARY KEY (strategy, kind);


--
-- Name: hna_params hna_params_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hna_params
    ADD CONSTRAINT hna_params_pkey PRIMARY KEY (id);


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
-- Name: profile_curated profile_curated_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_curated
    ADD CONSTRAINT profile_curated_pkey PRIMARY KEY (profile_id);


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
-- Name: globaltrust_strategy_name_date_index; Type: INDEX; Schema: lenster; Owner: postgres
--

CREATE INDEX globaltrust_strategy_name_date_index ON lenster.globaltrust USING btree (strategy_name, date);


--
-- Name: globaltrust_strategy_name_date_index; Type: INDEX; Schema: orb; Owner: postgres
--

CREATE INDEX globaltrust_strategy_name_date_index ON orb.globaltrust USING btree (strategy_name, date);


--
-- Name: globaltrust_strategy_name_date_index; Type: INDEX; Schema: phaver; Owner: postgres
--

CREATE INDEX globaltrust_strategy_name_date_index ON phaver.globaltrust USING btree (strategy_name, date);


--
-- Name: follower_block_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX follower_block_timestamp_idx ON public.follower USING btree (block_timestamp);


--
-- Name: globaltrust_strategy_name_date_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX globaltrust_strategy_name_date_index ON public.globaltrust USING btree (strategy_name, date);


--
-- Name: hna_indices_by_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX hna_indices_by_id ON public.hna_indices USING btree (id);


--
-- Name: idx_k3l_posts_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_k3l_posts_post_id ON public.k3l_posts USING btree (post_id);


--
-- Name: idx_profile_post_block_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profile_post_block_timestamp ON public.profile_post USING btree (block_timestamp DESC);


--
-- Name: idx_publication_stats_publication_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_publication_stats_publication_id ON public.publication_stats USING btree (publication_id);


--
-- Name: k3l_collect_nft_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_collect_nft_idx ON public.k3l_collect_nft USING btree (pseudo_id);


--
-- Name: k3l_comments_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_comments_idx ON public.k3l_comments USING btree (pseudo_id);


--
-- Name: k3l_feed_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_feed_idx ON public.k3l_feed USING btree (pseudo_id);


--
-- Name: k3l_follow_counts_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_follow_counts_idx ON public.k3l_follow_counts USING btree (pseudo_id);


--
-- Name: k3l_following_feed_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_following_feed_idx ON public.k3l_following_feed USING btree (pseudo_id);


--
-- Name: k3l_follows_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_follows_idx ON public.k3l_follows USING btree (pseudo_id);


--
-- Name: k3l_mirrors_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_mirrors_idx ON public.k3l_mirrors USING btree (pseudo_id);


--
-- Name: k3l_profiles_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_profiles_idx ON public.k3l_profiles USING btree (profile_id);


--
-- Name: k3l_rank_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX k3l_rank_idx ON public.k3l_rank USING btree (pseudo_id);


--
-- Name: post_comment_block_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_comment_block_timestamp_idx ON public.post_comment USING btree (block_timestamp);


--
-- Name: profile_block_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX profile_block_timestamp_idx ON public.profile USING btree (block_timestamp);


--
-- Name: profile_post_block_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX profile_post_block_timestamp_idx ON public.profile_post USING btree (block_timestamp);


--
-- Name: profile_post_new_post_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX profile_post_new_post_id_idx ON public.profile_post USING btree (post_id);


--
-- Name: publication_collect_module_collected_records_block_timestamp_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX publication_collect_module_collected_records_block_timestamp_id ON public.publication_collect_module_collected_records USING btree (block_timestamp);


--
-- Name: publication_collect_module_details_block_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX publication_collect_module_details_block_timestamp_idx ON public.publication_collect_module_details USING btree (block_timestamp);


--
-- Name: publication_collect_module_details_new_publication_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX publication_collect_module_details_new_publication_id_idx1 ON public.publication_collect_module_details USING btree (publication_id);


--
-- Name: hna_gt hna_gt_params_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hna_gt
    ADD CONSTRAINT hna_gt_params_id_fkey FOREIGN KEY (params_id) REFERENCES public.hna_params(id);


--
-- PostgreSQL database dump complete
--


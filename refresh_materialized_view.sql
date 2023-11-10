refresh materialized view concurrently k3l_profiles;
refresh materialized view k3l_posts;
refresh materialized view concurrently k3l_follows;
refresh materialized view k3l_mirrors;
refresh materialized view k3l_comments;
refresh materialized view k3l_collect_nft;
refresh materialized view concurrently k3l_follow_counts;
refresh materialized view k3l_upvotes;
refresh materialized view k3l_interactions;

-- TODO k3l_feed and k3l_following_feed should be refreshed after compute feed runs
refresh materialized view concurrently k3l_feed;
refresh materialized view concurrently k3l_following_feed;

-- TODO k3l_rank should be refreshed after compute runs and before compute feed
refresh materialized view concurrently k3l_rank;
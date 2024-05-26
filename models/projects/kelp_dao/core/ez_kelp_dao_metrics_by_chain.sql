{{
    config(
        materialized="table",
        snowflake_warehouse="KELP_DAO",
        database="kelp_dao",
        schema="core",
        alias="ez_metrics_by_chain",
    )
}}

with
    restaked_eth_metrics as (
        select
            date,
            chain,
            num_restaked_eth,
            amount_restaked_usd,
            num_restaked_eth_net_change,
            amount_restaked_usd_net_change
        from {{ ref('fact_kelp_dao_restaked_eth_count_with_usd_and_change') }}
    )
select
    restaked_eth_metrics.date,
    'kelp_dao' as protocol,
    'DeFi' as category,
    restaked_eth_metrics.chain,
    restaked_eth_metrics.num_restaked_eth,
    restaked_eth_metrics.amount_restaked_usd,
    restaked_eth_metrics.num_restaked_eth_net_change,
    restaked_eth_metrics.amount_restaked_usd_net_change
from restaked_eth_metrics
where restaked_eth_metrics.date < to_date(sysdate())

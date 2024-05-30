{{
    config(
        materialized="incremental",
        unique_key="date",
        snowflake_warehouse="SEI"
    )
}}

with daa_txns as (
    select 
        date_trunc('day', block_timestamp) as date,
        count(DISTINCT tx_hash) as txns,
        count(DISTINCT tx_hash) / 86400 as avg_tps,
        count(distinct from_address) as daa
    from sei_flipside.core_evm.fact_transactions as t
    where date < date(sysdate()) and status = 'SUCCESS'
    {% if is_incremental() %}
        and t.block_timestamp >= (select dateadd('day', -5, max(date)) from {{ this }})
    {% endif %}
    group by date
),
tx_fee as (
    select 
        date_trunc('day', block_timestamp) as date,
        sum(tx_fee) as gas
    from sei_flipside.core_evm.fact_transactions as t
    where date < date(sysdate())
    {% if is_incremental() %}
        and t.block_timestamp >= (select dateadd('day', -5, max(date)) from {{ this }})
    {% endif %}
    group by date
),
prices as ({{ get_coingecko_price_with_latest("sei-network") }})
select
    daa_txns.date,
    txns as evm_txns, 
    daa as evm_daa,
    avg_tps as evm_avg_tps,
    gas as evm_gas,
    gas * price as evm_gas_usd
from daa_txns 
left join tx_fee on daa_txns.date = tx_fee.date
left join prices on daa_txns.date = prices.date
where daa_txns.date < date(sysdate())
order by date desc
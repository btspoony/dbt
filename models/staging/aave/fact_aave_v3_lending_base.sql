{{ config(materialized="table", snowflake_warehouse="AAVE") }}
{{
    fact_aave_fork_lending(
        "raw_aave_v3_base_borrows_deposits_revenue", "base", "aave_v3"
    )
}}

{{
    config(
        materialized="incremental",
        unique_key="date",
        snowflake_warehouse="CEUR",
        database="ceur",
        schema="core",
        alias="ez_metrics",
    )
}}

{{ get_stablecoin_ez_metrics("CEUR") }}
-- depends_on {{ ref("ez_base_transactions") }}
{{ config(materialized="table", snowflake_warehouse="DAILY_BAM") }}
{{ get_fundamental_data_for_chain("base") }}

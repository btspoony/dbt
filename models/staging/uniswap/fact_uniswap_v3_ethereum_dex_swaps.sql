{{
    config(
        materialized="incremental",
        unique_key=["tx_hash", "event_index"],
        snowflake_warehouse="UNISWAP_SM",
    )
}}
{{
    fact_uniswap_v3_fork_dex_swaps(
        "0x1F98431c8aD98523631AE4a59f267346ea31F984",
        "ethereum",
        (
            "0x23da3feecae09105df5447d22114f157b656e29c",
            "0xa7f72a1ec0ab189998a3eec8b886e6360aff39da",
            "0x5b2cd450c0f920e2a39527df2fe30e6e9f6c5a22",
            "0x76fec10213d9b9f92367fd2e7bc51525df370dde",
        ),
        "uniswap",
        "v3",
    )
}}

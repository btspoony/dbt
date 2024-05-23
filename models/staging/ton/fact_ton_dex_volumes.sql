with 
    max_extraction as (
        select
            max(extraction_date) as max_extraction,
            value:date::date as date
        from landing_database.prod_landing.raw_ton_dex_volumes,
            lateral flatten(input => source_json)
        group by date
    ),
    flattened_data as (
        select value:"date"::date as date, value:"dex_volumes"::float as dex_volumes, extraction_date
        from landing_database.prod_landing.raw_ton_dex_volumes, 
            lateral flatten(input => source_json)
    ),
    prices as ({{ get_coingecko_price_with_latest("the-open-network") }})
select
    t1.date,
    'ton' as chain,
    dex_volumes * price as dex_volumes
from flattened_data t1
inner join max_extraction t2 on t1.date = t2.date and t1.extraction_date = t2.max_extraction
left join prices on t1.date = prices.date
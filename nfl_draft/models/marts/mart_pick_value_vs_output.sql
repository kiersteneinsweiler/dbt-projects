with base as (

    select * from {{ ref('int_draft_picks_enriched') }}

) 

--Q3: Does pick value predict career success?
, aggregated as (

    select 
        -- dimensions
        pick
      , draft_round_descrip  

      , round(avg(pick_trade_value),2)                                                as avg_pick_trade_value
      , round(avg(weighted_approx_value),2)                                           as avg_wtd_approx_value
      , round(avg(value_over_pick_expectation), 2)                                    as avg_value_over_pick_expectation
      , count(*)                                                                      as sample_size

    from base
    group by pick, draft_round_descrip
)

select * from aggregated
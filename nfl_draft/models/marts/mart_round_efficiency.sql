with base as (

    select * from {{ ref('int_draft_picks_enriched') }}

) 

--Q4: Which rounds produce the most surplus value?
, aggregated as (

    select 
        -- dimensions
        draft_round
      , draft_round_descrip  

      , count(*)                                                                           as total_picks
      , round(avg(weighted_approx_value),2)                                                as avg_wtd_approx_value
      , round(avg(pick_trade_value),2)                                                     as avg_pick_trade_value
      , round(avg(value_over_pick_expectation), 2)                                         as avg_value_over_pick_expectation

      , sum(case when weighted_approx_value >= 50 then 1 else 0 end)                       as star_picks
      , round(cast(sum(case when weighted_approx_value >= 50 then 1 else 0 end) as float64) / count(*), 4)  as pct_star_picks      

    from base
    group by draft_round, draft_round_descrip
)

select * from aggregated
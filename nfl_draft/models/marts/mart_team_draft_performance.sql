with base as (

    select * from {{ ref('int_draft_picks_enriched') }}

)

--Q1: Which teams draft best?
, aggregated as (

    select 
        -- dimensions
        team

      , count(*)                                                                      as total_picks
      , round(avg(weighted_approx_value),2)                                           as avg_wtd_approx_value
      , round(avg(value_over_pick_expectation), 2)                                    as avg_value_over_pick_expectation
      , sum(case when value_over_pick_expectation > 0 then 1 else 0 end)              as nbr_picks_beating_expectations
      , round(avg(case when draft_round = 1 then weighted_approx_value else 0 end),2) as avg_round1_wtd_approx_value
      , sum(case when allpro > 0 then 1 else 0 end)                                   as total_allpro_picks
      , sum(case when weighted_approx_value >= 50 then 1 else 0 end)                  as star_picks

    from base
    group by team
    having total_picks >= 30
)

, final as (

    select
        *,

        round(cast(nbr_picks_beating_expectations as float64) / total_picks,4) as pct_picks_beating_expectations

    from aggregated

)

select * from final
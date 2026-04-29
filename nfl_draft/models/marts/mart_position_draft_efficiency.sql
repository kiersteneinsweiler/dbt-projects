with base as (

    select * from {{ ref('int_draft_picks_enriched') }}

) 

--Q2: Which positions are over/underdrafted?
, aggregated as (

    select 
        -- dimensions
        position_group

      , count(*)                                                                      as total_drafted
      , round(avg(pick),2)                                                            as avg_draft_position
      , round(avg(weighted_approx_value), 2)                                          as avg_wtd_approx_value
      , round(avg(pick_trade_value),2)                                                as avg_pick_trade_value
      , round(avg(value_over_positional_avg),2)                                       as avg_value_over_positional_avg

      , round(count(*) / sum(count(*)) over(), 4)                                     as draft_rate
      , round(sum(value_over_positional_avg) / sum(sum(value_over_positional_avg)) over(), 4) as value_rate

    from base
    group by position_group
)

, final as (

    select
        *,

        round(draft_rate - value_rate, 4) as draft_rate_vs_value_rate

    from aggregated

)

select * from final

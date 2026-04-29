with base as (

    select * from {{ ref('int_draft_picks_enriched') }}

)

--Q5: AV curve by position 
, aggregated as (

    select 
        position_group
      , draft_round  
      , weighted_approx_value
      , percentile_cont(weighted_approx_value,0.5) over (partition by position_group, draft_round) as median_wtd_approx_value
    
    from base
)

, final as (

    select 
        -- dimensions
        position_group
      , draft_round  

      , count(*)                                                                      as total_picks
      , round(avg(weighted_approx_value),2)                                           as avg_wtd_approx_value
      , round(avg(median_wtd_approx_value),2)                                         as avg_median_wtd_approx_value
    
    from aggregated
    group by position_group, draft_round    
)
select * from final
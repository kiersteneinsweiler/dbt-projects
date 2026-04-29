with draft_picks as (

    select * from {{ ref('stg_draft_picks') }}  --the view created in stg_draft_picks.sql

) 

, draft_values as (

    select * from {{ ref('stg_draft_values') }}  --the view created in stg_draft_values.sql

) 

-- calculate historical average career_av by position, to compare against
, position_expectations as (
    select
        position
      , avg(weighted_approx_value)   as avg_wtd_av_by_position
      --, percentile_cont(weighted_approx_value,0.5) over (partition by position) as median_wtd_av_by_position
    from draft_picks
    where end_year is not null
      and seasons_started >= 3
    group by position
)

, enriched as (

    select
         p.*
        , v.stuart as pick_trade_value 
        , p.weighted_approx_value - (avg(p.weighted_approx_value) over(partition by p.pick)) as value_over_pick_expectation
        , pe.avg_wtd_av_by_position
        --, pe.median_wtd_av_by_position

        -- did pick beat the position average
        , p.weighted_approx_value - pe.avg_wtd_av_by_position as value_over_positional_avg

        -- pick tier
        , case
              when p.pick <= 32  then '1st round'
              when p.pick <= 64  then '2nd round'
              when p.pick <= 96  then '3rd round'
              when p.pick <= 128 then '4th round'
              else '5th+ round'
          end as draft_round_descrip

        -- position group 
        , case
              when p.position in ('QB')                         then 'Quarterback'
              when p.position in ('WR', 'TE', 'RB', 'FB')       then 'Skill offense'
              when p.position in ('T', 'G', 'C', 'OL', 'OT')    then 'Offensive line'
              when p.position in ('DE', 'DT', 'NT', 'DL')       then 'Defensive line'
              when p.position in ('LB', 'ILB', 'OLB')           then 'Linebacker'
              when p.position in ('CB', 'S', 'SS', 'FS', 'DB')  then 'Secondary'
              when p.position in ('K', 'P', 'LS')               then 'Special teams'
              else 'Other'
          end as position_group

    from draft_picks p
    left join draft_values v on p.pick = v.pick
    left join position_expectations pe on p.position = pe.position
    where p.season <= 2018
      and p.seasons_played >= 3
)

select * from enriched
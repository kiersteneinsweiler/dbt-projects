with source as (

    select * from {{ ref('draft_picks') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['season', 'round', 'pick']) }} as draft_pick_id,
        season,	
        `round`              as draft_round,	
        pick,	
        case team when 'SD'  then 'LAC'
                  when 'STL' then 'LAR'
                  when 'OAK' then 'LV'
                  when 'HOU' then 'TEN'
                  when 'BAL' then 'CLE'
                  when 'PHX' then 'ARI'
                  else team
        end as team,	
        pfr_player_id,	
        pfr_player_name,	
        position,	
        age,	
        `to`                as end_year,	
        allpro,	
        probowls,	
        seasons_started,
        `to` - season + 1   as seasons_played,

        w_av                as weighted_approx_value,	        	
        dr_av               as draft_approx_value,	
        pass_completions,	
        pass_attempts,	
        pass_yards,	
        pass_tds,	
        pass_ints,	
        rush_atts,	
        rush_yards,	
        rush_tds,	
        receptions,	
        rec_yards,	
        rec_tds,	

        def_solo_tackles,	
        def_ints,	
        def_sacks
        --gsis_id, cfb_player_id, hof, games, category, side, college, car_av	
	
    from source
    where
        season >= 1994
)

select * from renamed
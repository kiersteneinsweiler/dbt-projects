with source as (

    select * from {{ ref('draft_values') }}

),

config_columns as (

    select
        pick, 
        stuart, 
        johnson, 
        hill, 
        otc as over_the_cap, 
        pff as pro_football_focus
	
    from source
)

select * from config_columns
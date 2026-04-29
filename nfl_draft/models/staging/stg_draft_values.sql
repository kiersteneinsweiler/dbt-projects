with source as (

    select * from {{ ref('draft_values') }}

),

renamed as (

    select
        pick, 
        stuart, 
        johnson, 
        hill, 
        otc as over_the_cap, 
        pff as pro_football_focus
	
    from source
)

select * from renamed
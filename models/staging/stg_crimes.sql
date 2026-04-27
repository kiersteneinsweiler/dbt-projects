with source as (

    select * from {{ source('chicago_crime', 'crime') }}

),

renamed as (

    select
        -- identifiers
        unique_key                              as crime_id,
        case_number,

        -- dates
        date                                    as reported_at,
        cast(date as date)                      as reported_date,
        extract(year from date)                 as reported_year,
        extract(month from date)                as reported_month,

        -- location
        block,
        community_area,
        district,
        ward,
        latitude,
        longitude,

        -- crime details
        primary_type                            as crime_type,
        description                             as crime_description,
        location_description,
        iucr,

        -- outcomes
        arrest,
        domestic

    from source
    where
        date is not null
        and unique_key is not null
        and extract(year from date) >= 2021
        and extract(year from date) <= 2023

)

select * from renamed
with weather_2021 as (

    select * from {{ source('chicago_weather', 'gsod2021') }}

),

weather_2022 as (

    select * from {{ source('chicago_weather', 'gsod2022') }}

),

weather_2023 as (

    select * from {{ source('chicago_weather', 'gsod2023') }}

),

unioned as (

    select * from weather_2021
    union all
    select * from weather_2022
    union all
    select * from weather_2023

),

chicago_only as (

    select * from unioned
    -- Chicago O'Hare and Midway are the two main Chicago weather stations
    where stn in ('725300', '725340')

),

renamed as (

    select
        -- identifiers
        stn                                         as station_id,
        wban,

        -- date
        cast(
            concat(year, '-', mo, '-', da) as date
        )                                           as weather_date,
        cast(year as int64)                         as weather_year,
        cast(mo as int64)                           as weather_month,

        -- temperature (Fahrenheit)
        cast(temp as float64)                       as avg_temp_f,
        cast(max as float64)                        as max_temp_f,
        cast(min as float64)                        as min_temp_f,

        -- precipitation
        cast(prcp as float64)                       as precipitation_inches,

        -- wind
        cast(wdsp as float64)                       as avg_wind_speed,

        -- flags
        fog,
        rain_drizzle,
        snow_ice_pellets,
        thunder

    from chicago_only
    where
        cast(concat(year, '-', mo, '-', da) as date) is not null

)

select * from renamed
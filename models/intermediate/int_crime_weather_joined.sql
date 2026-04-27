with crimes as (

    select * from {{ ref('stg_crimes') }}  --the view created in stg_crimes.sql

),

weather as (

    select * from {{ ref('stg_weather') }}  --the view created in stg_weather.sql

),

-- one weather row per date by averaging both Chicago stations
daily_weather as (

    select
        weather_date,
        weather_year,
        weather_month,
        round(avg(avg_temp_f), 1)                   as avg_temp_f,
        round(avg(nullif(max_temp_f, 9999.9)), 1)   as max_temp_f,
        round(avg(nullif(min_temp_f, 9999.9)), 1)   as min_temp_f,
        round(avg(nullif(precipitation_inches, 99.99)), 2) as precipitation_inches,
        round(avg(avg_wind_speed), 1)               as avg_wind_speed,
        max(cast(fog as int64))                     as had_fog,
        max(cast(rain_drizzle as int64))            as had_rain,
        max(cast(snow_ice_pellets as int64))        as had_snow,
        max(cast(thunder as int64))                 as had_thunder

    from weather
    group by 1, 2, 3

),

joined as (

    select
        -- crime details
        c.crime_id,
        c.case_number,
        c.reported_date,
        c.reported_year,
        c.reported_month,
        c.crime_type,
        c.crime_description,
        c.location_description,
        c.community_area,
        c.district,
        c.arrest,
        c.domestic,
        c.latitude,
        c.longitude,

        -- weather details
        w.avg_temp_f,
        w.max_temp_f,
        w.min_temp_f,
        w.precipitation_inches,
        w.avg_wind_speed,
        w.had_fog,
        w.had_rain,
        w.had_snow,
        w.had_thunder

    from crimes c
    left join daily_weather w
        on c.reported_date = w.weather_date

),

enriched as (

    select
        *,

        -- season based on month
        case
            when reported_month in (12, 1, 2)   then 'Winter'
            when reported_month in (3, 4, 5)    then 'Spring'
            when reported_month in (6, 7, 8)    then 'Summer'
            when reported_month in (9, 10, 11)  then 'Fall'
        end                                         as season,

        -- temperature bucket
        case
            when avg_temp_f < 20                then 'Extreme Cold (< 20°F)'
            when avg_temp_f between 20 and 39   then 'Cold (20-39°F)'
            when avg_temp_f between 40 and 59   then 'Cool (40-59°F)'
            when avg_temp_f between 60 and 79   then 'Warm (60-79°F)'
            when avg_temp_f >= 80               then 'Hot (80°F+)'
            else                                    'Unknown'
        end                                         as temp_bucket,

        -- weekend flag
        case
            when extract(dayofweek from reported_date) in (1, 7) then true
            else false
        end                                         as is_weekend

    from joined

)

select * from enriched
with base as (

    select * from {{ ref('int_crime_weather_joined') }}

),

aggregated as (

    select
        -- dimensions
        reported_year,
        reported_month,
        season,
        temp_bucket,
        crime_type,
        is_weekend,

        -- weather context (avg across the group)
        round(avg(avg_temp_f), 1)               as avg_temp_f,
        round(avg(precipitation_inches), 2)     as avg_precipitation_inches,
        round(avg(avg_wind_speed), 1)           as avg_wind_speed,

        -- weather event flags (1 if any day in group had the event)
        max(had_fog)                            as had_fog,
        max(had_rain)                           as had_rain,
        max(had_snow)                           as had_snow,
        max(had_thunder)                        as had_thunder,

        -- crime counts
        count(*)                                as total_crimes,
        countif(arrest = true)                  as total_arrests,
        countif(domestic = true)                as total_domestic,

        -- arrest rate
        round(
            safe_divide(
                countif(arrest = true),
                count(*)
            ) * 100, 2
        )                                       as arrest_rate_pct

    from base
    group by 1, 2, 3, 4, 5, 6

),

final as (

    select
        *,

        -- rolling 3-month total crimes by crime type (window function)
        sum(total_crimes) over (
            partition by crime_type, reported_year
            order by reported_month
            rows between 2 preceding and current row
        )                                       as rolling_3mo_crimes,

        -- rank crime types by volume within each year
        rank() over (
            partition by reported_year
            order by total_crimes desc
        )                                       as crime_type_rank

    from aggregated

)

select * from final
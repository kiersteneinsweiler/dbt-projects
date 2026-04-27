# Chicago Crime & Weather Analytics

A dbt project analyzing the relationship between weather conditions and crime 
patterns in Chicago using publicly available data from Google BigQuery.

## Project Overview

This project explores how weather conditions correlate with crime activity 
in Chicago between 2021 and 2023. It transforms raw public datasets into clean, 
analytics-ready models using dbt best practices including layered modeling, 
data tests, and documentation.

## Data Sources

All data is sourced from [BigQuery Public Datasets](https://cloud.google.com/bigquery/public-data):

| Source | Dataset | Description |
|---|---|---|
| Chicago Crime | `bigquery-public-data.chicago_crime.crime` | City of Chicago crime reports from 2001 to present |
| NOAA Weather | `bigquery-public-data.noaa_gsod.gsod20XX` | Daily weather summaries from O'Hare and Midway stations |

## Project Structure
chicago_crime_analytics/
├── models/
│   ├── staging/          # Cleans and renames raw source data
│   ├── intermediate/     # Joins and enriches staged models
│   └── marts/            # Final aggregated, analytics-ready tables
├── tests/                # Custom singular tests
└── dbt_project.yml
## Models

### Staging
| Model | Description |
|---|---|
| `stg_crimes` | Cleans raw crime data — renames columns, casts types, filters to 2021+ |
| `stg_weather` | Cleans daily weather readings from O'Hare and Midway stations, unions 2021–2023 |

### Intermediate
| Model | Description |
|---|---|
| `int_crime_weather_joined` | Joins crimes to daily weather by date. Adds season, temperature bucket, and weekend flag |

### Marts
| Model | Description |
|---|---|
| `mart_crime_weather_summary` | Aggregated summary of crimes by year, month, season, temp bucket, and crime type. Includes arrest rates, rolling 3-month totals, and crime type rankings |

## Key Techniques Used

- **Layered modeling** — staging → intermediate → marts pattern
- **Window functions** — rolling 3-month crime totals, crime type rankings
- **Data quality tests** — not_null, unique, accepted_values across all layers
- **Source freshness** — raw sources defined and documented in _sources.yml
- **BigQuery-specific functions** — SAFE_DIVIDE, COUNTIF, EXTRACT

## How to Run

### Prerequisites
- dbt Cloud account connected to BigQuery
- Access to BigQuery Public Datasets

### Steps

1. Clone this repository
2. Connect to your BigQuery project in dbt Cloud
3. Run the full pipeline: dbt run
4. Run all data quality tests: dbt test
5. Generate and serve documentation:
dbt docs generate
dbt docs serve
## Results

The mart layer produces an aggregated table that can be used to answer 
questions such as:

- Which crime types are most common by season?
- Does extreme cold or heat correlate with higher or lower crime rates?
- Are arrest rates higher on weekdays or weekends?
- Which months see the highest volume of specific crime types?

## Author

Built as a portfolio project to demonstrate dbt and BigQuery skills using 
real-world public data.

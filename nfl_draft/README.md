# NFL Draft Analytics

## Project Overview
This analysis serves as a portfolio project to demonstrate proficiency with dbt. 
This project uses NFL Draft pick data to extract information from historical performance.

## Questions Answered
There are 5 questions addressed in this analysis:
    Q1: Which teams draft best?
    Q2: Which positions are over/underdrafted?
    Q3: Does pick value predict career success?
    Q4: Which rounds produce the most surplus value?
    Q5: Career AV curve by position

The primary success metric is "w_av", or weighted approximate value, from draft_picks.csv, as a way to quantify
a player's performance in the NFL. This metric was selected for its emphasis on peak seasons, making it a better
player quality measure than raw career av.

## Data Sources
NFL draft data was sourced from nflverse's GitHub
- draft picks: https://github.com/nflverse/nflverse-data/releases?q=draft_picks 
- draft value: https://raw.githubusercontent.com/leesharpe/nfldata/master/data/draft_values.csv

Draft picks prior to 1994 and after 2018 are filtered out of this analysis for recency and to allow time to accurately quantify 
a player's performance, respectively.  

## Tech Stack
dbt Core / dbt Cloud
BigQuery
Looker Studio

## Project Structure
nfl_draft/

├── models/

│   ├── staging/          # Cleans and renames raw source data

│   ├── intermediate/     # Joins and enriches staged models

│   └── marts/            # Final aggregated, analytics-ready tables

├── seeds/                # Raw CSV data loaded via dbt seed

├── tests/                # Custom singular tests

└── dbt_project.yml

## How to Run
dbt deps
dbt seed
dbt run
dbt test

Note: profiles.yml and BigQuery credentials are required to run this project.

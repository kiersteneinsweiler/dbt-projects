select
    id,
    'hello from my third model' as new_column
from {{ ref('my_first_dbt_model') }}
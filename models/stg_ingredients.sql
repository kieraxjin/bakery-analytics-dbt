with raw_ingredients as (select *

from {{ ref('cleaned_ingredients') }})

select cast(trial_id as integer) as trial_id
,cast (ingredient_name as varchar) as ingredient_name
,amount as ingredient_amount
,case when lower(unit) ilike ('%g') then 'grams'
    when lower(unit) ilike ('%cup%') then 'cups'
    when lower(unit) ilike ('%tsp%') then 'teaspoons'
    when lower(unit) ilike ('%tbsp%') then 'tablespoons'
    else unit end as unit

from raw_ingredients    
with raw_ingredients as (select *

from {{ ref('cleaned_ingredients') }})

select cast(trial_id as integer) as trial_id
,cast (ingredient_name as varchar) as ingredient_name

-- original amount 
,round(amount :: decimal,2) as ingredient_amount
-- scaled amounts 
,round(amount :: decimal * 0.5 ,2) as amount_half_batch
,round(amount :: decimal * 2 ,2) as amount_double_batch

,case when lower(unit) ilike ('%g') then 'grams'
    when lower(unit) ilike ('%cup%') then 'cups'
    when lower(unit) ilike ('%tsp%') then 'teaspoons'
    when lower(unit) ilike ('%tbsp%') then 'tablespoons'
    else unit end as unit

from raw_ingredients    
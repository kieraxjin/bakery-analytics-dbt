with recipes as (select
    cast(recipe_id as integer) as recipe_id,
    cast(recipe_name as varchar) as recipe_name,
    cast(category as varchar) as category
from {{ ref('recipes') }})

, trials as (select *
 
from {{ ref('recipe_trials') }}) 

select *
from recipes r
left join trials t
on r.recipe_id = t.recipe_id




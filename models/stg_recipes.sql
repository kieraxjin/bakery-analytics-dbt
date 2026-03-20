with recipes as (select
    recipe_id,
    recipe_name,
    category
from {{ ref('recipes') }})

, trials as (select *
 
from {{ ref('recipe_trials') }}) 

select *
from recipes r
left join trials t
on r.recipe_id = t.recipe_id




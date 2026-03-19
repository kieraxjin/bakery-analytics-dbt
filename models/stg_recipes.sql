with recipes as (select
    recipe_id,
    recipe_name,
    category
from {{ ref('recipes') }})

, trials as (select
    trial_id
    ,recipe_id
    ,trial_date
    ,hours_spent
    ,outcome
    ,rating
from {{ ref('recipe_trials') }}) 

select
    r.recipe_id
    ,r.recipe_name
    ,r.category
    ,t.trial_id
    ,t.trial_date
    ,t.hours_spent
    ,t.outcome
    ,t.rating
from recipes r
left join trials t
on r.recipe_id = t.recipe_id





with recipes as (select * from {{ref('stg_recipes')}}
)

, trials as (select * from {{ref('stg_recipe_trials')}}
)

select r.recipe_name
, r.category
,t.version
,t.trial_date
,t.adjustment_made
,t.rating
,t.rating - lag(t.rating) over (partition by t.recipe_id order by t.version) as rating_delta

from trials t 
join recipes r on t.recipe_id = r.recipe_id 
-- 🧪 1. INPUT (your setup)

-- These are the most important drivers of outcome
-- 	•	hydration_pct → how wet your dough is (hydration % = (water ÷ flour) × 100)
-- 	•	dough_temp → after mixing (VERY important)
-- 	•	proof_temp → temperature while proofing

with recipes as (
    select * from {{ref('stg_recipes')}}
),
trials as (
    select * from {{ref('stg_recipe_trials')}}
),
-- SQUASH the ingredients into one row per trial
ingredient_summary as (
    select 
        trial_id
        ,sum(case when ingredient_name ilike '%Flour%' and unit ilike 'cups' then ingredient_amount * 236
				   when ingredient_name ilike '%Flour%' and unit = 'grams' then ingredient_amount * 120 end) as total_flour
       
	    ,sum(case when ingredient_name ilike '%Water%' and unit ilike 'cups' then ingredient_amount * 236
		         when ingredient_name ilike '%Water%' and unit = 'grams' then ingredient_amount * 120  end ) as total_water
    from {{ref('stg_ingredients')}}
    group by trial_id
)



select  
    r.recipe_name
    ,r.category
    ,t.version
    ,t.trial_date
	,t.rating
	,i.total_water
	,i.total_flour
   ,round((i.total_water / nullif(i.total_flour, 0)) * 100, 1 ) || '%' as hydration_pct
    ,t.dough_temp
    ,t.proofing_temp
    ,t.adjustment_made
    ,t.rating
    ,t.rating - lag(t.rating) over (partition by t.recipe_id order by t.version) as rating_delta
from trials t 
left join recipes r on t.recipe_id = r.recipe_id 
left join ingredient_summary i on t.trial_id = i.trial_id
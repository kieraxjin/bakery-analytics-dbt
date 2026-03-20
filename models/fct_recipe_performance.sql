with recipes as (
    select * from {{ ref('stg_recipes') }}
),
trials as (
    select * from {{ ref('stg_recipe_trials') }}
)
select
    r.recipe_name,
    count(t.trial_id) as total_attempts,
    round(avg(t.rating), 1) as avg_rating,
    -- This calculates the success rate percentage
    round(sum(case when t.trial_outcome = 'Success' then 1 else 0 end) * 1.0 / count(t.trial_id), 2) as success_rate
from recipes r
left join trials t on r.recipe_id = t.recipe_id
group by 1


-- 1.if trial outcome is entered wrong then fix to either Success or Failed

-- select *
-- , case when lower(outcome) ilike 'succ%' then 'Success'
--     when lower(outcome) ilike 'fail%' then 'Failed' else 'Other' end as outcome


-- from {{ ref('recipe_trials') }}


select
    {{ dbt_utils.star(from=ref('recipe_trials'), except=['old_rating', 'new_rating', 'outcome']) }},
    
    -- 1. Cleaning the Outcome field
    case 
        when lower(outcome) ilike 'succ%' then 'Success'
        when lower(outcome) ilike 'fail%' then 'Failed' 
        else 'Other' 
    end as trial_outcome

from {{ ref('recipe_trials') }}
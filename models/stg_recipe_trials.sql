
select cast(trial_id as integer) as trial_id
    ,cast(recipe_id as integer) as recipe_id
    ,cast(trial_date as date) as trial_date 
    ,{{ dbt_utils.star(from=ref('recipe_trials'), except=['outcome']) }},
   
    case 
        when lower(outcome) ilike 'succ%' then 'Success'
        when lower(outcome) ilike 'fail%' then 'Failed' 
        else 'Other' 
    end as trial_outcome

from {{ ref('recipe_trials') }}
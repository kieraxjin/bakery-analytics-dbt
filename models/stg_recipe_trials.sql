
-- 1.if trial outcome is entered wrong then fix to either Success or Failed


select trial_id,
   recipe_id,
   trial_date,


case when lower(outcome) ilike 'succ%' then 'Success'
    when lower(outcome) ilike 'fail%' then 'Failed' else 'Other' end as clean_outcome


, rating


from {{ ref('recipe_trials') }}

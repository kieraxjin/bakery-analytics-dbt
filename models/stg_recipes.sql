with recipes as (select
    cast(recipe_id as integer) as recipe_id,
    cast(recipe_name as varchar) as recipe_name,
    cast(category as varchar) as category

from {{ ref('cleaned_recipes') }})


select * from recipes 



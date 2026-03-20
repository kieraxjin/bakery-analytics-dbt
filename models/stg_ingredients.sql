with raw_ingredients as (select *

from {{ ref('ingredients') }})

select cast(trial_id as integer) as trial_id
,lower(trim(ingredient_name)) as ingredient_name
,round(case when instr(amount, ' ') > 0 then cast(split_part(amount, ' ', 1) as float) + (cast(split_part(split_part(amount, ' ', 2), '/', 1) as float) /  cast(split_part(split_part(amount, ' ', 2), '/', 2) as float))
      when instr(amount, '/') > 0 then cast(split_part(amount, '/', 1) as float) / cast(split_part(amount, '/', 2) as float)
      else cast(amount as float) end ,4) as ingredient_amount

,case when lower(unit) ilike ('%g') then 'grams'
    when lower(unit) ilike ('%cup%') then 'cups'
    when lower(unit) ilike ('%tsp%') then 'teaspoons'
    when lower(unit) ilike ('%tbsp%') then 'tablespoons'
    else unit end as unit

from raw_ingredients    
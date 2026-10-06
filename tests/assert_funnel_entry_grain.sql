select
    entity_key,
    funnel_step
from {{ ref('fct_funnel_step_entries') }}
group by 1, 2
having count(*) > 1


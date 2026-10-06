select
    deal_instance_key,
    stage_id
from {{ ref('int_pipedrive__first_stage_entries') }}
group by 1, 2
having count(*) > 1


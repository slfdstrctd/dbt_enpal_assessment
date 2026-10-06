-- First observed entry of a logical deal instance into each pipeline stage.
-- The full event history remains available in fct_deal_stage_history; this model
-- provides stable first-entry semantics for conversion and funnel reporting.
select
    deal_instance_key,
    deal_id,
    new_value_id as stage_id,
    min(changed_at) as entered_at
from {{ ref('int_pipedrive__deal_changes') }}
where field_key = 'stage_id'
group by 1, 2, 3


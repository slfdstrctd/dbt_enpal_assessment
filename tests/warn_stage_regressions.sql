{{ config(severity='warn') }}

-- Backward movement is valid CRM history and must not fail the build. Surfacing
-- it as a warning makes the behavior visible while first-entry funnel semantics
-- remain stable.
with stages as (
    select
        deal_instance_key,
        new_value_id as stage_id,
        lag(new_value_id) over (
            partition by deal_instance_key
            order by changed_at
        ) as previous_stage_id
    from {{ ref('int_pipedrive__deal_changes') }}
    where field_key = 'stage_id'
)

select
    deal_instance_key,
    previous_stage_id,
    stage_id
from stages
where previous_stage_id is not null
    and stage_id <= previous_stage_id


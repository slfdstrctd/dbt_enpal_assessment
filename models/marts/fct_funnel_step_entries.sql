-- Canonical funnel-entry fact.
-- Grain: one logical entity entering one funnel step, first entry only.
with deal_creations as (
    select
        'deal_instance|' || deal_instance_key as entity_key,
        'deal_instance'::text as entity_type,
        deal_id,
        'creation'::text as source_type,
        'add_time'::text as source_key,
        created_at as entered_at
    from {{ ref('fct_deals') }}
),

stage_entries as (
    select
        'deal_instance|' || deal_instance_key as entity_key,
        'deal_instance'::text as entity_type,
        deal_id,
        'stage'::text as source_type,
        stage_id::text as source_key,
        entered_at
    from {{ ref('int_pipedrive__first_stage_entries') }}
    where stage_id between 2 and 9
),

call_entries as (
    select
        'activity_deal|' || deal_id::text as entity_key,
        'activity_deal'::text as entity_type,
        deal_id,
        'activity'::text as source_type,
        activity_type_key as source_key,
        entered_at
    from {{ ref('int_pipedrive__first_completed_sales_calls') }}
),

entries as (
    select * from deal_creations
    union all
    select * from stage_entries
    union all
    select * from call_entries
)

select
    entries.entity_key
        || '|'
        || funnel_steps.funnel_step as funnel_step_entry_id,
    entries.entity_key,
    entries.entity_type,
    entries.deal_id,
    funnel_steps.funnel_step,
    funnel_steps.kpi_name,
    funnel_steps.sort_order,
    entries.entered_at,
    entries.source_type as entry_source
from entries
inner join {{ ref('dim_funnel_steps') }} as funnel_steps
    on funnel_steps.source_type = entries.source_type
    and funnel_steps.source_key = entries.source_key

with observed_sources as (
    select distinct
        'creation'::text as source_type,
        'add_time'::text as source_key
    from {{ ref('fct_deals') }}

    union

    select distinct
        'stage'::text as source_type,
        stage_id::text as source_key
    from {{ ref('int_pipedrive__first_stage_entries') }}
    where stage_id between 2 and 9

    union

    select distinct
        'activity'::text as source_type,
        activity_type_key as source_key
    from {{ ref('int_pipedrive__first_completed_sales_calls') }}
)

select observed_sources.*
from observed_sources
left join {{ ref('dim_funnel_steps') }} as funnel_steps
    on funnel_steps.source_type = observed_sources.source_type
    and funnel_steps.source_key = observed_sources.source_key
where funnel_steps.funnel_step is null


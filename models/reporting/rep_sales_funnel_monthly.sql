{{ config(contract={'enforced': true}) }}

-- Dense monthly inflow: one row per month and funnel step. The upstream fact is
-- already first-entry-only, so the report can use count(*) without expensive
-- repeated distinct calculations.
with entries as (
    select
        date_trunc('month', entered_at)::date as month,
        funnel_step,
        count(*)::bigint as deals_count
    from {{ ref('fct_funnel_step_entries') }}
    group by 1, 2
),

month_bounds as (
    select
        min(month) as min_month,
        max(month) as max_month
    from entries
),

months as (
    select generate_series(
        month_bounds.min_month,
        month_bounds.max_month,
        interval '1 month'
    )::date as month
    from month_bounds
),

scaffold as (
    select
        months.month,
        funnel_steps.kpi_name::text as kpi_name,
        funnel_steps.funnel_step::text as funnel_step,
        funnel_steps.sort_order
    from months
    cross join {{ ref('dim_funnel_steps') }} as funnel_steps
)

select
    scaffold.month::date as month,
    scaffold.kpi_name::text as kpi_name,
    scaffold.funnel_step::text as funnel_step,
    coalesce(entries.deals_count, 0)::bigint as deals_count
from scaffold
left join entries
    on entries.month = scaffold.month
    and entries.funnel_step = scaffold.funnel_step

select
    source_type::text as source_type,
    source_key::text as source_key,
    funnel_step::text as funnel_step,
    kpi_name::text as kpi_name,
    sort_order::integer as sort_order
from {{ ref('funnel_steps') }}


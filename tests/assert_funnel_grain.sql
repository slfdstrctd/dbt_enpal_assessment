select
    month,
    funnel_step
from {{ ref('rep_sales_funnel_monthly') }}
group by 1, 2
having count(*) > 1
    or count(distinct kpi_name) > 1

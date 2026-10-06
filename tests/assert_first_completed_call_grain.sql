select
    deal_id,
    activity_type_key
from {{ ref('int_pipedrive__first_completed_sales_calls') }}
group by 1, 2
having count(*) > 1


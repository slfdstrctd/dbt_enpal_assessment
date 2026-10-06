-- Every report month must expose all eleven steps, including explicit zeroes.
select month
from {{ ref('rep_sales_funnel_monthly') }}
group by 1
having count(*) <> 11
    or count(distinct funnel_step) <> 11


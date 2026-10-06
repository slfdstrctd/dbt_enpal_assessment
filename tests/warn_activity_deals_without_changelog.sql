{{ config(severity='warn') }}

-- Expected in this synthetic extract: the activity and deal-change files are
-- almost disjoint populations. This warning prevents a future analyst from
-- silently treating the relationship as a reliable foreign key.
select distinct activities.deal_id
from {{ ref('fct_activities') }} as activities
left join {{ ref('fct_deals') }} as deals
    on deals.deal_id = activities.deal_id
where deals.deal_id is null


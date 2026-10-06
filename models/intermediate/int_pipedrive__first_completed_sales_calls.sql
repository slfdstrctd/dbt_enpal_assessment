-- First completed call of each funnel-relevant activity type per activity deal.
-- due_at is the only activity timestamp supplied by the extract and is therefore
-- an explicit proxy for completion time.
select
    deal_id,
    activity_type_key,
    min(due_at) as entered_at
from {{ ref('stg_pipedrive__activities') }}
where is_done
    and activity_type_key in ('meeting', 'sc_2')
group by 1, 2


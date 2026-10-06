select
    activities.activity_id::text || '|' || activities.deal_id::text as activity_key,
    activities.activity_id,
    activities.deal_id,
    activity_types.activity_type_id,
    activities.activity_type_key,
    activity_types.activity_type_name,
    activities.assigned_user_id,
    activities.is_done,
    activities.due_at
from {{ ref('stg_pipedrive__activities') }} as activities
inner join {{ ref('stg_pipedrive__activity_types') }} as activity_types
    on activity_types.activity_type_key = activities.activity_type_key

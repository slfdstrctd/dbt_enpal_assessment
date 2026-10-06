select
    activity_id,
    type as activity_type_key,
    assigned_to_user as assigned_user_id,
    deal_id,
    done as is_done,
    due_to as due_at
from {{ source('pipedrive', 'activity') }}

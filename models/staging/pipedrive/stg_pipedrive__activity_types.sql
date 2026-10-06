select
    id as activity_type_id,
    name as activity_type_name,
    type as activity_type_key,
    case active
        when 'Yes' then true
        when 'No' then false
    end as is_active
from {{ source('pipedrive', 'activity_types') }}

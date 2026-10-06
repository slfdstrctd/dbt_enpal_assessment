select
    activity_type_id,
    activity_type_key,
    activity_type_name,
    is_active
from {{ ref('stg_pipedrive__activity_types') }}

select
    user_id,
    user_name,
    email,
    updated_at
from {{ ref('stg_pipedrive__users') }}

select
    id as user_id,
    name as user_name,
    email,
    modified as updated_at
from {{ source('pipedrive', 'users') }}

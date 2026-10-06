select
    option_id as lost_reason_id,
    option_label as lost_reason_name
from {{ ref('int_pipedrive__field_options') }}
where field_key = 'lost_reason'

-- Each recovered instance must be one complete lifecycle. A failure means the
-- sample-specific clock fingerprint no longer separates this extract safely.
select deal_instance_key
from {{ ref('int_pipedrive__deal_changes') }}
group by 1
having count(*) filter (where field_key = 'add_time') <> 1
    or count(*) filter (where field_key = 'lost_reason') <> 1
    or count(*) filter (where field_key = 'user_id') < 1
    or count(*) filter (where field_key = 'stage_id') < 1

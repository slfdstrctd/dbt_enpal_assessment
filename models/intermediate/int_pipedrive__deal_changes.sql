-- Typed deal changelog.
-- Five source deal_ids are reused for two interleaved synthetic lifecycles.
-- Within this extract, every event belonging to one generated lifecycle shares
-- the same clock-time fingerprint. This sample-specific recovery rule must not
-- be treated as a general Pipedrive key: production ingestion should provide a
-- stable, unique source deal id. Tests fail if this extract assumption changes.
select
    deal_id::text || '|' || to_char(changed_at, 'HH24:MI:SS') as deal_instance_key,
    deal_id,
    to_char(changed_at, 'HH24:MI:SS') as instance_time_fingerprint,
    changed_at,
    field_key,
    new_value,
    case
        when field_key in ('stage_id', 'user_id', 'lost_reason') then new_value::integer
    end as new_value_id,
    case
        when field_key = 'add_time' then new_value::timestamp
    end as new_value_at
from {{ ref('stg_pipedrive__deal_changes') }}

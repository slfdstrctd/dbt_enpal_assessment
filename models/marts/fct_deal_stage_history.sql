with changes as (
    select * from {{ ref('int_pipedrive__deal_changes') }}
),

stage_entries as (
    select
        deal_instance_key,
        deal_id,
        new_value_id as stage_id,
        changed_at as entered_at,
        lag(new_value_id) over (
            partition by deal_instance_key
            order by changed_at
        ) as previous_stage_id,
        lead(changed_at) over (
            partition by deal_instance_key
            order by changed_at
        ) as next_stage_entered_at
    from changes
    where field_key = 'stage_id'
),

lost as (
    select
        deal_instance_key,
        changed_at as lost_at
    from changes
    where field_key = 'lost_reason'
),

owners as (
    select
        deal_instance_key,
        new_value_id as owner_user_id,
        changed_at as valid_from,
        lead(changed_at) over (
            partition by deal_instance_key
            order by changed_at
        ) as valid_to
    from changes
    where field_key = 'user_id'
)

select
    stage_entries.deal_instance_key
        || '|'
        || stage_entries.stage_id::text
        || '|'
        || to_char(stage_entries.entered_at, 'YYYY-MM-DD HH24:MI:SS') as stage_history_id,
    stage_entries.deal_instance_key,
    stage_entries.deal_id,
    stage_entries.stage_id,
    stage_entries.previous_stage_id,
    stage_entries.entered_at,
    coalesce(stage_entries.next_stage_entered_at, lost.lost_at) as exited_at,
    stage_entries.next_stage_entered_at is null as is_last_stage,
    owners.owner_user_id
from stage_entries
left join lost
    on lost.deal_instance_key = stage_entries.deal_instance_key
left join owners
    on owners.deal_instance_key = stage_entries.deal_instance_key
    and stage_entries.entered_at >= owners.valid_from
    and (
        owners.valid_to is null
        or stage_entries.entered_at < owners.valid_to
    )

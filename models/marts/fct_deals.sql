with changes as (
    select * from {{ ref('int_pipedrive__deal_changes') }}
),

created as (
    select
        deal_instance_key,
        deal_id,
        new_value_at as created_at
    from changes
    where field_key = 'add_time'
),

latest_values as (
    select
        deal_instance_key,
        field_key,
        new_value_id,
        changed_at
    from (
        select
            deal_instance_key,
            field_key,
            new_value_id,
            changed_at,
            row_number() over (
                partition by deal_instance_key, field_key
                order by changed_at desc
            ) as recency
        from changes
        where field_key in ('user_id', 'stage_id', 'lost_reason')
    ) as ranked
    where recency = 1
)

select
    created.deal_instance_key,
    created.deal_id,
    created.created_at,
    max(latest_values.new_value_id) filter (where latest_values.field_key = 'user_id') as owner_user_id,
    max(latest_values.new_value_id) filter (where latest_values.field_key = 'stage_id') as stage_id,
    max(latest_values.new_value_id) filter (where latest_values.field_key = 'lost_reason') as lost_reason_id,
    max(latest_values.changed_at) filter (where latest_values.field_key = 'lost_reason') as lost_at
from created
left join latest_values
    on latest_values.deal_instance_key = created.deal_instance_key
group by 1, 2, 3

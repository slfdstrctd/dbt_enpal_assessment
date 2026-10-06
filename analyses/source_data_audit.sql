-- Re-runnable evidence for the assumptions documented in README.md.
with metrics as (
    select 'deal_change_rows' as metric, count(*)::bigint as metric_value
    from {{ ref('stg_pipedrive__deal_changes') }}

    union all
    select 'source_deal_ids', count(distinct deal_id)::bigint
    from {{ ref('stg_pipedrive__deal_changes') }}

    union all
    select 'deal_creation_events', count(*)::bigint
    from {{ ref('stg_pipedrive__deal_changes') }}
    where field_key = 'add_time'

    union all
    select 'source_deal_ids_reused', count(*)::bigint
    from (
        select deal_id
        from {{ ref('stg_pipedrive__deal_changes') }}
        where field_key = 'add_time'
        group by 1
        having count(*) > 1
    ) as reused

    union all
    select 'activity_rows', count(*)::bigint
    from {{ ref('stg_pipedrive__activities') }}

    union all
    select 'activity_deal_ids', count(distinct deal_id)::bigint
    from {{ ref('stg_pipedrive__activities') }}

    union all
    select 'activity_ids_reused', count(*)::bigint
    from (
        select activity_id
        from {{ ref('stg_pipedrive__activities') }}
        group by 1
        having count(*) > 1
    ) as reused

    union all
    select 'completed_sales_calls', count(*)::bigint
    from {{ ref('stg_pipedrive__activities') }}
    where is_done and activity_type_key in ('meeting', 'sc_2')
)

select * from metrics
order by metric


-- Every stage change is one history row, and the owner join does not fan out.
with changelog as (
    select count(*) as row_count
    from {{ ref('int_pipedrive__deal_changes') }}
    where field_key = 'stage_id'
),

history as (
    select count(*) as row_count
    from {{ ref('fct_deal_stage_history') }}
)

select
    changelog.row_count as changelog_rows,
    history.row_count as history_rows
from changelog
cross join history
where changelog.row_count <> history.row_count

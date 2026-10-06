-- Each add_time event represents one generated logical deal instance.
with source_creations as (
    select count(*) as row_count
    from {{ ref('stg_pipedrive__deal_changes') }}
    where field_key = 'add_time'
),

deal_instances as (
    select count(*) as row_count
    from {{ ref('fct_deals') }}
)

select
    source_creations.row_count as source_creation_events,
    deal_instances.row_count as modeled_deal_instances
from source_creations
cross join deal_instances
where source_creations.row_count <> deal_instances.row_count


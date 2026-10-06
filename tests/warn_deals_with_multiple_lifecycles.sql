{{ config(severity='warn') }}

-- Source deal_id is not unique. These ids contain two generated lifecycles and
-- are split into deal_instance_key downstream using an extract-specific rule.
select deal_id
from {{ ref('stg_pipedrive__deal_changes') }}
where field_key = 'add_time'
group by 1
having count(*) > 1

select
    stages.stage_id,
    coalesce(options.option_label, stages.stage_name) as stage_name
from {{ ref('stg_pipedrive__stages') }} as stages
left join {{ ref('int_pipedrive__field_options') }} as options
    on options.field_key = 'stage_id'
    and options.option_id = stages.stage_id

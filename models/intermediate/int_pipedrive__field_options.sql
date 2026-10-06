select
    fields.field_id,
    fields.field_key,
    (option ->> 'id')::integer as option_id,
    option ->> 'label' as option_label
from {{ ref('stg_pipedrive__deal_fields') }} as fields,
    lateral jsonb_array_elements(fields.field_value_options) as option
where fields.field_value_options is not null

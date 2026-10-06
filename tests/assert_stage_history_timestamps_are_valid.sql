select history.*
from {{ ref('fct_deal_stage_history') }} as history
inner join {{ ref('fct_deals') }} as deals
    on deals.deal_instance_key = history.deal_instance_key
where history.entered_at < deals.created_at
    or (
        history.exited_at is not null
        and history.exited_at < history.entered_at
    )


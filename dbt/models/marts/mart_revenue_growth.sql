-- Pertumbuhan revenue month-over-month dengan LAG().
with monthly as (
    select
        d.ym,
        sum(f.total_amount) as revenue
    from {{ ref('fact_sales') }} f
    join {{ ref('dim_date') }}   d on f.date_key = d.date_key
    group by d.ym
),

with_prev as (
    select
        ym,
        revenue,
        lag(revenue) over (order by ym) as prev_revenue
    from monthly
)

select
    ym,
    revenue,
    prev_revenue,
    revenue - prev_revenue                                        as revenue_change,
    round(100.0 * (revenue - prev_revenue) / nullif(prev_revenue, 0), 2) as growth_pct
from with_prev
order by ym

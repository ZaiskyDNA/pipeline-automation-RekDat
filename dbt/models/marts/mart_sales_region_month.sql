-- Penjualan per region per bulan (join ke dim_customer untuk ambil region).
select
    d.ym,
    c.region,
    count(distinct f.order_id) as total_orders,
    sum(f.quantity)            as units_sold,
    sum(f.total_amount)        as revenue
from {{ ref('fact_sales') }}   f
join {{ ref('dim_customer') }} c on f.customer_id = c.customer_id
join {{ ref('dim_date') }}     d on f.date_key    = d.date_key
group by all
order by d.ym, revenue desc

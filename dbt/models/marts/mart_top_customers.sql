-- Customer dengan total belanja tertinggi (10 teratas).
select
    rank() over (order by sum(f.total_amount) desc) as spending_rank,
    c.customer_id,
    c.customer_name,
    c.region,
    count(distinct f.order_id) as total_orders,
    sum(f.quantity)            as total_units,
    sum(f.total_amount)        as total_spending
from {{ ref('fact_sales') }}   f
join {{ ref('dim_customer') }} c on f.customer_id = c.customer_id
group by c.customer_id, c.customer_name, c.region
qualify spending_rank <= 10
order by spending_rank, c.customer_id

-- 5 produk dengan revenue tertinggi di setiap kategori (window function + QUALIFY).
with product_sales as (
    select
        p.category,
        p.product_id,
        p.product_name,
        sum(f.quantity)     as units_sold,
        sum(f.total_amount) as revenue
    from {{ ref('fact_sales') }}  f
    join {{ ref('dim_product') }} p on f.product_id = p.product_id
    group by all
)

select
    category,
    row_number() over (partition by category order by revenue desc) as rank_in_category,
    product_id,
    product_name,
    units_sold,
    revenue
from product_sales
qualify rank_in_category <= 5
order by category, rank_in_category

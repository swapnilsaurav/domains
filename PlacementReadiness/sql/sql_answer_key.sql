-- =========================================================
-- BEGINNER: 1–30
-- =========================================================

-- 1. List all products and categories
SELECT product_id, product_name, category
FROM products;


-- 2. Find suppliers in India
SELECT *
FROM suppliers
WHERE country = 'India';


-- 3. Products priced above 5,000
SELECT product_id, product_name, category, selling_price
FROM products
WHERE selling_price > 5000;


-- 4. Gold-tier customers
SELECT *
FROM customers
WHERE service_tier = 'Gold';


-- 5. South-region warehouses
SELECT *
FROM warehouses
WHERE region = 'South';


-- 6. Critical orders
SELECT *
FROM orders
WHERE priority = 'Critical';


-- 7. Orders placed in 2026
SELECT *
FROM orders
WHERE order_date >= '2026-01-01'
  AND order_date < '2027-01-01';


-- 8. Class A products
SELECT *
FROM products
WHERE abc_class = 'A';


-- 9. High-risk suppliers
SELECT *
FROM suppliers
WHERE risk_level = 'High';


-- 10. POs above 1,500 units
SELECT *
FROM purchase_orders
WHERE ordered_qty > 1500;


-- 11. Count customers
SELECT COUNT(*) AS total_customers
FROM customers;


-- 12. Customers by region
SELECT
    region,
    COUNT(*) AS total_customers
FROM customers
GROUP BY region
ORDER BY total_customers DESC;


-- 13. Average unit cost
SELECT
    ROUND(AVG(unit_cost), 2) AS average_unit_cost
FROM products;


-- 14. Minimum / maximum selling price
SELECT
    MIN(selling_price) AS minimum_selling_price,
    MAX(selling_price) AS maximum_selling_price
FROM products;


-- 15. Total units ordered
SELECT
    SUM(quantity) AS total_units_ordered
FROM order_lines;


-- 16. Orders by status
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 17. Suppliers by country
SELECT
    country,
    COUNT(*) AS supplier_count
FROM suppliers
GROUP BY country
ORDER BY supplier_count DESC;


-- 18. Average supplier quality by country
SELECT
    country,
    ROUND(AVG(quality_pct), 2) AS avg_quality_pct
FROM suppliers
GROUP BY country
ORDER BY avg_quality_pct DESC;


-- 19. Warehouse capacity by region
SELECT
    region,
    SUM(capacity_units) AS total_capacity
FROM warehouses
GROUP BY region
ORDER BY total_capacity DESC;


-- 20. Average safety stock by category
SELECT
    category,
    ROUND(AVG(safety_stock), 2) AS avg_safety_stock
FROM products
GROUP BY category
ORDER BY avg_safety_stock DESC;


-- 21. Top 10 products by selling price
SELECT
    product_id,
    product_name,
    category,
    selling_price
FROM products
ORDER BY selling_price DESC
LIMIT 10;


-- 22. Top 10 POs by quantity
SELECT *
FROM purchase_orders
ORDER BY ordered_qty DESC
LIMIT 10;


-- 23. Search products using LIKE
-- Example: products containing "Product-0"
SELECT *
FROM products
WHERE product_name LIKE '%Product-0%';


-- 24. Customers in Hyderabad or Bengaluru
SELECT *
FROM customers
WHERE city IN ('Hyderabad', 'Bengaluru');


-- 25. Suppliers quality >= 98%
SELECT *
FROM suppliers
WHERE quality_pct >= 98;


-- 26. Gross line value
SELECT
    order_line_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price AS gross_line_value
FROM order_lines;


-- 27. Discounted line value
SELECT
    order_line_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    quantity * unit_price * (1 - discount_pct)
        AS net_line_value
FROM order_lines;


-- 28. Late shipments
SELECT *
FROM shipments
WHERE actual_delivery_date > promised_delivery_date;


-- 29. Shipments by mode
SELECT
    transport_mode,
    COUNT(*) AS shipment_count
FROM shipments
GROUP BY transport_mode
ORDER BY shipment_count DESC;


-- 30. Freight cost by mode
SELECT
    transport_mode,
    ROUND(SUM(freight_cost), 2) AS total_freight_cost
FROM shipments
GROUP BY transport_mode
ORDER BY total_freight_cost DESC;


-- =========================================================
-- INTERMEDIATE: 31–70
-- =========================================================

-- 31. Orders joined to customers
SELECT
    o.order_id,
    o.order_date,
    o.priority,
    o.order_status,
    c.customer_name,
    c.city,
    c.region,
    c.segment
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;


-- 32. Order lines joined to products
SELECT
    ol.order_line_id,
    ol.order_id,
    p.product_name,
    p.category,
    ol.quantity,
    ol.unit_price,
    ol.discount_pct
FROM order_lines ol
JOIN products p
    ON ol.product_id = p.product_id;


-- 33. Revenue by category
SELECT
    p.category,
    ROUND(
        SUM(ol.quantity * ol.unit_price * (1 - ol.discount_pct)),
        2
    ) AS revenue
FROM order_lines ol
JOIN products p
    ON ol.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- 34. Revenue by region
SELECT
    c.region,
    ROUND(
        SUM(ol.quantity * ol.unit_price * (1 - ol.discount_pct)),
        2
    ) AS revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_lines ol
    ON o.order_id = ol.order_id
GROUP BY c.region
ORDER BY revenue DESC;


-- 35. Top 10 customers by revenue
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(ol.quantity * ol.unit_price * (1 - ol.discount_pct)),
        2
    ) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_lines ol
    ON o.order_id = ol.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC
LIMIT 10;


-- 36. Top 10 products by units
SELECT
    p.product_id,
    p.product_name,
    SUM(ol.quantity) AS units_sold
FROM products p
JOIN order_lines ol
    ON p.product_id = ol.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC
LIMIT 10;


-- 37. Monthly revenue
SELECT
    strftime('%Y-%m', o.order_date) AS month,
    ROUND(
        SUM(ol.quantity * ol.unit_price * (1 - ol.discount_pct)),
        2
    ) AS revenue
FROM orders o
JOIN order_lines ol
    ON o.order_id = ol.order_id
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month;


-- 38. Quarterly revenue
SELECT
    strftime('%Y', o.order_date) AS year,
    ((CAST(strftime('%m', o.order_date) AS INTEGER) - 1) / 3) + 1
        AS quarter,
    ROUND(
        SUM(ol.quantity * ol.unit_price * (1 - ol.discount_pct)),
        2
    ) AS revenue
FROM orders o
JOIN order_lines ol
    ON o.order_id = ol.order_id
GROUP BY year, quarter
ORDER BY year, quarter;


-- 39. Average order value by customer segment
WITH order_values AS (
    SELECT
        o.order_id,
        c.segment,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS order_value
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    GROUP BY o.order_id, c.segment
)
SELECT
    segment,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM order_values
GROUP BY segment;


-- 40. Freight % of order revenue
WITH order_revenue AS (
    SELECT
        order_id,
        SUM(
            quantity * unit_price * (1 - discount_pct)
        ) AS revenue
    FROM order_lines
    GROUP BY order_id
)
SELECT
    s.order_id,
    ROUND(r.revenue, 2) AS revenue,
    s.freight_cost,
    ROUND(
        100.0 * s.freight_cost / NULLIF(r.revenue, 0),
        2
    ) AS freight_pct
FROM shipments s
JOIN order_revenue r
    ON s.order_id = r.order_id;


-- 41. Overall OTIF %
SELECT
    ROUND(100.0 * AVG(otif_flag), 2) AS otif_pct
FROM shipments;


-- 42. OTIF by region
SELECT
    c.region,
    ROUND(100.0 * AVG(s.otif_flag), 2) AS otif_pct
FROM shipments s
JOIN orders o
    ON s.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY otif_pct DESC;


-- 43. OTIF by segment
SELECT
    c.segment,
    ROUND(100.0 * AVG(s.otif_flag), 2) AS otif_pct
FROM shipments s
JOIN orders o
    ON s.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.segment;


-- 44. OTIF by carrier
SELECT
    carrier,
    ROUND(100.0 * AVG(otif_flag), 2) AS otif_pct
FROM shipments
GROUP BY carrier
ORDER BY otif_pct DESC;


-- 45. OTIF by mode
SELECT
    transport_mode,
    ROUND(100.0 * AVG(otif_flag), 2) AS otif_pct
FROM shipments
GROUP BY transport_mode
ORDER BY otif_pct DESC;


-- 46. Customers below 90% OTIF
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(*) AS shipments,
    ROUND(100.0 * AVG(s.otif_flag), 2) AS otif_pct
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN shipments s
    ON o.order_id = s.order_id
GROUP BY c.customer_id, c.customer_name
HAVING AVG(s.otif_flag) < 0.90
ORDER BY otif_pct;


-- 47. Carriers with highest average delay
SELECT
    carrier,
    ROUND(
        AVG(
            julianday(actual_delivery_date)
            - julianday(promised_delivery_date)
        ),
        2
    ) AS avg_delay_days
FROM shipments
GROUP BY carrier
ORDER BY avg_delay_days DESC;


-- 48. Average delay by region
SELECT
    c.region,
    ROUND(
        AVG(
            julianday(s.actual_delivery_date)
            - julianday(s.promised_delivery_date)
        ),
        2
    ) AS avg_delay_days
FROM shipments s
JOIN orders o
    ON s.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.region;


-- 49. Damage rate by carrier
SELECT
    carrier,
    COUNT(*) AS shipments,
    SUM(damage_flag) AS damaged_shipments,
    ROUND(100.0 * AVG(damage_flag), 2) AS damage_rate_pct
FROM shipments
GROUP BY carrier
ORDER BY damage_rate_pct DESC;


-- 50. Average freight by mode
SELECT
    transport_mode,
    ROUND(AVG(freight_cost), 2) AS avg_freight_cost
FROM shipments
GROUP BY transport_mode;


-- 51. Actual supplier lead time
SELECT
    po_id,
    supplier_id,
    po_date,
    received_date,
    CAST(
        julianday(received_date) - julianday(po_date)
        AS INTEGER
    ) AS actual_lead_time_days
FROM purchase_orders;


-- 52. Average lead time by supplier
SELECT
    s.supplier_id,
    s.supplier_name,
    ROUND(
        AVG(
            julianday(po.received_date)
            - julianday(po.po_date)
        ),
        2
    ) AS avg_actual_lead_time
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY avg_actual_lead_time DESC;


-- 53. Actual vs standard lead time
SELECT
    s.supplier_id,
    s.supplier_name,
    s.standard_lead_time_days,
    ROUND(
        AVG(
            julianday(po.received_date)
            - julianday(po.po_date)
        ),
        2
    ) AS avg_actual_lead_time
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.standard_lead_time_days;


-- 54. Suppliers exceeding standard lead time
SELECT
    s.supplier_id,
    s.supplier_name,
    s.standard_lead_time_days,
    ROUND(
        AVG(
            julianday(po.received_date)
            - julianday(po.po_date)
        ),
        2
    ) AS avg_actual_lead_time
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.standard_lead_time_days
HAVING AVG(
           julianday(po.received_date)
           - julianday(po.po_date)
       ) > s.standard_lead_time_days;


-- 55. Supplier acceptance rate
SELECT
    s.supplier_id,
    s.supplier_name,
    SUM(po.ordered_qty) AS ordered_qty,
    SUM(po.accepted_qty) AS accepted_qty,
    ROUND(
        100.0 * SUM(po.accepted_qty)
        / NULLIF(SUM(po.ordered_qty), 0),
        2
    ) AS acceptance_rate_pct
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name;


-- 56. Purchase spend by supplier
SELECT
    s.supplier_id,
    s.supplier_name,
    ROUND(
        SUM(po.ordered_qty * po.unit_cost),
        2
    ) AS purchase_spend
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY purchase_spend DESC;


-- 57. Top suppliers by spend
SELECT
    s.supplier_id,
    s.supplier_name,
    ROUND(
        SUM(po.ordered_qty * po.unit_cost),
        2
    ) AS purchase_spend
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY purchase_spend DESC
LIMIT 10;


-- 58. Average PO cost by product
SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(po.unit_cost), 2) AS avg_po_unit_cost
FROM products p
JOIN purchase_orders po
    ON p.product_id = po.product_id
GROUP BY p.product_id, p.product_name
ORDER BY avg_po_unit_cost DESC;


-- 59. Late PO count by supplier
SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(*) AS total_pos,
    SUM(
        CASE
            WHEN po.received_date > po.expected_date THEN 1
            ELSE 0
        END
    ) AS late_pos
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY late_pos DESC;


-- 60. Supplier quality/delivery scorecard
SELECT
    s.supplier_id,
    s.supplier_name,
    s.quality_pct,
    s.risk_level,
    COUNT(po.po_id) AS total_pos,

    ROUND(
        AVG(
            julianday(po.received_date)
            - julianday(po.po_date)
        ),
        2
    ) AS avg_lead_time_days,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN po.received_date <= po.expected_date
                THEN 1.0
                ELSE 0.0
            END
        ),
        2
    ) AS on_time_pct,

    ROUND(
        100.0 * SUM(po.accepted_qty)
        / NULLIF(SUM(po.ordered_qty), 0),
        2
    ) AS acceptance_pct

FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.quality_pct,
    s.risk_level;


-- 61. Inventory value by warehouse/month
SELECT
    strftime('%Y-%m', i.snapshot_date) AS month,
    w.warehouse_id,
    w.warehouse_name,
    ROUND(
        SUM(i.closing_stock * p.unit_cost),
        2
    ) AS inventory_value
FROM inventory_snapshots i
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
JOIN products p
    ON i.product_id = p.product_id
GROUP BY
    month,
    w.warehouse_id,
    w.warehouse_name
ORDER BY month, inventory_value DESC;


-- 62. Highest working-capital products
SELECT
    p.product_id,
    p.product_name,
    ROUND(
        SUM(i.closing_stock * p.unit_cost),
        2
    ) AS working_capital
FROM inventory_snapshots i
JOIN products p
    ON i.product_id = p.product_id
WHERE i.snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM inventory_snapshots
)
GROUP BY p.product_id, p.product_name
ORDER BY working_capital DESC
LIMIT 10;


-- 63. Products below reorder point
SELECT
    i.snapshot_date,
    w.warehouse_name,
    p.product_id,
    p.product_name,
    i.closing_stock,
    p.reorder_point
FROM inventory_snapshots i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
WHERE i.snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM inventory_snapshots
)
AND i.closing_stock < p.reorder_point;


-- 64. Products below safety stock
SELECT
    i.snapshot_date,
    w.warehouse_name,
    p.product_id,
    p.product_name,
    i.closing_stock,
    p.safety_stock
FROM inventory_snapshots i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
WHERE i.snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM inventory_snapshots
)
AND i.closing_stock < p.safety_stock;


-- 65. Latest inventory by warehouse
SELECT
    w.warehouse_id,
    w.warehouse_name,
    SUM(i.closing_stock) AS total_inventory_units
FROM inventory_snapshots i
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
WHERE i.snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM inventory_snapshots
)
GROUP BY w.warehouse_id, w.warehouse_name
ORDER BY total_inventory_units DESC;


-- 66. Forecast error
-- Convention: Actual - Forecast
SELECT
    forecast_id,
    month,
    product_id,
    forecast_qty,
    actual_qty,
    actual_qty - forecast_qty AS forecast_error
FROM demand_forecast;


-- 67. MAPE by product
SELECT
    p.product_id,
    p.product_name,
    ROUND(
        AVG(
            ABS(df.actual_qty - df.forecast_qty)
            * 100.0 / NULLIF(df.actual_qty, 0)
        ),
        2
    ) AS mape_pct
FROM demand_forecast df
JOIN products p
    ON df.product_id = p.product_id
WHERE df.actual_qty <> 0
GROUP BY p.product_id, p.product_name
ORDER BY mape_pct DESC;


-- 68. Accuracy by forecast method
SELECT
    forecast_method,

    ROUND(
        AVG(
            ABS(actual_qty - forecast_qty)
            * 100.0 / NULLIF(actual_qty, 0)
        ),
        2
    ) AS mape_pct,

    ROUND(
        100 -
        AVG(
            ABS(actual_qty - forecast_qty)
            * 100.0 / NULLIF(actual_qty, 0)
        ),
        2
    ) AS mape_based_accuracy_pct

FROM demand_forecast
WHERE actual_qty <> 0
GROUP BY forecast_method;


-- 69. Persistent under-forecasting
-- Here Actual > Forecast means underforecast
SELECT
    p.product_id,
    p.product_name,
    COUNT(*) AS underforecast_months
FROM demand_forecast df
JOIN products p
    ON df.product_id = p.product_id
WHERE df.actual_qty > df.forecast_qty
GROUP BY p.product_id, p.product_name
HAVING COUNT(*) >= 3
ORDER BY underforecast_months DESC;


-- 70. Largest absolute forecast errors
SELECT
    df.month,
    p.product_id,
    p.product_name,
    df.actual_qty,
    df.forecast_qty,
    ABS(df.actual_qty - df.forecast_qty)
        AS absolute_forecast_error
FROM demand_forecast df
JOIN products p
    ON df.product_id = p.product_id
ORDER BY absolute_forecast_error DESC
LIMIT 10;


-- =========================================================
-- ADVANCED: 71–90
-- =========================================================

-- 71. Monthly revenue + MoM growth using CTE/LAG
WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS month,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue
    FROM orders o
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    GROUP BY strftime('%Y-%m', o.order_date)
),
revenue_lag AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,
    ROUND(
        100.0 * (revenue - previous_revenue)
        / NULLIF(previous_revenue, 0),
        2
    ) AS mom_growth_pct
FROM revenue_lag
ORDER BY month;


-- 72. 3-month demand moving average
SELECT
    product_id,
    month,
    actual_qty,
    ROUND(
        AVG(actual_qty) OVER (
            PARTITION BY product_id
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_avg
FROM demand_forecast
ORDER BY product_id, month;


-- 73. Rank products within category
WITH product_revenue AS (
    SELECT
        p.category,
        p.product_id,
        p.product_name,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue
    FROM products p
    JOIN order_lines ol
        ON p.product_id = ol.product_id
    GROUP BY
        p.category,
        p.product_id,
        p.product_name
)
SELECT
    *,
    RANK() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS category_rank
FROM product_revenue
ORDER BY category, category_rank;


-- 74. Rank customers within region
WITH customer_revenue AS (
    SELECT
        c.region,
        c.customer_id,
        c.customer_name,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    GROUP BY
        c.region,
        c.customer_id,
        c.customer_name
)
SELECT
    *,
    RANK() OVER (
        PARTITION BY region
        ORDER BY revenue DESC
    ) AS region_rank
FROM customer_revenue
ORDER BY region, region_rank;


-- 75. Cumulative monthly revenue
WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS month,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue
    FROM orders o
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (ORDER BY month),
        2
    ) AS cumulative_revenue
FROM monthly_revenue;


-- 76. Category revenue contribution %
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue
    FROM products p
    JOIN order_lines ol
        ON p.product_id = ol.product_id
    GROUP BY p.category
)
SELECT
    category,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100.0 * revenue / SUM(revenue) OVER (),
        2
    ) AS revenue_contribution_pct
FROM category_revenue
ORDER BY revenue DESC;


-- 77. Demand vs previous month using LAG
SELECT
    product_id,
    month,
    actual_qty,
    LAG(actual_qty) OVER (
        PARTITION BY product_id
        ORDER BY month
    ) AS previous_month_demand,
    actual_qty -
    LAG(actual_qty) OVER (
        PARTITION BY product_id
        ORDER BY month
    ) AS demand_change
FROM demand_forecast;


-- 78. Three consecutive demand declines
WITH demand_history AS (
    SELECT
        product_id,
        month,
        actual_qty,

        LAG(actual_qty, 1) OVER (
            PARTITION BY product_id ORDER BY month
        ) AS m1,

        LAG(actual_qty, 2) OVER (
            PARTITION BY product_id ORDER BY month
        ) AS m2,

        LAG(actual_qty, 3) OVER (
            PARTITION BY product_id ORDER BY month
        ) AS m3

    FROM demand_forecast
)
SELECT *
FROM demand_history
WHERE actual_qty < m1
  AND m1 < m2
  AND m2 < m3;


-- 79. Rolling 6-month MAPE
SELECT
    product_id,
    month,

    ROUND(
        AVG(
            ABS(actual_qty - forecast_qty)
            * 100.0 / NULLIF(actual_qty, 0)
        ) OVER (
            PARTITION BY product_id
            ORDER BY month
            ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_6m_mape

FROM demand_forecast;


-- 80. Demand spike detection
WITH demand_ma AS (
    SELECT
        product_id,
        month,
        actual_qty,

        AVG(actual_qty) OVER (
            PARTITION BY product_id
            ORDER BY month
            ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
        ) AS previous_3m_avg

    FROM demand_forecast
)
SELECT
    product_id,
    month,
    actual_qty,
    ROUND(previous_3m_avg, 2) AS previous_3m_avg,
    ROUND(
        100.0 * (actual_qty - previous_3m_avg)
        / NULLIF(previous_3m_avg, 0),
        2
    ) AS spike_pct
FROM demand_ma
WHERE actual_qty > previous_3m_avg * 1.30;


-- 81. Supplier scorecard
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    s.risk_level,
    s.quality_pct,

    COUNT(po.po_id) AS total_pos,

    ROUND(
        SUM(po.ordered_qty * po.unit_cost),
        2
    ) AS purchase_spend,

    ROUND(
        AVG(
            julianday(po.received_date)
            - julianday(po.po_date)
        ),
        2
    ) AS avg_lead_time,

    ROUND(
        100.0 *
        AVG(
            CASE
                WHEN po.received_date <= po.expected_date
                THEN 1.0
                ELSE 0.0
            END
        ),
        2
    ) AS on_time_pct,

    ROUND(
        100.0 * SUM(po.accepted_qty)
        / NULLIF(SUM(po.ordered_qty), 0),
        2
    ) AS acceptance_pct

FROM suppliers s
LEFT JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.country,
    s.risk_level,
    s.quality_pct;


-- 82. Multi-KPI supplier ranks
WITH supplier_kpis AS (
    SELECT
        s.supplier_id,
        s.supplier_name,

        SUM(po.ordered_qty * po.unit_cost) AS spend,

        AVG(
            julianday(po.received_date)
            - julianday(po.po_date)
        ) AS avg_lead_time,

        100.0 * SUM(po.accepted_qty)
        / NULLIF(SUM(po.ordered_qty), 0)
        AS acceptance_pct

    FROM suppliers s
    JOIN purchase_orders po
        ON s.supplier_id = po.supplier_id
    GROUP BY s.supplier_id, s.supplier_name
)
SELECT
    *,
    RANK() OVER (
        ORDER BY spend DESC
    ) AS spend_rank,

    RANK() OVER (
        ORDER BY avg_lead_time
    ) AS lead_time_rank,

    RANK() OVER (
        ORDER BY acceptance_pct DESC
    ) AS quality_rank

FROM supplier_kpis;


-- 83. High-spend high-risk suppliers
WITH supplier_spend AS (
    SELECT
        s.supplier_id,
        s.supplier_name,
        s.risk_level,
        SUM(po.ordered_qty * po.unit_cost) AS spend
    FROM suppliers s
    JOIN purchase_orders po
        ON s.supplier_id = po.supplier_id
    GROUP BY
        s.supplier_id,
        s.supplier_name,
        s.risk_level
)
SELECT *
FROM supplier_spend
WHERE risk_level = 'High'
  AND spend > (
      SELECT AVG(spend)
      FROM supplier_spend
  )
ORDER BY spend DESC;


-- 84. Supplier concentration by product
SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT po.supplier_id) AS supplier_count
FROM products p
JOIN purchase_orders po
    ON p.product_id = po.product_id
GROUP BY p.product_id, p.product_name
ORDER BY supplier_count;


-- 85. Supplier spend share by product
WITH spend AS (
    SELECT
        product_id,
        supplier_id,
        SUM(ordered_qty * unit_cost) AS supplier_spend
    FROM purchase_orders
    GROUP BY product_id, supplier_id
)
SELECT
    product_id,
    supplier_id,
    ROUND(supplier_spend, 2) AS supplier_spend,

    ROUND(
        100.0 * supplier_spend
        / SUM(supplier_spend) OVER (
            PARTITION BY product_id
        ),
        2
    ) AS product_spend_share_pct

FROM spend
ORDER BY product_id, product_spend_share_pct DESC;


-- 86. POs >7 days late via CTE
WITH po_delays AS (
    SELECT
        po.*,
        julianday(received_date)
        - julianday(expected_date) AS delay_days
    FROM purchase_orders po
)
SELECT *
FROM po_delays
WHERE delay_days > 7
ORDER BY delay_days DESC;


-- 87. Recent vs prior supplier lead time
WITH max_date AS (
    SELECT MAX(po_date) AS max_po_date
    FROM purchase_orders
),
period_data AS (
    SELECT
        po.supplier_id,

        CASE
            WHEN po.po_date >= date(m.max_po_date, '-6 months')
            THEN 'Recent 6M'
            ELSE 'Previous 6M'
        END AS period,

        julianday(po.received_date)
        - julianday(po.po_date) AS lead_time

    FROM purchase_orders po
    CROSS JOIN max_date m

    WHERE po.po_date >= date(m.max_po_date, '-12 months')
)
SELECT
    supplier_id,

    ROUND(
        AVG(
            CASE
                WHEN period = 'Recent 6M'
                THEN lead_time
            END
        ),
        2
    ) AS recent_6m_lead_time,

    ROUND(
        AVG(
            CASE
                WHEN period = 'Previous 6M'
                THEN lead_time
            END
        ),
        2
    ) AS previous_6m_lead_time

FROM period_data
GROUP BY supplier_id;


-- 88. Supplier lead-time standard deviation
-- SQLite does not provide STDDEV_SAMP() in its standard build.
-- We can calculate population standard deviation manually.

WITH lead_times AS (
    SELECT
        supplier_id,
        julianday(received_date)
        - julianday(po_date) AS lead_time
    FROM purchase_orders
),
stats AS (
    SELECT
        supplier_id,
        AVG(lead_time) AS avg_lead_time,
        AVG(lead_time * lead_time) AS avg_squared_lead_time
    FROM lead_times
    GROUP BY supplier_id
)
SELECT
    supplier_id,
    ROUND(avg_lead_time, 2) AS avg_lead_time,

    ROUND(
        SQRT(
            avg_squared_lead_time
            - avg_lead_time * avg_lead_time
        ),
        2
    ) AS lead_time_stddev

FROM stats;


-- 89. High lead-time variability products
WITH lead_times AS (
    SELECT
        product_id,
        julianday(received_date)
        - julianday(po_date) AS lead_time
    FROM purchase_orders
),
stats AS (
    SELECT
        product_id,
        AVG(lead_time) AS avg_lead_time,
        AVG(lead_time * lead_time) AS avg_sq
    FROM lead_times
    GROUP BY product_id
),
variability AS (
    SELECT
        product_id,
        avg_lead_time,
        SQRT(
            avg_sq - avg_lead_time * avg_lead_time
        ) AS lead_time_stddev
    FROM stats
)
SELECT
    p.product_id,
    p.product_name,
    ROUND(v.avg_lead_time, 2) AS avg_lead_time,
    ROUND(v.lead_time_stddev, 2) AS lead_time_stddev
FROM variability v
JOIN products p
    ON v.product_id = p.product_id
WHERE v.lead_time_stddev > (
    SELECT AVG(lead_time_stddev)
    FROM variability
)
ORDER BY lead_time_stddev DESC;


-- 90. Supplier quality vs rolling baseline
WITH po_quality AS (
    SELECT
        po_id,
        supplier_id,
        po_date,

        100.0 * accepted_qty
        / NULLIF(ordered_qty, 0) AS acceptance_pct

    FROM purchase_orders
),
quality_history AS (
    SELECT
        *,

        AVG(acceptance_pct) OVER (
            PARTITION BY supplier_id
            ORDER BY po_date, po_id
            ROWS BETWEEN 10 PRECEDING AND 1 PRECEDING
        ) AS previous_10_po_avg

    FROM po_quality
)
SELECT *
FROM quality_history
WHERE previous_10_po_avg IS NOT NULL
  AND acceptance_pct < previous_10_po_avg
ORDER BY supplier_id, po_date;




-- =========================================================
-- ADVANCED: 91–110
-- =========================================================

-- 91. Inventory turns
-- Teaching approximation:
-- Annualized monthly issues / average inventory
SELECT
    p.product_id,
    p.product_name,

    ROUND(
        12.0 * AVG(i.issues_qty)
        / NULLIF(AVG(i.closing_stock), 0),
        2
    ) AS inventory_turns

FROM inventory_snapshots i
JOIN products p
    ON i.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY inventory_turns DESC;


-- 92. Days of Inventory
SELECT
    p.product_id,
    p.product_name,

    ROUND(
        365.0 * AVG(i.closing_stock)
        / NULLIF(12.0 * AVG(i.issues_qty), 0),
        2
    ) AS days_of_inventory

FROM inventory_snapshots i
JOIN products p
    ON i.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY days_of_inventory DESC;


-- 93. Monthly working capital by category
SELECT
    strftime('%Y-%m', i.snapshot_date) AS month,
    p.category,

    ROUND(
        SUM(i.closing_stock * p.unit_cost),
        2
    ) AS working_capital

FROM inventory_snapshots i
JOIN products p
    ON i.product_id = p.product_id
GROUP BY month, p.category
ORDER BY month, working_capital DESC;


-- 94. Inventory up while demand down
WITH inventory_monthly AS (
    SELECT
        strftime('%Y-%m', snapshot_date) AS month,
        product_id,
        SUM(closing_stock) AS inventory
    FROM inventory_snapshots
    GROUP BY month, product_id
),
inventory_change AS (
    SELECT
        *,
        LAG(inventory) OVER (
            PARTITION BY product_id
            ORDER BY month
        ) AS previous_inventory
    FROM inventory_monthly
),
demand_change AS (
    SELECT
        product_id,
        strftime('%Y-%m', month) AS month,
        actual_qty,

        LAG(actual_qty) OVER (
            PARTITION BY product_id
            ORDER BY month
        ) AS previous_demand

    FROM demand_forecast
)
SELECT
    i.product_id,
    i.month,
    i.inventory,
    i.previous_inventory,
    d.actual_qty,
    d.previous_demand
FROM inventory_change i
JOIN demand_change d
    ON i.product_id = d.product_id
   AND i.month = d.month
WHERE i.inventory > i.previous_inventory
  AND d.actual_qty < d.previous_demand;


-- 95. Slow-moving inventory
SELECT
    p.product_id,
    p.product_name,

    ROUND(AVG(i.closing_stock), 2) AS avg_inventory,
    ROUND(AVG(i.issues_qty), 2) AS avg_monthly_issues

FROM inventory_snapshots i
JOIN products p
    ON i.product_id = p.product_id

GROUP BY p.product_id, p.product_name

HAVING AVG(i.closing_stock) >
       (SELECT AVG(closing_stock)
        FROM inventory_snapshots)

AND AVG(i.issues_qty) <
       (SELECT AVG(issues_qty)
        FROM inventory_snapshots)

ORDER BY avg_inventory DESC;


-- 96. Working-capital quartiles using NTILE
WITH product_wc AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(i.closing_stock * p.unit_cost) AS working_capital
    FROM inventory_snapshots i
    JOIN products p
        ON i.product_id = p.product_id
    WHERE i.snapshot_date = (
        SELECT MAX(snapshot_date)
        FROM inventory_snapshots
    )
    GROUP BY p.product_id, p.product_name
)
SELECT
    *,
    NTILE(4) OVER (
        ORDER BY working_capital DESC
    ) AS working_capital_quartile
FROM product_wc;


-- 97. MoM working-capital change
WITH monthly_wc AS (
    SELECT
        strftime('%Y-%m', i.snapshot_date) AS month,
        SUM(i.closing_stock * p.unit_cost) AS working_capital
    FROM inventory_snapshots i
    JOIN products p
        ON i.product_id = p.product_id
    GROUP BY month
),
wc_lag AS (
    SELECT
        *,
        LAG(working_capital) OVER (
            ORDER BY month
        ) AS previous_wc
    FROM monthly_wc
)
SELECT
    month,
    ROUND(working_capital, 2) AS working_capital,
    ROUND(previous_wc, 2) AS previous_wc,

    ROUND(
        100.0 * (working_capital - previous_wc)
        / NULLIF(previous_wc, 0),
        2
    ) AS mom_wc_change_pct

FROM wc_lag;


-- 98. Warehouse utilization >90%
SELECT
    i.snapshot_date,
    w.warehouse_id,
    w.warehouse_name,
    w.capacity_units,

    SUM(i.closing_stock) AS inventory_units,

    ROUND(
        100.0 * SUM(i.closing_stock)
        / w.capacity_units,
        2
    ) AS utilization_pct

FROM inventory_snapshots i
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id

GROUP BY
    i.snapshot_date,
    w.warehouse_id,
    w.warehouse_name,
    w.capacity_units

HAVING 100.0 * SUM(i.closing_stock)
       / w.capacity_units > 90

ORDER BY utilization_pct DESC;


-- 99. Stockout-risk CASE
SELECT
    i.snapshot_date,
    w.warehouse_name,
    p.product_name,
    i.closing_stock,
    p.safety_stock,
    p.reorder_point,

    CASE
        WHEN i.closing_stock <= 0
            THEN 'Stockout'
        WHEN i.closing_stock < p.safety_stock
            THEN 'Critical'
        WHEN i.closing_stock < p.reorder_point
            THEN 'High Risk'
        ELSE 'Normal'
    END AS stockout_risk

FROM inventory_snapshots i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id;


-- 100. Revenue Pareto / ABC classification
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,

        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue

    FROM products p
    JOIN order_lines ol
        ON p.product_id = ol.product_id
    GROUP BY p.product_id, p.product_name
),
pareto AS (
    SELECT
        *,

        SUM(revenue) OVER (
            ORDER BY revenue DESC
        ) AS cumulative_revenue,

        SUM(revenue) OVER () AS total_revenue

    FROM product_revenue
)
SELECT
    product_id,
    product_name,
    ROUND(revenue, 2) AS revenue,

    ROUND(
        100.0 * cumulative_revenue / total_revenue,
        2
    ) AS cumulative_revenue_pct,

    CASE
        WHEN 100.0 * cumulative_revenue / total_revenue <= 80
            THEN 'A'
        WHEN 100.0 * cumulative_revenue / total_revenue <= 95
            THEN 'B'
        ELSE 'C'
    END AS revenue_abc_class

FROM pareto
ORDER BY revenue DESC;


-- 101. Monthly OTIF + 3-month moving average
WITH monthly_otif AS (
    SELECT
        strftime('%Y-%m', ship_date) AS month,
        100.0 * AVG(otif_flag) AS otif_pct
    FROM shipments
    GROUP BY month
)
SELECT
    month,
    ROUND(otif_pct, 2) AS otif_pct,

    ROUND(
        AVG(otif_pct) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS otif_3m_moving_avg

FROM monthly_otif;


-- 102. Customers with declining OTIF
WITH monthly_customer_otif AS (
    SELECT
        c.customer_id,
        c.customer_name,
        strftime('%Y-%m', s.ship_date) AS month,
        AVG(s.otif_flag) AS otif
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN shipments s
        ON o.order_id = s.order_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        month
),
history AS (
    SELECT
        *,

        LAG(otif, 1) OVER (
            PARTITION BY customer_id ORDER BY month
        ) AS m1,

        LAG(otif, 2) OVER (
            PARTITION BY customer_id ORDER BY month
        ) AS m2

    FROM monthly_customer_otif
)
SELECT *
FROM history
WHERE otif < m1
  AND m1 < m2;


-- 103. Cost-to-serve by customer
WITH revenue AS (
    SELECT
        o.customer_id,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue
    FROM orders o
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    GROUP BY o.customer_id
),
freight AS (
    SELECT
        o.customer_id,
        SUM(s.freight_cost) AS freight_cost
    FROM orders o
    JOIN shipments s
        ON o.order_id = s.order_id
    GROUP BY o.customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(r.revenue, 2) AS revenue,
    ROUND(f.freight_cost, 2) AS freight_cost,

    ROUND(
        100.0 * f.freight_cost
        / NULLIF(r.revenue, 0),
        2
    ) AS freight_cost_to_serve_pct

FROM customers c
JOIN revenue r
    ON c.customer_id = r.customer_id
JOIN freight f
    ON c.customer_id = f.customer_id
ORDER BY freight_cost_to_serve_pct DESC;


-- 104. High-revenue below-average-OTIF customers
WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue,

        AVG(s.otif_flag) AS otif

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    JOIN shipments s
        ON o.order_id = s.order_id

    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM customer_metrics
WHERE revenue > (
    SELECT AVG(revenue)
    FROM customer_metrics
)
AND otif < (
    SELECT AVG(otif)
    FROM customer_metrics
)
ORDER BY revenue DESC;


-- 105. Air vs non-Air cost/service
SELECT
    CASE
        WHEN transport_mode = 'Air'
            THEN 'Air'
        ELSE 'Non-Air'
    END AS mode_group,

    COUNT(*) AS shipments,

    ROUND(
        AVG(freight_cost),
        2
    ) AS avg_freight_cost,

    ROUND(
        100.0 * AVG(otif_flag),
        2
    ) AS otif_pct

FROM shipments
GROUP BY mode_group;


-- 106. High-cost low-OTIF regions
WITH regional_metrics AS (
    SELECT
        c.region,

        AVG(s.freight_cost) AS avg_freight_cost,

        AVG(s.otif_flag) AS otif

    FROM shipments s
    JOIN orders o
        ON s.order_id = o.order_id
    JOIN customers c
        ON o.customer_id = c.customer_id

    GROUP BY c.region
)
SELECT *
FROM regional_metrics
WHERE avg_freight_cost >
      (SELECT AVG(avg_freight_cost)
       FROM regional_metrics)

AND otif <
      (SELECT AVG(otif)
       FROM regional_metrics);


-- 107. Carrier scorecard
SELECT
    carrier,
    COUNT(*) AS total_shipments,

    ROUND(
        100.0 * AVG(otif_flag),
        2
    ) AS otif_pct,

    ROUND(
        100.0 * AVG(damage_flag),
        2
    ) AS damage_rate_pct,

    ROUND(
        AVG(
            julianday(actual_delivery_date)
            - julianday(promised_delivery_date)
        ),
        2
    ) AS avg_delay_days,

    ROUND(
        AVG(freight_cost),
        2
    ) AS avg_freight_cost,

    ROUND(
        SUM(freight_cost)
        / NULLIF(SUM(distance_km), 0),
        2
    ) AS freight_cost_per_km

FROM shipments
GROUP BY carrier
ORDER BY otif_pct DESC;


-- 108. Shipment performance CASE
SELECT
    shipment_id,
    order_id,
    carrier,
    otif_flag,
    damage_flag,

    CASE
        WHEN otif_flag = 1
             AND damage_flag = 0
            THEN 'Excellent'

        WHEN damage_flag = 0
            THEN 'Acceptable'

        ELSE 'Poor'
    END AS shipment_performance

FROM shipments;


-- 109. Late Critical orders
SELECT
    o.order_id,
    o.order_date,
    o.priority,
    s.carrier,
    s.promised_delivery_date,
    s.actual_delivery_date,

    CAST(
        julianday(s.actual_delivery_date)
        - julianday(s.promised_delivery_date)
        AS INTEGER
    ) AS delay_days

FROM orders o
JOIN shipments s
    ON o.order_id = s.order_id

WHERE o.priority = 'Critical'
  AND s.actual_delivery_date >
      s.promised_delivery_date

ORDER BY delay_days DESC;


-- 110. Distance vs freight analysis dataset
SELECT
    shipment_id,
    carrier,
    transport_mode,
    distance_km,
    freight_cost,

    ROUND(
        freight_cost / NULLIF(distance_km, 0),
        2
    ) AS freight_cost_per_km,

    otif_flag,
    damage_flag

FROM shipments
WHERE distance_km > 0;


-- =========================================================
-- ADVANCED: 111–120
-- =========================================================

-- 111. Monthly executive KPI query
WITH sales AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS month,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue
    FROM orders o
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    GROUP BY month
),
service AS (
    SELECT
        strftime('%Y-%m', ship_date) AS month,
        100.0 * AVG(otif_flag) AS otif_pct,
        SUM(freight_cost) AS freight_cost
    FROM shipments
    GROUP BY month
),
inventory AS (
    SELECT
        strftime('%Y-%m', i.snapshot_date) AS month,
        SUM(i.closing_stock * p.unit_cost) AS inventory_value
    FROM inventory_snapshots i
    JOIN products p
        ON i.product_id = p.product_id
    GROUP BY month
),
procurement AS (
    SELECT
        strftime('%Y-%m', po_date) AS month,
        SUM(ordered_qty * unit_cost) AS purchase_spend
    FROM purchase_orders
    GROUP BY month
),
forecast AS (
    SELECT
        strftime('%Y-%m', month) AS month,

        100 -
        AVG(
            ABS(actual_qty - forecast_qty)
            * 100.0 / NULLIF(actual_qty, 0)
        ) AS forecast_accuracy

    FROM demand_forecast
    WHERE actual_qty <> 0
    GROUP BY strftime('%Y-%m', month)
)
SELECT
    s.month,

    ROUND(s.revenue, 2) AS revenue,
    ROUND(se.otif_pct, 2) AS otif_pct,
    ROUND(se.freight_cost, 2) AS freight_cost,
    ROUND(i.inventory_value, 2) AS inventory_value,
    ROUND(p.purchase_spend, 2) AS purchase_spend,
    ROUND(f.forecast_accuracy, 2)
        AS forecast_accuracy_pct

FROM sales s
LEFT JOIN service se
    ON s.month = se.month
LEFT JOIN inventory i
    ON s.month = i.month
LEFT JOIN procurement p
    ON s.month = p.month
LEFT JOIN forecast f
    ON s.month = f.month

ORDER BY s.month;


-- 112. Create supplier performance view
DROP VIEW IF EXISTS vw_supplier_performance;

CREATE VIEW vw_supplier_performance AS
SELECT
    s.supplier_id,
    s.supplier_name,
    s.country,
    s.risk_level,
    s.quality_pct,

    COUNT(po.po_id) AS total_pos,

    AVG(
        julianday(po.received_date)
        - julianday(po.po_date)
    ) AS avg_lead_time_days,

    100.0 *
    AVG(
        CASE
            WHEN po.received_date <= po.expected_date
            THEN 1.0
            ELSE 0.0
        END
    ) AS on_time_delivery_pct,

    100.0 * SUM(po.accepted_qty)
    / NULLIF(SUM(po.ordered_qty), 0)
        AS acceptance_pct,

    SUM(po.ordered_qty * po.unit_cost)
        AS purchase_spend

FROM suppliers s
LEFT JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id

GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.country,
    s.risk_level,
    s.quality_pct;


-- Test it
SELECT *
FROM vw_supplier_performance;


-- 113. Create monthly sales view
DROP VIEW IF EXISTS vw_monthly_sales;

CREATE VIEW vw_monthly_sales AS
SELECT
    strftime('%Y-%m', o.order_date) AS month,

    COUNT(DISTINCT o.order_id) AS order_count,

    SUM(ol.quantity) AS units_sold,

    SUM(
        ol.quantity * ol.unit_price * (1 - ol.discount_pct)
    ) AS revenue

FROM orders o
JOIN order_lines ol
    ON o.order_id = ol.order_id

GROUP BY strftime('%Y-%m', o.order_date);


-- Test it
SELECT *
FROM vw_monthly_sales
ORDER BY month;


-- 114. Duplicate-record detection
-- Example: potential duplicate order lines
SELECT
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    COUNT(*) AS duplicate_count

FROM order_lines

GROUP BY
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct

HAVING COUNT(*) > 1;


-- 115. Recursive monthly calendar
WITH RECURSIVE calendar(month) AS (

    SELECT date(
        (SELECT MIN(order_date) FROM orders),
        'start of month'
    )

    UNION ALL

    SELECT date(month, '+1 month')
    FROM calendar

    WHERE month <
          date(
              (SELECT MAX(order_date) FROM orders),
              'start of month'
          )
),
monthly_revenue AS (
    SELECT
        date(order_date, 'start of month') AS month,
        SUM(
            quantity * unit_price * (1 - discount_pct)
        ) AS revenue
    FROM orders o
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    GROUP BY date(order_date, 'start of month')
)
SELECT
    c.month,
    COALESCE(m.revenue, 0) AS revenue
FROM calendar c
LEFT JOIN monthly_revenue m
    ON c.month = m.month
ORDER BY c.month;


-- 116. PERCENT_RANK freight outliers
WITH ranked_shipments AS (
    SELECT
        shipment_id,
        carrier,
        transport_mode,
        freight_cost,

        PERCENT_RANK() OVER (
            ORDER BY freight_cost
        ) AS freight_percent_rank

    FROM shipments
)
SELECT *
FROM ranked_shipments
WHERE freight_percent_rank >= 0.95
ORDER BY freight_cost DESC;


-- 117. Largest MoM demand increase
WITH demand_changes AS (
    SELECT
        product_id,
        month,
        actual_qty,

        LAG(actual_qty) OVER (
            PARTITION BY product_id
            ORDER BY month
        ) AS previous_demand

    FROM demand_forecast
),
changes AS (
    SELECT
        *,
        actual_qty - previous_demand AS demand_increase
    FROM demand_changes
)
SELECT *
FROM changes
WHERE previous_demand IS NOT NULL
ORDER BY demand_increase DESC;


-- 118. Customer Pareto top 20%
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,

        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_lines ol
        ON o.order_id = ol.order_id

    GROUP BY c.customer_id, c.customer_name
),
ranked AS (
    SELECT
        *,

        PERCENT_RANK() OVER (
            ORDER BY revenue DESC
        ) AS customer_percent_rank

    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    ROUND(revenue, 2) AS revenue,
    ROUND(customer_percent_rank * 100, 2)
        AS customer_rank_pct

FROM ranked

WHERE customer_percent_rank <= 0.20

ORDER BY revenue DESC;


-- 119. Working-capital reduction candidates
WITH latest_inventory AS (
    SELECT
        i.product_id,
        SUM(i.closing_stock) AS inventory_units
    FROM inventory_snapshots i
    WHERE i.snapshot_date = (
        SELECT MAX(snapshot_date)
        FROM inventory_snapshots
    )
    GROUP BY i.product_id
),
recent_demand AS (
    SELECT
        product_id,
        AVG(actual_qty) AS avg_demand
    FROM demand_forecast
    WHERE month >= date(
        (SELECT MAX(month) FROM demand_forecast),
        '-3 months'
    )
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    p.category,

    li.inventory_units,

    ROUND(
        li.inventory_units * p.unit_cost,
        2
    ) AS working_capital,

    ROUND(rd.avg_demand, 2) AS recent_avg_demand,

    p.safety_stock,
    p.reorder_point

FROM products p
JOIN latest_inventory li
    ON p.product_id = li.product_id
LEFT JOIN recent_demand rd
    ON p.product_id = rd.product_id

WHERE li.inventory_units >
      COALESCE(rd.avg_demand, 0)

ORDER BY working_capital DESC;


-- 120. Supply Chain Control Tower query
WITH sales AS (
    SELECT
        strftime('%Y-%m', o.order_date) AS month,

        COUNT(DISTINCT o.order_id) AS orders,

        SUM(ol.quantity) AS units_sold,

        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_pct)
        ) AS revenue

    FROM orders o
    JOIN order_lines ol
        ON o.order_id = ol.order_id
    GROUP BY month
),
logistics AS (
    SELECT
        strftime('%Y-%m', ship_date) AS month,

        COUNT(*) AS shipments,

        100.0 * AVG(otif_flag) AS otif_pct,

        100.0 * AVG(damage_flag) AS damage_pct,

        SUM(freight_cost) AS freight_cost

    FROM shipments
    GROUP BY month
),
inventory AS (
    SELECT
        strftime('%Y-%m', snapshot_date) AS month,

        SUM(closing_stock) AS inventory_units,

        SUM(closing_stock * p.unit_cost)
            AS inventory_value

    FROM inventory_snapshots i
    JOIN products p
        ON i.product_id = p.product_id

    GROUP BY month
),
procurement AS (
    SELECT
        strftime('%Y-%m', po_date) AS month,

        SUM(ordered_qty * unit_cost)
            AS purchase_spend,

        100.0 *
        AVG(
            CASE
                WHEN received_date <= expected_date
                THEN 1.0
                ELSE 0.0
            END
        ) AS supplier_on_time_pct

    FROM purchase_orders
    GROUP BY month
),
forecast AS (
    SELECT
        strftime('%Y-%m', month) AS month,

        SUM(actual_qty) AS actual_demand,

        SUM(forecast_qty) AS forecast_demand,

        100.0 *
        SUM(ABS(actual_qty - forecast_qty))
        / NULLIF(SUM(actual_qty), 0)
            AS wape_pct

    FROM demand_forecast
    GROUP BY strftime('%Y-%m', month)
)

SELECT
    s.month,

    s.orders,
    s.units_sold,
    ROUND(s.revenue, 2) AS revenue,

    l.shipments,
    ROUND(l.otif_pct, 2) AS otif_pct,
    ROUND(l.damage_pct, 2) AS damage_pct,
    ROUND(l.freight_cost, 2) AS freight_cost,

    i.inventory_units,
    ROUND(i.inventory_value, 2)
        AS inventory_working_capital,

    ROUND(p.purchase_spend, 2)
        AS purchase_spend,

    ROUND(p.supplier_on_time_pct, 2)
        AS supplier_on_time_pct,

    f.actual_demand,
    f.forecast_demand,
    ROUND(f.wape_pct, 2) AS forecast_wape_pct

FROM sales s

LEFT JOIN logistics l
    ON s.month = l.month

LEFT JOIN inventory i
    ON s.month = i.month

LEFT JOIN procurement p
    ON s.month = p.month

LEFT JOIN forecast f
    ON s.month = f.month

ORDER BY s.month;


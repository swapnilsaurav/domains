-- Instructor reference patterns (SQLite)
-- Revenue by category
SELECT p.category,SUM(ol.quantity*ol.unit_price*(1-ol.discount_pct)) revenue FROM order_lines ol JOIN products p ON ol.product_id=p.product_id GROUP BY p.category;
-- OTIF
SELECT ROUND(100.0*AVG(otif_flag),2) otif_pct FROM shipments;
-- Supplier lead time
SELECT supplier_id,AVG(julianday(received_date)-julianday(po_date)) avg_lead_days FROM purchase_orders GROUP BY supplier_id;
-- Acceptance rate
SELECT supplier_id,100.0*SUM(accepted_qty)/SUM(ordered_qty) acceptance_pct FROM purchase_orders GROUP BY supplier_id;
-- Working capital
SELECT i.snapshot_date,p.category,SUM(i.closing_stock*p.unit_cost) working_capital FROM inventory_snapshots i JOIN products p ON i.product_id=p.product_id GROUP BY i.snapshot_date,p.category;
-- MAPE
SELECT product_id,AVG(ABS(actual_qty-forecast_qty)*100.0/NULLIF(actual_qty,0)) mape FROM demand_forecast GROUP BY product_id;
-- Moving average
SELECT product_id,month,actual_qty,AVG(actual_qty) OVER(PARTITION BY product_id ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) ma3 FROM demand_forecast;
-- Rank within category
WITH r AS(SELECT p.category,p.product_id,SUM(ol.quantity*ol.unit_price*(1-ol.discount_pct)) revenue FROM products p JOIN order_lines ol ON p.product_id=ol.product_id GROUP BY p.category,p.product_id) SELECT *,RANK() OVER(PARTITION BY category ORDER BY revenue DESC) rnk FROM r;
-- Inventory turns
SELECT product_id,12.0*AVG(issues_qty)/NULLIF(AVG(closing_stock),0) inventory_turns FROM inventory_snapshots GROUP BY product_id;

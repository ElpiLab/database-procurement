--Query: 06:-- Question: Which supplier exhibits the longest average time deviation (delay in days)
--  between planned lead times and actual delivery durations, combined with analyzing their
--  overall impact on freight/shipping costs (shipping_cost)?


SET DEFINE OFF;
WITH SupplierShipping AS (
    -- Step 1: Calculate total shipping cost without duplication
    SELECT supplier_id, 
           SUM(shipping_cost) AS total_shipping_cost
    FROM KSBL_PURCHASE_ORDER
    WHERE delivery_date IS NOT NULL
    GROUP BY supplier_id
),
SupplierDelays AS (
    -- Step 2: Calculate the delays
    SELECT s.supplier_id,
           s.name AS supplier_name,
           ROUND(AVG(po.delivery_date - po.order_date), 1) AS avg_actual_delivery_days,
           ROUND(AVG(po.delivery_date - po.order_date) - AVG(sp.lead_time_days), 1) AS avg_delay_days
    FROM KSBL_SUPPLIER s
    JOIN KSBL_PURCHASE_ORDER po ON s.supplier_id = po.supplier_id
    JOIN KSBL_ORDER_POSITION op ON po.order_id = op.order_id
    JOIN KSBL_SUPPLIER_PRODUCT sp ON op.product_id = sp.product_id AND s.supplier_id = sp.supplier_id
    WHERE po.delivery_date IS NOT NULL
    GROUP BY s.supplier_id, s.name
)
-- Step 3: Combine, add the CASE statement, and order
SELECT 
    sd.supplier_name,
    sd.avg_actual_delivery_days,
    sd.avg_delay_days,
    ss.total_shipping_cost,
    CASE 
        WHEN sd.avg_delay_days > 0 AND ss.total_shipping_cost > 200 THEN 'High Delay, High Cost (Critical Risk)'
        WHEN sd.avg_delay_days > 0 THEN 'Delayed (Needs Improvement)'
        WHEN sd.avg_delay_days <= 0 AND ss.total_shipping_cost > 200 THEN 'On Time, But Expensive'
        ELSE 'Reliable & Cost-Effective'
    END AS supplier_performance_profile
FROM SupplierDelays sd
JOIN SupplierShipping ss ON sd.supplier_id = ss.supplier_id
ORDER BY sd.avg_delay_days DESC;
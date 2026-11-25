--Query: 06:-- Question: Which supplier exhibits the longest average time deviation (delay in days)
--  between planned lead times and actual delivery durations, combined with analyzing their
--  overall impact on freight/shipping costs (shipping_cost)?


SET DEFINE OFF;

SELECT 
       s.supplier_id,
       s.name AS supplier_name,
       ROUND(AVG(sp.lead_time_days), 1) AS avg_planned_days,
       ROUND(AVG(po.delivery_date - po.order_date), 1) AS avg_actual_days,
       ROUND(AVG(sp.lead_time_days - (po.delivery_date - po.order_date)), 1) AS avg_delta_days,
       CASE
           WHEN AVG(sp.lead_time_days - (po.delivery_date - po.order_date)) < -5 THEN 'CRITICAL DELAY'
           WHEN AVG(sp.lead_time_days - (po.delivery_date - po.order_date)) < 0  THEN 'MINOR DELAY'
           ELSE 'ON TIME / FASTER'
       END AS lead_time_status
FROM KSBL_SUPPLIER s
JOIN KSBL_PURCHASE_ORDER po
  ON s.supplier_id = po.supplier_id
JOIN KSBL_ORDER_POSITION op
  ON po.order_id = op.order_id
JOIN KSBL_SUPPLIER_PRODUCT sp
  ON po.supplier_id = sp.supplier_id
  AND op.product_id = sp.product_id
WHERE po.status = 'DELIVERED'
  AND po.delivery_date IS NOT NULL
  AND sp.lead_time_days IS NOT NULL
GROUP BY s.supplier_id, s.name
ORDER BY avg_delta_days ASC;
-- Query 05: -- Question: Which products have not been requested in any purchase order 
-- over the past 12 months, despite their current stock dropping 
-- below the defined minimum threshold (min_stock), signaling an impending supply bottleneck?

WITH BottleneckProducts AS (
    -- Step 1: Find the critical products
    SELECT p.product_id, 
           p.name AS product_name, 
           p.stock, 
           p.min_stock
    FROM KSBL_PRODUCT p
    WHERE p.stock < p.min_stock
      AND NOT EXISTS (
          SELECT 1 
          FROM KSBL_ORDER_POSITION op
          JOIN KSBL_PURCHASE_ORDER po ON op.order_id = po.order_id
          WHERE op.product_id = p.product_id 
            AND po.order_date > ADD_MONTHS(SYSDATE, -12) 
      )
)
-- Step 2: Join to available suppliers and show priorities
SELECT 
    bp.product_id,        -- <--- ADDED PRODUCT ID HERE
    bp.product_name,
    bp.stock,
    bp.min_stock,
    -- Get the last time this specific product was ordered
    (SELECT TO_CHAR(MAX(po.order_date), 'YYYY-MM-DD') 
     FROM KSBL_ORDER_POSITION op 
     JOIN KSBL_PURCHASE_ORDER po ON op.order_id = po.order_id 
     WHERE op.product_id = bp.product_id) AS last_ordered_date,
    -- Show the available suppliers
    s.name AS available_supplier,
    sp.priority,
    sp.unit_price,
    sp.lead_time_days
FROM BottleneckProducts bp
JOIN KSBL_SUPPLIER_PRODUCT sp ON bp.product_id = sp.product_id
JOIN KSBL_SUPPLIER s ON sp.supplier_id = s.supplier_id
ORDER BY bp.product_name, sp.priority ASC;
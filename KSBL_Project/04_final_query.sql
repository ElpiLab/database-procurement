-- ============================================================================
-- KSBL MEDSUPPLY - FINAL SQL QUERIES FOR SUBMISSION
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 0. PRE-QUERY DATA TWEAKS (Ensures Queries 3 & 4 return realistic results)
-- ----------------------------------------------------------------------------
-- Make a primary supplier's lead time > 14 days for Query 3
UPDATE KSBL_SUPPLIER_PRODUCT 
SET lead_time_days = 20 
WHERE supplier_id = 2 AND product_id = 1 AND priority = 1;

-- Reassign some orders to different departments so Query 4 has data
UPDATE KSBL_PURCHASE_ORDER SET employee_id = 3 WHERE order_id IN (1, 3, 6); -- Cardiology
UPDATE KSBL_PURCHASE_ORDER SET employee_id = 7 WHERE order_id IN (2, 5, 8); -- Oncology

COMMIT;


-- ============================================================================
-- 1. QUERIES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Query 1: Aggregation, HAVING & Date filter
-- Question: Which suppliers have never submitted an invoice or have not submitted one 
-- for over 2 years, allowing finance to flag them as inactive data cemetery entries?

-- ----------------------------------------------------------------------------
SELECT s.name AS supplier_name, 
       s.last_invoice_date, 
       SUM(op.quantity * op.unit_price_at_order) AS total_historical_spend
FROM KSBL_SUPPLIER s
JOIN KSBL_PURCHASE_ORDER po ON s.supplier_id = po.supplier_id
JOIN KSBL_ORDER_POSITION op ON po.order_id = op.order_id
WHERE s.last_invoice_date IS NULL 
   OR s.last_invoice_date < ADD_MONTHS(SYSDATE, -24)
GROUP BY s.name, s.last_invoice_date
HAVING SUM(op.quantity * op.unit_price_at_order) > 1000
ORDER BY total_historical_spend DESC;


-- ----------------------------------------------------------------------------
-- Query 2: Complex JOINs, Sorting & Compliance Risk
-- Question: Who are the top suppliers measured by total spend who have not yet accepted 
-- the mandatory Code of Conduct ('REQUESTED' or 'REJECTED'), enabling procurement to 
-- prioritize risk mitigation?
-- ----------------------------------------------------------------------------
SELECT s.name AS supplier_name, 
       s.code_of_conduct_status, 
       SUM(op.quantity * op.unit_price_at_order) AS total_spend
FROM KSBL_SUPPLIER s
JOIN KSBL_PURCHASE_ORDER po ON s.supplier_id = po.supplier_id
JOIN KSBL_ORDER_POSITION op ON po.order_id = op.order_id
WHERE s.code_of_conduct_status IN ('REQUESTED', 'REJECTED')
GROUP BY s.name, s.code_of_conduct_status
ORDER BY total_spend DESC;


-- ----------------------------------------------------------------------------
-- Query 3: Self-Join / Alternative Sourcing
-- Question: For which products does the primary supplier (Priority 1) have a planned delivery time of more than 14 days, 
--- and which specific backup suppliers (Priority 2) offer an alternative with respective prices and lead times?
-- ----------------------------------------------------------------------------
--- part 1- 
SELECT *
FROM KSBL_SUPPLIER_PRODUCT sp1
WHERE sp1.priority IN (1, 2)
  AND EXISTS (
      -- This subquery checks if this product has a slow Priority 1 supplier
      SELECT 1 
      FROM KSBL_SUPPLIER_PRODUCT sp2
      WHERE sp2.product_id = sp1.product_id 
        AND sp2.priority = 1 
        AND sp2.lead_time_days > 14
  )
ORDER BY sp1.product_id, sp1.priority; 


-- ----------------------------------------------------------------------------
-- Query 4: Aggregation, Percentage Calculation & Subquery
-- Question: Which hospital departments spend an above-average amount on sterile medical products (is_sterile = 'Y'), 
--- and what is each department's percentage share of the total hospital expenditure for this product type?
-- ----------------------------------------------------------------------------
WITH DeptSterileSpend AS (
    SELECT d.name AS department_name, 
           SUM(op.quantity * op.unit_price_at_order) AS sterile_spend
    FROM KSBL_DEPARTMENT d
    JOIN KSBL_EMPLOYEE e ON d.department_id = e.department_id
    JOIN KSBL_PURCHASE_ORDER po ON e.employee_id = po.employee_id
    JOIN KSBL_ORDER_POSITION op ON po.order_id = op.order_id
    JOIN KSBL_PRODUCT p ON op.product_id = p.product_id
    WHERE p.is_sterile = 'Y'
    GROUP BY d.name
)
SELECT 
    department_name, 
    ROUND(sterile_spend, 2) AS total_sterile_spend,
    ROUND((sterile_spend / (SELECT SUM(sterile_spend) FROM DeptSterileSpend)) * 100, 2) AS pct_share_of_total,
    CASE 
        WHEN sterile_spend > (SELECT AVG(sterile_spend) FROM DeptSterileSpend) 
        THEN 'YES - Above Average' 
        ELSE 'No' 
    END AS is_above_average
FROM DeptSterileSpend
ORDER BY sterile_spend DESC;


-- ----------------------------------------------------------------------------
-- Query 5: Subquery with NOT IN / EXISTS & Stock Monitoring
-- Question: Which products have not been requested in any purchase order over the past 12 months, despite their current stock dropping 
-- below the defined minimum threshold (min_stock), signaling an impending supply bottleneck?
-- ----------------------------------------------------------------------------
SELECT p.name AS product_name, 
       p.stock, 
       p.min_stock
FROM KSBL_PRODUCT p
WHERE p.stock < p.min_stock
  AND p.product_id NOT IN (
      SELECT op.product_id 
      FROM KSBL_ORDER_POSITION op
      JOIN KSBL_PURCHASE_ORDER po ON op.order_id = po.order_id
      WHERE po.order_date > ADD_MONTHS(SYSDATE, -12) 
  );


-- ----------------------------------------------------------------------------
-- Query 6: Date Calculation, Delivery Delay & Shipping Cost Analysis
-- Question: Which supplier exhibits the longest average time deviation (delay in days)
--  between planned lead times and actual delivery durations, combined with analyzing their
--  overall impact on freight/shipping costs (shipping_cost)?
-- ----------------------------------------------------------------------------
SELECT s.name AS supplier_name,
       ROUND(AVG(po.delivery_date - po.order_date), 1) AS avg_actual_delivery_days,
       ROUND(AVG(po.delivery_date - po.order_date) - AVG(sp.lead_time_days), 1) AS avg_delay_days,
       SUM(po.shipping_cost) AS total_shipping_cost
FROM KSBL_SUPPLIER s
JOIN KSBL_PURCHASE_ORDER po ON s.supplier_id = po.supplier_id
JOIN KSBL_ORDER_POSITION op ON po.order_id = op.order_id
JOIN KSBL_SUPPLIER_PRODUCT sp ON op.product_id = sp.product_id AND s.supplier_id = sp.supplier_id
WHERE po.delivery_date IS NOT NULL
GROUP BY s.name
ORDER BY avg_delay_days DESC;
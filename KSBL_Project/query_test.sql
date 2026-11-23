SELECT COUNT(*) FROM KSBL_PRODUCT;

SELECT COUNT(*) FROM KSBL_PURCHASE_ORDER;

SELECT COUNT(*) FROM KSBL_ORDER_POSITION;


---query 1: Inactive Data Cemetery (No invoice > 2 years)
SELECT s.name, s.last_invoice_date, s.code_of_conduct_status
FROM KSBL_SUPPLIER s
WHERE s.last_invoice_date IS NULL 
   OR s.last_invoice_date < ADD_MONTHS(SYSDATE, -24);

--- query 2; Compliance Risk (Top spenders without accepted code of conduct)
SELECT s.name AS supplier_name, 
       s.code_of_conduct_status, 
       SUM(op.quantity * op.unit_price_at_order) AS total_spend
FROM KSBL_SUPPLIER s
JOIN KSBL_PURCHASE_ORDER po ON s.supplier_id = po.supplier_id
JOIN KSBL_ORDER_POSITION op ON po.order_id = op.order_id
WHERE s.code_of_conduct_status IN ('REQUESTED', 'REJECTED')
GROUP BY s.name, s.code_of_conduct_status
ORDER BY total_spend DESC;


--- query 3: Self-Join (Primary supplier > 14 days, show backup)
SELECT p.name AS product_name,
       s1.name AS primary_supplier,
       sp1.lead_time_days AS primary_lead_time,
       s2.name AS backup_supplier,
       sp2.unit_price AS backup_price,
       sp2.lead_time_days AS backup_lead_time
FROM KSBL_PRODUCT p
JOIN KSBL_SUPPLIER_PRODUCT sp1 ON p.product_id = sp1.product_id AND sp1.priority = 1
JOIN KSBL_SUPPLIER s1 ON sp1.supplier_id = s1.supplier_id
JOIN KSBL_SUPPLIER_PRODUCT sp2 ON p.product_id = sp2.product_id AND sp2.priority = 2
JOIN KSBL_SUPPLIER s2 ON sp2.supplier_id = s2.supplier_id
WHERE sp1.lead_time_days > 14;

--- query 5: Impending supply bottleneck (Below min_stock, no orders recently)
SELECT p.name, p.stock, p.min_stock
FROM KSBL_PRODUCT p
WHERE p.stock < p.min_stock
  AND p.product_id NOT IN (
      SELECT op.product_id 
      FROM KSBL_ORDER_POSITION op
      JOIN KSBL_PURCHASE_ORDER po ON op.order_id = po.order_id
      WHERE po.order_date > ADD_MONTHS(SYSDATE, -12) -- Orders in last 12 months
  );

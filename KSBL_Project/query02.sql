-- Query 02: Question: Who are the top suppliers measured by total spend who have not yet
--  accepted the mandatory Code of Conduct ('REQUESTED' or 'REJECTED'), enabling procurement to 
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


-- sorted by risk criticality:
SELECT 
    s.name AS supplier_name, 
    s.code_of_conduct_status, 
    SUM(op.quantity * op.unit_price_at_order) AS total_spend,
    CASE 
        WHEN s.code_of_conduct_status = 'REJECTED' THEN 'CRITICAL RISK - Do not use'
        WHEN s.code_of_conduct_status = 'REQUESTED' THEN 'MEDIUM RISK - Pending acceptance'
    END AS risk_priority
FROM KSBL_SUPPLIER s
JOIN KSBL_PURCHASE_ORDER po ON s.supplier_id = po.supplier_id
JOIN KSBL_ORDER_POSITION op ON po.order_id = op.order_id
WHERE s.code_of_conduct_status IN ('REQUESTED', 'REJECTED')
GROUP BY s.name, s.code_of_conduct_status
-- Sort by Risk Priority first, then by Spend (highest spend first within each risk group)
ORDER BY risk_priority ASC, total_spend DESC;
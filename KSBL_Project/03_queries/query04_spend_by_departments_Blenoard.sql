-- Query 4: Aggregation, Percentage Calculation & Subquery
-- Question: Which hospital departments spend an above-average amount on sterile medical 
-- products (is_sterile = 'Y'),  and what is each department's percentage share of the
--  total hospital expenditure for this product type?


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
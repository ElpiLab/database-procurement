---- Query 1: Aggregation, HAVING & Date filter
-- Question: Which suppliers have never submitted an invoice or have not submitted one 
-- for over 2 years, allowing finance to flag them as inactive data cemetery entries?
-- with left join with no arbitrary condition : >1000 for example

SELECT 
    s.name AS supplier_name, 
    TO_CHAR(s.last_invoice_date, 'YYYY-MM-DD') AS last_invoice_date, 
    NVL(SUM(op.quantity * op.unit_price_at_order), 0) AS total_historical_spend
FROM KSBL_SUPPLIER s
-- Use LEFT JOIN so we still see suppliers with ZERO orders
LEFT JOIN KSBL_PURCHASE_ORDER po ON s.supplier_id = po.supplier_id
LEFT JOIN KSBL_ORDER_POSITION op ON po.order_id = op.order_id
WHERE s.last_invoice_date IS NULL 
   OR s.last_invoice_date < ADD_MONTHS(SYSDATE, -24)
GROUP BY s.name, s.last_invoice_date
-- REMOVED the HAVING clause so we can see everyone, even those with 0 spend
ORDER BY total_historical_spend DESC;
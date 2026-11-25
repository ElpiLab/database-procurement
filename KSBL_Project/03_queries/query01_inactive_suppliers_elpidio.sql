---- Query 1: Aggregation, HAVING & Date filter
-- Question: Which suppliers have never submitted an invoice or have not submitted one 
-- for over 2 years, allowing finance to flag them as inactive data cemetery entries?
-- with left join with no arbitrary condition : >1000 for example

SELECT 
    s.name AS supplier_name, 
    TO_CHAR(s.last_invoice_date, 'YYYY-MM-DD') AS last_invoice_date
FROM KSBL_SUPPLIER s
WHERE s.last_invoice_date IS NULL 
   OR s.last_invoice_date < ADD_MONTHS(SYSDATE, -24)
ORDER BY s.last_invoice_date ASC; 
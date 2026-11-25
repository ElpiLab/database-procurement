--- Query 03: -- Question: For which products does the primary supplier (Priority 1) 
-- have a planned delivery time of more than 14 days, and which specific backup suppliers 
-- (Priority 2) offer an alternative with respective prices and lead times?
-- without name:
SELECT 
    sp1.supplier_id,
    s.name AS supplier_name,     -- Supplier Name moved next to Supplier ID
    sp1.product_id,
    p.name AS product_name,      -- Product Name moved next to Product ID
    sp1.lead_time_days,
    sp1.unit_price,
    sp1.priority
FROM 
    KSBL_SUPPLIER_PRODUCT sp1
-- Join to get the Product Name
JOIN 
    KSBL_PRODUCT p ON sp1.product_id = p.product_id
-- Join to get the Supplier Name
JOIN 
    KSBL_SUPPLIER s ON sp1.supplier_id = s.supplier_id
WHERE 
    sp1.priority IN (1, 2)
    AND EXISTS (
        -- The filter: Only show products where the Priority 1 supplier is slow
        SELECT 1 
        FROM KSBL_SUPPLIER_PRODUCT sp2
        WHERE sp2.product_id = sp1.product_id 
          AND sp2.priority = 1 
          AND sp2.lead_time_days > 14
    )
ORDER BY 
    sp1.product_id, 
    sp1.priority;
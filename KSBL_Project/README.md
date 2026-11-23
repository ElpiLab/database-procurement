# KSBL Oracle scripts

This folder contains the runnable Oracle SQL for the KSBL MedSupply procurement database.

## Scripts

| File | Purpose |
|---|---|
| `ksbl_setup.sql` | Drops and recreates only the `KSBL_` tables. It does not touch unrelated tables in the schema. |
| `insert_data_ksbl.sql` | Inserts sample departments, suppliers, products, employees, supplier-product records, purchase orders, and order positions. |
| `master_insert.sql` | Full recreation script: resets the KSBL tables, creates the schema, and loads the sample data. |
| `query_test.sql` | Initial row-count checks and procurement query tests. |

## Quick start

Use Oracle FreeSQL, Oracle SQL Developer, or another Oracle SQL worksheet.

For a complete reset and reload, run only:

```text
master_insert.sql
```

Run it as a script using the tool's **Run Script** command, not as a single selected statement. The script only drops tables whose names begin with `KSBL_`.

For separate execution, run:

1. `ksbl_setup.sql`
2. `insert_data_ksbl.sql`
3. `query_test.sql`

The scripts use the following seven tables:

- `KSBL_SUPPLIER`
- `KSBL_PRODUCT`
- `KSBL_SUPPLIER_PRODUCT`
- `KSBL_DEPARTMENT`
- `KSBL_EMPLOYEE`
- `KSBL_PURCHASE_ORDER`
- `KSBL_ORDER_POSITION`

## Verification

After loading the data, verify the table and row counts with:

```sql
SELECT 'KSBL_SUPPLIER' AS table_name, COUNT(*) AS row_count FROM KSBL_SUPPLIER
UNION ALL
SELECT 'KSBL_PRODUCT', COUNT(*) FROM KSBL_PRODUCT
UNION ALL
SELECT 'KSBL_SUPPLIER_PRODUCT', COUNT(*) FROM KSBL_SUPPLIER_PRODUCT
UNION ALL
SELECT 'KSBL_DEPARTMENT', COUNT(*) FROM KSBL_DEPARTMENT
UNION ALL
SELECT 'KSBL_EMPLOYEE', COUNT(*) FROM KSBL_EMPLOYEE
UNION ALL
SELECT 'KSBL_PURCHASE_ORDER', COUNT(*) FROM KSBL_PURCHASE_ORDER
UNION ALL
SELECT 'KSBL_ORDER_POSITION', COUNT(*) FROM KSBL_ORDER_POSITION;
```

## Design note

The `KSBL_` prefix is used because the FreeSQL schema also contains tables from other exercises. It prevents table-name collisions while preserving the same logical procurement model.

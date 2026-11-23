# KSBL MedSupply Procurement Database

A group Oracle SQL project modelling supplier management, medical-product procurement, purchase orders, and basic stock monitoring for Kantonsspital Baselland (KSBL).

## My technical contribution

This was a collaborative university project. My main responsibility was the **technical database design and implementation**. In particular, I:

- Designed the logical data model and relationships.
- Created the ERD available in [`diagram/Logical_erd.pdf`](diagram/Logical_erd.pdf).
- Translated the model into Oracle DDL.
- Designed primary keys, foreign keys, composite keys, unique constraints, and validation rules.
- Resolved the supplier–product and order–product many-to-many relationships with associative tables.
- Built the reproducible KSBL-prefixed setup script in `KSBL_Project/ksbl_setup.sql`.
- Prepared the sample-data loading script and the all-in-one recreation script.
- Added SQL queries for supplier compliance, purchasing spend, supplier alternatives, and stock-risk analysis.
- Documented the model, assumptions, execution process, and technical scope.

The project context and business requirements were developed as a group. This repository highlights my work on the **ERD, relational modelling, Oracle schema design, constraints, and executable SQL scripts**.

## Project context

The database represents a simplified procurement and reporting system for a hospital. It replaces disconnected procurement spreadsheets with a relational model covering:

- Suppliers and compliance status
- Medical products and simplified current stock
- Supplier product catalogues, lead times, prices, and sourcing priorities
- Hospital departments and employees
- Purchase-order headers and order positions

It is intentionally a prototype rather than a complete hospital ERP, warehouse-management, finance, or clinical system.

## Technical highlights

- Oracle SQL and Oracle DDL
- Logical and relational data modelling
- Entity relationship design and cardinality analysis
- Primary keys and foreign keys
- Composite keys for associative entities
- `CHECK`, `UNIQUE`, and `NOT NULL` constraints
- Identity columns
- Referential actions with `ON DELETE CASCADE`
- Normalized master and transaction data
- Many-to-many relationship resolution
- SQL joins, aggregation, subqueries, filtering, and date analysis
- Reproducible database setup and sample-data loading

## Data model

The implementation contains seven KSBL-prefixed tables. The prefix prevents collisions with unrelated tables in a shared Oracle/FreeSQL schema.

| Table | Purpose |
|---|---|
| `KSBL_SUPPLIER` | Supplier master data and compliance information |
| `KSBL_PRODUCT` | Medical-product master data and stock thresholds |
| `KSBL_SUPPLIER_PRODUCT` | Supplier catalogue, price, lead time, and sourcing priority |
| `KSBL_DEPARTMENT` | Hospital departments and cost centres |
| `KSBL_EMPLOYEE` | Employees associated with departments and orders |
| `KSBL_PURCHASE_ORDER` | Purchase-order header, supplier, employee, status, and dates |
| `KSBL_ORDER_POSITION` | Products, quantities, and historical prices per order |

`KSBL_SUPPLIER_PRODUCT` resolves the many-to-many relationship between suppliers and products. `KSBL_ORDER_POSITION` resolves the many-to-many relationship between purchase orders and products while preserving order-specific quantity and price.

The design separates master data from transaction data and stores relationship-specific attributes in the appropriate associative tables. This avoids repeating supplier, product, and order information and prevents later catalogue-price changes from rewriting historical order prices.

## ERD and implementation

The main logical ERD is available here:

- [`diagram/Logical_erd.pdf`](diagram/Logical_erd.pdf)

The executable implementation is in [`KSBL_Project/`](KSBL_Project/):

- `ksbl_setup.sql` — drops and recreates only the KSBL tables.
- `insert_data_ksbl.sql` — loads departments, suppliers, products, employees, catalogues, orders, and order positions.
- `master_insert.sql` — performs a complete reset, schema creation, and data load.
- `query_test.sql` — contains row-count checks and procurement analysis queries.

## Running the database

The scripts target Oracle Database, Oracle FreeSQL, or Oracle SQL Developer.

### Complete reset and load

Run `KSBL_Project/master_insert.sql` as a **script** using Run Script/F5. It:

1. Drops only existing tables whose names begin with `KSBL_`.
2. Recreates the seven-table schema.
3. Loads the sample data.
4. Commits the transaction.

This does not remove unrelated tables in the schema.

### Separate execution

Alternatively, run the scripts in this order:

1. `KSBL_Project/ksbl_setup.sql`
2. `KSBL_Project/insert_data_ksbl.sql`
3. `KSBL_Project/query_test.sql`

After loading the data, the repository includes a row-count verification query in `KSBL_Project/README.md`.

## Example analytical use cases

The SQL layer supports questions such as:

- Which suppliers have no recent invoice record?
- Which non-compliant suppliers have historical purchasing spend?
- Which products have a slow primary supplier and an available backup supplier?
- Which products are below their minimum stock level?
- Which departments or suppliers generate the highest purchasing spend?
- Which suppliers have long delivery times or high shipping costs?

These queries demonstrate joins across the normalized schema, aggregation, filtering, subqueries, self-joins, and date-based analysis.

## Scope and modelling assumptions

This prototype does not include purchase requisitions, approval workflows, contracts, goods receipts, invoices, payments, detailed stock movements, authentication, or role-based access control.

Key assumptions include:

- `delivery_date` is used as the available delivery date; planned and actual delivery dates are not separated.
- A draft purchase order may temporarily have no positions.
- Supplier priority `1` represents a primary supplier and `2` represents a backup supplier.
- Stock is stored as a simplified current value rather than a movement history.
- The schema documents several business rules that would require triggers, application logic, or additional constraints in a production system.

## Repository structure

```text
README.md
LICENSE
KSBL_Project/
  README.md
  ksbl_setup.sql
  insert_data_ksbl.sql
  master_insert.sql
  query_test.sql
diagram/
  Logical_erd.pdf
  medsupply_ksbl_oracle_ddl_v5.pdf
documentation/
  Project_Overview.docx
  GROUP ASSIGNMENT – KSBL PROCRUMENT DB.docx
  medsupply_ksbl_oracle_ddl_v4.sql
```

## Academic context

This repository contains the technical database work from a group assignment. The scenario is academic and uses synthetic sample data, but the design demonstrates practical skills applicable to SQL development, data modelling, database engineering, and procurement analytics.

## License

This project is provided under the MIT License. See [LICENSE](LICENSE) for details.
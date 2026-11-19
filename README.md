# KSBL MedSupply Procurement Database

A relational Oracle database project for procurement, supplier management, and medical inventory at Kantonsspital Baselland (KSBL).

## Project overview

The database is designed to manage the internal purchasing and inventory processes of a hospital. Its purpose is to streamline the procurement of medical equipment, consumables such as syringes and surgical gloves, and pharmaceuticals across the hospital.

The system stores supplier relationships, product catalogues, stock levels, department information, employees responsible for purchasing, purchase orders, and order line items. It is intended to help the hospital monitor stock, compare suppliers, manage orders, track delivery information, and prevent critical supply shortages.

## Improvements: Y/N ?
 This project models a simplified procurement and basic inventory database for Kantonsspital Baselland. It centralises supplier, medical-product, department, employee, and purchase-order information that could otherwise be maintained in separate Excel files. The database supports supplier-product analysis, purchase-order tracking, basic stock-level monitoring, and procurement reporting through SQL queries. The current scope does not include full warehouse management, purchase requisitions, approval workflows, contract management, goods receipts, invoice processing, payment processing, or detailed stock-movement history.

## Main entities

- **Suppliers** — company information, contact details, address, invoice activity, and code-of-conduct status.
- **Products** — medical supplies, categories, current stock, minimum stock thresholds, and sterile status.
- **Supplier_Product** — associative table connecting suppliers and products, including catalogue numbers, lead times, prices, and sourcing priority.
- **Departments** — hospital departments, cost centres, and building information.
- **Employees** — staff members assigned to departments who are responsible for creating purchase orders.
- **Purchase Orders** — orders placed with external suppliers, including order dates, delivery dates, statuses, and shipping costs.
- **Order Positions** — the products, quantities, and historical prices included in each purchase order.

## Main business rules

- A supplier can provide many products, and a product can be provided by many suppliers.
- Every employee belongs to one department.
- Each purchase order is placed with one supplier by one employee.
- A purchase order can contain multiple products through its order positions.
- Product stock and minimum stock values cannot be negative.
- Supplier-product prices and historical order prices cannot be negative.
- Products can have primary and backup suppliers using sourcing priorities.
- Historical order prices are stored separately from current supplier prices.
- If stock falls below the minimum level, the product should be considered for reordering.

## Database design

The Oracle DDL script is located at:

`documentation/medsupply_ksbl_oracle_ddl_v4.sql`

It creates these seven tables:

1. `SUPPLIER`
2. `PRODUCT`
3. `SUPPLIER_PRODUCT`
4. `DEPARTMENT`
5. `EMPLOYEE`
6. `PURCHASE_ORDER`
7. `ORDER_POSITION`

The schema uses primary keys, foreign keys, unique constraints, mandatory fields, check constraints, identity columns, and cascading deletion from purchase orders to their order positions.

## Planned SQL questions

The project will use SQL queries to answer operational questions such as:

- Which suppliers have not submitted an invoice for more than two years despite significant historical purchase volume?
- Which high-spend suppliers have not accepted the mandatory code of conduct?
- Which products have a slow primary supplier and an available backup supplier?
- Which departments spend more than average on sterile products?
- Which products are below their minimum stock level and have not appeared in a recent purchase order?
- Which suppliers have the longest delivery delays and the greatest shipping-cost impact?

## Project status

The database schema and project documentation are currently included. Sample data, tested query files, query results, and the final ERD still need to be added.

The project uses Oracle SQL and is intended to be imported into Oracle SQL Developer or Oracle SQL Developer Data Modeler.

# KSBL MedSupply Procurement Database

A relational Oracle database project for procurement, supplier management, and medical inventory at Kantonsspital Baselland (KSBL).

## Project overview

This project models a simplified procurement and basic inventory database for Kantonsspital Baselland (KSBL). It represents procurement information that could otherwise be maintained in separate Excel files and provides a structured basis for storing, validating, and analysing the data.

The database stores supplier, medical-product, department, employee, supplier-product, purchase-order, and order-position information. It supports supplier-product analysis, purchase-order tracking, basic stock-level monitoring, and procurement reporting through SQL queries.

In a real hospital environment, similar data could be extracted from or integrated with systems such as SAP, Onventis, or Excel. This project is a standalone academic model and is not intended to replace the hospital's complete enterprise, procurement, finance, or inventory systems.

## Scope and boundaries

The current scope includes:

- Supplier master data and basic supplier compliance information.
- Medical-product master data, including current and minimum stock levels.
- Supplier-product relationships, catalogue numbers, lead times, prices, and sourcing priorities.
- Hospital departments and employees associated with purchase orders.
- Purchase orders and their product line items.
- SQL-based procurement and basic stock-level analysis.

The current scope does not include full warehouse management, purchase requisitions, approval workflows, contract management, goods receipts, invoice processing, payment processing, detailed stock-movement history, authentication, or role-based access control.

The database records current stock as a simplified value. It does not automatically create a reorder when stock falls below the minimum level; products below the threshold can instead be identified for replenishment through SQL analysis.

## Scope assumptions

- The database is a simplified procurement and reporting model for the assignment, not a complete hospital information system.
- `PURCHASE_ORDER.delivery_date` must be given a clear interpretation when delivery analysis queries are implemented, because the current schema does not separately store planned and actual delivery dates.
- A draft purchase order may temporarily contain no order positions. An ordered or delivered purchase order should contain at least one position, although this rule is not fully enforced by the current DDL.
- Sourcing priority `1` represents a primary supplier and priority `2` represents a backup supplier. The current schema does not enforce exactly one primary supplier or the existence of a backup supplier for every product.
- The current DDL does not fully enforce that every product on a purchase order is offered by the selected supplier in `SUPPLIER_PRODUCT`.


## Main entities

- **Suppliers** — company information, contact details, address, invoice activity, and code-of-conduct status.
- **Products** — medical supplies, categories, current stock, minimum stock thresholds, and sterile status.
- **Supplier_Product** — associative table connecting suppliers and products, including catalogue numbers, lead times, prices, and sourcing priority.
- **Departments** — hospital departments, cost centres, and building information.
- **Employees** — staff members assigned to departments who are responsible for creating purchase orders.
- **Purchase Orders** — orders placed with external suppliers, including order dates, delivery dates, statuses, and shipping costs.
- **Order Positions** — the products, quantities, and historical prices included in each purchase order.

## Main business rules

- A supplier can provide many products, and a product can be provided by many suppliers. This many-to-many relationship is resolved through `SUPPLIER_PRODUCT`.
- Each supplier-product relationship stores supplier-specific catalogue information, lead time, unit price, and sourcing priority.
- Every employee belongs to exactly one department.
- Each purchase order is associated with exactly one supplier and created by exactly one employee.
- A purchase order contains product lines through `ORDER_POSITION`. A draft order may temporarily contain zero positions, while an ordered or delivered order should contain at least one position.
- Each order position refers to exactly one product and must have a positive quantity.
- Product stock and minimum-stock values cannot be negative.
- Supplier-product prices and historical order prices cannot be negative.
- Sourcing priority `1` represents a primary supplier and priority `2` represents a backup supplier. The current schema does not enforce exactly one primary supplier or the existence of a backup supplier for every product.
- Historical order prices are stored separately from current supplier-product prices so that past purchasing costs remain accurate.
- Products below their minimum stock level should be identified for possible replenishment through SQL analysis; the database does not automatically create a reorder.
- Ideally, a purchase order should contain only products offered by its selected supplier. This rule is not fully enforced by the current DDL.


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

The initial database schema, project documentation, and ERD draft are included. The scope and business-rule assumptions still require agreement within the team. Sample data, tested query files, query results, and the final reviewed ERD still need to be completed.


The project uses Oracle SQL and is intended to be imported into Oracle SQL Developer or Oracle SQL Developer Data Modeler.

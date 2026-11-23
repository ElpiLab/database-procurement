# Project Deliverables and Task Tracker

This file tracks the deliverables for the KSBL MedSupply procurement database project.

## Status legend

- **Done** — completed and checked
- **In progress** — started but needs more work
- **To do** — not completed yet
- **Needs review** — completed draft that should be tested or checked

## Deliverables

| Deliverable | Required contents | Status | Repository location | Next action |
|---|---|---:|---|---|
| Project description | Scenario, purpose, scope, entities, and business rules | Done | `README.md`, documentation files | Review wording and add group member names |
| Logical ERD | Entities, attributes, identifiers, relationships, and cardinalities | To do | `diagram/` | Create the final ERD and export it as PDF or PNG |
| Relational schema | Tables, columns, data types, PKs, FKs, and constraints | Needs review | `documentation/medsupply_ksbl_oracle_ddl_v4.sql` | Run the script in Oracle and verify all constraints |
| Database implementation | Reproducible Oracle table creation script | Needs review | `documentation/medsupply_ksbl_oracle_ddl_v4.sql` | Confirm the script runs in a clean schema |
| Sample data | Realistic data for all seven tables | To do | `data/` or `sql/` | Create an insert script with consistent foreign-key values |
| SQL queries | At least two meaningful queries per group member | To do | `sql/queries/` | Assign queries and write the final SQL statements |
| Query results | Output from every submitted query and explanations | To do | `results/` | Run queries against the populated database and save results |
| Normalisation explanation | Short explanation of the 1NF, 2NF, and 3NF design | To do | `README.md` or `documentation/` | Explain why the associative and order-position tables are needed |
| Setup instructions | Database system, execution order, and recreation steps | In progress | `README.md` | Add commands and Oracle SQL Developer instructions |
| Group responsibilities | Names and contribution of each group member | To do | `README.md` or `documentation/` | Add member names and assign query ownership |
| Presentation | Slides explaining the scenario, design, and query demonstrations | To do | `presentation/` | Prepare slides after the schema and queries are tested |

## Recommended implementation order

1. Confirm the Oracle schema in a clean or dedicated project schema.
2. Review the seven-table design and finalise the ERD.
3. Create realistic sample data for every table.
4. Run integrity checks and confirm that foreign keys and constraints work.
5. Write the SQL queries and assign an owner to each query.
6. Run every query against the sample data and save the results.
7. Update the README with setup, usage, group members, and project status.
8. Prepare the final report and presentation.

## Proposed repository structure

```text
README.md
PROJECT_STATUS.md
documentation/
  medsupply_ksbl_oracle_ddl_v4.sql
  Project_Overview.docx
  GROUP ASSIGNMENT – KSBL PROCRUMENT DB.docx
diagram/
  README.md
  ksbl_med_supply_erd.pdf
  ksbl_med_supply_erd.png
sql/
  01_create_schema.sql
  02_insert_sample_data.sql
  queries/
    query_01_supplier_invoices.sql
    query_02_supplier_compliance.sql
    query_03_backup_suppliers.sql
    query_04_department_sterile_spending.sql
    query_05_low_stock_products.sql
    query_06_delivery_and_shipping.sql
results/
  query_results.md
presentation/
  ksbl_med_supply_presentation.pdf
```

## Final quality checklist

- [ ] The DDL runs successfully in a clean Oracle schema.
- [ ] All seven tables are created.
- [ ] Sample data loads without foreign-key or check-constraint errors.
- [ ] The ERD matches the implemented schema.
- [ ] Every query runs successfully against the submitted sample data.
- [ ] Every query has a question, SQL statement, result, explanation, and author.
- [ ] The README explains how to recreate and test the database.
- [ ] The final submission contains the ERD, scripts, queries, results, and presentation.

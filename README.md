
# Data Warehouse — Bronze Layer

## 📋 Overview

This project implements the **Bronze Layer** of a Data Warehouse following the **Medallion Architecture** (Bronze → Silver → Gold). The Bronze layer is responsible for ingesting raw data from source systems (CRM and ERP) into SQL Server staging tables with minimal transformation — just as-is copies of source data plus basic data quality visibility checks.

## 🏗️ Architecture

| Layer | Purpose |
|-------|---------|
| **Bronze** | Raw ingestion — exact copy of source data, no transformation |
| **Silver** | Cleaned, standardized, deduplicated, business rules applied *(planned)* |
| **Gold**   | Business-ready aggregated views/star schema *(planned)* |

## 📂 Source Systems

### CRM Source (`source_crm/`)

| File | Target Table | Description |
|------|--------------|--------------|
| `cust_info.csv` | `bronze.crm_cust_info` | Customer master data |
| `prd_info.csv` | `bronze.crm_prd_info` | Product master data |
| `sales_details.csv` | `bronze.crm_sales_details` | Sales transaction data |

### ERP Source (`source_erp/`)

| File | Target Table | Description |
|------|--------------|--------------|
| `LOC_A101.csv` | `bronze.erp_loc_a101` | Customer location data |
| `CUST_AZ12.csv` | `bronze.erp_cust_az12` | Customer demographic data (birthdate, gender) |
| `PX_CAT_G1V2.csv` | `bronze.erp_px_cat_g1v2` | Product category reference data |

## ⚙️ What This Script Does

### 1. Data Loading

For each of the 6 source tables, the script:

- **Truncates** the target Bronze table (full reload strategy)
- **Bulk inserts** data from the corresponding CSV file using `BULK INSERT`
- Uses `FIRSTROW = 2` to skip CSV headers
- Uses `TABLOCK` for faster bulk load performance
- Tracks and prints **load duration** in seconds for each table

### 2. Basic Data Quality Visibility Checks

After each table load, the script runs lightweight checks so you can **visually verify** the ingestion was successful:

- **Row Count** — `SELECT COUNT(*)` to compare against the source CSV file's row count
- **Data Preview** — `SELECT TOP 10 *` to visually inspect table structure (column headers) and confirm sample data loaded correctly

> This approach favors simplicity for learning purposes — no complex validation logic, just enough to confirm "did the load work and does the data look right?"

## 🚀 How to Run

**Step 1:** Update file paths in the script to match your local source file location. Example path format used in this script:'C:\sql\dwh_project\datasets\source_erp\px_cat_g1v2.csv'


**Step 2:** Ensure Bronze tables already exist (DDL not included in this script — assumes tables are pre-created with matching column structure to CSV files)

**Step 3:** Execute the full script in SQL Server Management Studio (SSMS) or Azure Data Studio

**Step 4:** Review the `PRINT` output for:
- Load duration per table
- Row counts per table
- Top 10 row previews per table

## ✅ Manual Verification Checklist

After running the script, manually confirm for each table:

- [ ] Row count in SQL matches the number of data rows in the source CSV (excluding header)
- [ ] Column headers in preview match expected source file structure
- [ ] No unexpected `NULL` values in key preview columns
- [ ] Load duration is reasonable (no unexpected performance issues)

## DQ Framework (DQ_check_bronze/)
Scripts/Bronze/bronze_load_simple.sql — Simple load: BULK INSERT + row count + TOP 10 preview
Scripts/Bronze/DQ_check_bronze/LOGGING INFRASTRUCTURE.sql — Creates bronze.load_log and bronze.dq_log tables
Scripts/Bronze/DQ_check_bronze/GENERIC DQ CHECK PROCEDURE.sql — Reusable stored procedure: bronze.usp_run_dq_check
Scripts/Bronze/DQ_check_bronze/Master Load DQ Procedure (All Tables).sql — Main procedure: bronze.usp_load_bronze
Scripts/Bronze/DQ_check_bronze/DQ_Bronze_Reporting Queries.sql — Ad-hoc queries to review load/DQ results
A structured, reusable framework with logging and automated pass/fail tracking for every check, split across four files.
LOGGING INFRASTRUCTURE.sql creates two logging tables: bronze.load_log, which tracks every load's start/end time, duration, row count, success/failure status, and error message; and bronze.dq_log, which tracks every DQ check's name, category, issue count, pass/fail/error status, and timestamp.
GENERIC DQ CHECK PROCEDURE.sql defines bronze.usp_run_dq_check, a reusable stored procedure that accepts a table name, check name, check category, and a dynamic SQL snippet, executes the check and counts issues, logs the result into bronze.dq_log automatically, and marks status as PASS (0 issues), FAIL (issues found), or ERROR (check itself failed). This means new DQ checks can be added with a single EXEC call — no need to write new logging logic each time.
Master Load DQ Procedure (All Tables).sql defines bronze.usp_load_bronze, the main orchestration procedure that, for each of the 6 source tables, truncates and reloads the table via BULK INSERT, logs load performance to bronze.load_log, and runs a full suite of granular DQ checks via bronze.usp_run_dq_check organized by category: Completeness (NULL checks on primary keys, required fields, row count > 0), Uniqueness (duplicate primary key detection), Validity (negative/zero values, invalid categorical values such as gender/marital status/product line, unwanted whitespace, invalid date formats), Consistency (end date before start date, order date after ship/due date), Business Rule (sales = quantity × price cross-field validation), and Referential Integrity (foreign key checks across tables, e.g. orphaned prd_key, cust_id, cid). Each table load is wrapped in TRY/CATCH so one table failure does not stop the entire batch. In total there are approximately 58 granular DQ checks across all 6 tables.

DQ_Bronze_Reporting Queries.sql contains ad-hoc queries to review results after running bronze.usp_load_bronze, including load performance history from bronze.load_log, all DQ results from the latest run, only failed checks, a pass rate scorecard per table, and the top 20 worst offenders by issue count.

## 🚀 How to Run

### Simple Approach

Update file paths in bronze_load_simple.sql to your local source file location. Ensure Bronze tables already exist (DDL not included — assumes pre-created tables matching CSV structure). Execute the script in SSMS or Azure Data Studio. Review the PRINT output for load duration, row counts, and TOP 10 previews.

### DQ Framework Approach

Run the setup scripts once, in this order: LOGGING INFRASTRUCTURE.sql, then GENERIC DQ CHECK PROCEDURE.sql, then Master Load DQ Procedure (All Tables).sql. After setup, execute the load and DQ checks by running EXEC bronze.usp_load_bronze. Then review results using the queries in DQ_Bronze_Reporting Queries.sql, such as SELECT * FROM bronze.load_log ORDER BY log_date DESC and SELECT * FROM bronze.dq_log WHERE status = 'FAIL' ORDER BY check_date DESC.

## ✅ Manual Verification Checklist (Simple Approach)

- [ ] Row count in SQL matches the number of data rows in the source CSV (excluding header)
- [ ] Column headers in preview match expected source file structure
- [ ] No unexpected NULL values in key preview columns
- [ ] Load duration is reasonable

## ✅ Automated Verification Checklist (DQ Framework Approach)

- [ ] EXEC bronze.usp_load_bronze completes without unhandled errors
- [ ] bronze.load_log shows SUCCESS status for all 6 tables
- [ ] bronze.dq_log pass rate scorecard reviewed per table
- [ ] Any FAIL results investigated and root cause documented
- [ ] Known/expected issues (e.g., negative sls_price) noted for Silver layer cleanup

## 🛠️ Tech Stack

- SQL Server (T-SQL)
- BULK INSERT for file ingestion
- Dynamic SQL (sp_executesql) for reusable DQ checks
- TRY/CATCH error handling
- Medallion Architecture (Bronze/Silver/Gold)

---

*More sections (Silver Layer, Gold Layer) will be added as the project progresses.*


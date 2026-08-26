# Data Warehouse — Bronze Layer

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

## 🛠️ Tech Stack

- SQL Server (T-SQL)
- `BULK INSERT` for file ingestion
- Medallion Architecture (Bronze/Silver/Gold)

---

*More sections (Silver Layer, Gold Layer) will be added as the project progresses.*


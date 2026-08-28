/* =============================================================
   BRONZE LAYER - SIMPLE LOAD + BASIC DQ CHECKS (AS PROCEDURE)
   ============================================================= */

CREATE OR ALTER PROCEDURE bronze.usp_load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME, @end_time DATETIME;
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '================================================';

        /* -------------------------------------------------------------
           1. crm_cust_info
           ------------------------------------------------------------- */
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.crm_cust_info';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        PRINT '>> Row Count:';
        SELECT COUNT(*) AS row_count FROM bronze.crm_cust_info;

        PRINT '>> Preview (TOP 10 rows):';
        SELECT TOP 10 * FROM bronze.crm_cust_info;


        /* -------------------------------------------------------------
           2. crm_prd_info
           ------------------------------------------------------------- */
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.crm_prd_info';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        PRINT '>> Row Count:';
        SELECT COUNT(*) AS row_count FROM bronze.crm_prd_info;

        PRINT '>> Preview (TOP 10 rows):';
        SELECT TOP 10 * FROM bronze.crm_prd_info;


        /* -------------------------------------------------------------
           3. crm_sales_details
           ------------------------------------------------------------- */
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.crm_sales_details';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        PRINT '>> Row Count:';
        SELECT COUNT(*) AS row_count FROM bronze.crm_sales_details;

        PRINT '>> Preview (TOP 10 rows):';
        SELECT TOP 10 * FROM bronze.crm_sales_details;


        /* -------------------------------------------------------------
           4. erp_loc_a101
           ------------------------------------------------------------- */
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.erp_loc_a101';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        PRINT '>> Row Count:';
        SELECT COUNT(*) AS row_count FROM bronze.erp_loc_a101;

        PRINT '>> Preview (TOP 10 rows):';
        SELECT TOP 10 * FROM bronze.erp_loc_a101;


        /* -------------------------------------------------------------
           5. erp_cust_az12
           ------------------------------------------------------------- */
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.erp_cust_az12';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        PRINT '>> Row Count:';
        SELECT COUNT(*) AS row_count FROM bronze.erp_cust_az12;

        PRINT '>> Preview (TOP 10 rows):';
        SELECT TOP 10 * FROM bronze.erp_cust_az12;


        /* -------------------------------------------------------------
           6. erp_px_cat_g1v2
           ------------------------------------------------------------- */
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.erp_px_cat_g1v2';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        PRINT '>> Row Count:';
        SELECT COUNT(*) AS row_count FROM bronze.erp_px_cat_g1v2;

        PRINT '>> Preview (TOP 10 rows):';
        SELECT TOP 10 * FROM bronze.erp_px_cat_g1v2;


        /* ============================================================
           BATCH SUMMARY
        ============================================================ */
        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';

    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END
GO


-- /* =============================================================
--    BRONZE LAYER - SIMPLE LOAD + BASIC DQ CHECKS
--    =============================================================
--    Purpose: Load raw source files into Bronze tables and 
--    visually verify: row counts + sample data (top 10 rows)
--    ============================================================= */

-- SET NOCOUNT ON;

-- DECLARE @start_time DATETIME, @end_time DATETIME;

-- PRINT '================================================';
-- PRINT 'LOADING BRONZE LAYER';
-- PRINT '================================================';

-- /* -------------------------------------------------------------
--    1. crm_cust_info
--    ------------------------------------------------------------- */
-- PRINT '------------------------------------------------';
-- PRINT 'Loading Table: bronze.crm_cust_info';
-- PRINT '------------------------------------------------';

-- SET @start_time = GETDATE();
-- TRUNCATE TABLE bronze.crm_cust_info;

-- PRINT '>> Inserting Data Into: bronze.crm_cust_info';
-- BULK INSERT bronze.crm_cust_info
-- FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\cust_info.csv'
-- WITH (
--     FIRSTROW = 2,
--     FIELDTERMINATOR = ',',
--     TABLOCK
-- );
-- SET @end_time = GETDATE();
-- PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

-- PRINT '>> Row Count:';
-- SELECT COUNT(*) AS row_count FROM bronze.crm_cust_info;

-- PRINT '>> Preview (TOP 10 rows):';
-- SELECT TOP 10 * FROM bronze.crm_cust_info;


-- /* -------------------------------------------------------------
--    2. crm_prd_info
--    ------------------------------------------------------------- */
-- PRINT '------------------------------------------------';
-- PRINT 'Loading Table: bronze.crm_prd_info';
-- PRINT '------------------------------------------------';

-- SET @start_time = GETDATE();
-- TRUNCATE TABLE bronze.crm_prd_info;

-- PRINT '>> Inserting Data Into: bronze.crm_prd_info';
-- BULK INSERT bronze.crm_prd_info
-- FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\prd_info.csv'
-- WITH (
--     FIRSTROW = 2,
--     FIELDTERMINATOR = ',',
--     TABLOCK
-- );
-- SET @end_time = GETDATE();
-- PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

-- PRINT '>> Row Count:';
-- SELECT COUNT(*) AS row_count FROM bronze.crm_prd_info;

-- PRINT '>> Preview (TOP 10 rows):';
-- SELECT TOP 10 * FROM bronze.crm_prd_info;


-- /* -------------------------------------------------------------
--    3. crm_sales_details
--    ------------------------------------------------------------- */
-- PRINT '------------------------------------------------';
-- PRINT 'Loading Table: bronze.crm_sales_details';
-- PRINT '------------------------------------------------';

-- SET @start_time = GETDATE();
-- TRUNCATE TABLE bronze.crm_sales_details;

-- PRINT '>> Inserting Data Into: bronze.crm_sales_details';
-- BULK INSERT bronze.crm_sales_details
-- FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\sales_details.csv'
-- WITH (
--     FIRSTROW = 2,
--     FIELDTERMINATOR = ',',
--     TABLOCK
-- );
-- SET @end_time = GETDATE();
-- PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

-- PRINT '>> Row Count:';
-- SELECT COUNT(*) AS row_count FROM bronze.crm_sales_details;

-- PRINT '>> Preview (TOP 10 rows):';
-- SELECT TOP 10 * FROM bronze.crm_sales_details;


-- /* -------------------------------------------------------------
--    4. erp_loc_a101
--    ------------------------------------------------------------- */
-- PRINT '------------------------------------------------';
-- PRINT 'Loading Table: bronze.erp_loc_a101';
-- PRINT '------------------------------------------------';

-- SET @start_time = GETDATE();
-- TRUNCATE TABLE bronze.erp_loc_a101;

-- PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
-- BULK INSERT bronze.erp_loc_a101
-- FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\LOC_A101.csv'
-- WITH (
--     FIRSTROW = 2,
--     FIELDTERMINATOR = ',',
--     TABLOCK
-- );
-- SET @end_time = GETDATE();
-- PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

-- PRINT '>> Row Count:';
-- SELECT COUNT(*) AS row_count FROM bronze.erp_loc_a101;

-- PRINT '>> Preview (TOP 10 rows):';
-- SELECT TOP 10 * FROM bronze.erp_loc_a101;


-- /* -------------------------------------------------------------
--    5. erp_cust_az12
--    ------------------------------------------------------------- */
-- PRINT '------------------------------------------------';
-- PRINT 'Loading Table: bronze.erp_cust_az12';
-- PRINT '------------------------------------------------';

-- SET @start_time = GETDATE();
-- TRUNCATE TABLE bronze.erp_cust_az12;

-- PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
-- BULK INSERT bronze.erp_cust_az12
-- FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\CUST_AZ12.csv'
-- WITH (
--     FIRSTROW = 2,
--     FIELDTERMINATOR = ',',
--     TABLOCK
-- );
-- SET @end_time = GETDATE();
-- PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

-- PRINT '>> Row Count:';
-- SELECT COUNT(*) AS row_count FROM bronze.erp_cust_az12;

-- PRINT '>> Preview (TOP 10 rows):';
-- SELECT TOP 10 * FROM bronze.erp_cust_az12;


-- /* -------------------------------------------------------------
--    6. erp_px_cat_g1v2
--    ------------------------------------------------------------- */
-- PRINT '------------------------------------------------';
-- PRINT 'Loading Table: bronze.erp_px_cat_g1v2';
-- PRINT '------------------------------------------------';

-- SET @start_time = GETDATE();
-- TRUNCATE TABLE bronze.erp_px_cat_g1v2;

-- PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
-- BULK INSERT bronze.erp_px_cat_g1v2
-- FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\PX_CAT_G1V2.csv'
-- WITH (
--     FIRSTROW = 2,
--     FIELDTERMINATOR = ',',
--     TABLOCK
-- );
-- SET @end_time = GETDATE();
-- PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

-- PRINT '>> Row Count:';
-- SELECT COUNT(*) AS row_count FROM bronze.erp_px_cat_g1v2;

-- PRINT '>> Preview (TOP 10 rows):';
SELECT TOP 10 * FROM bronze.erp_px_cat_g1v2;

PRINT '================================================';
PRINT 'BRONZE LAYER LOAD COMPLETE';
PRINT '================================================';

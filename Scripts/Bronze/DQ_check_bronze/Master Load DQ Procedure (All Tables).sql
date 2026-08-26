/* =============================================================
   MAIN LOAD PROCEDURE: bronze.usp_load_bronze
   ============================================================= */

CREATE OR ALTER PROCEDURE bronze.usp_load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME, @end_time DATETIME, @row_count INT;
    DECLARE @batch_start DATETIME = GETDATE();

    PRINT '================================================';
    PRINT 'STARTING BRONZE LAYER LOAD: ' + CONVERT(NVARCHAR, @batch_start, 120);
    PRINT '================================================';

    /* ============================================================
       1. bronze.crm_cust_info
    ============================================================ */
    BEGIN TRY
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.crm_cust_info';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        SET @end_time = GETDATE();
        SELECT @row_count = COUNT(*) FROM bronze.crm_cust_info;

        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status)
        VALUES ('bronze.crm_cust_info', @start_time, @end_time,
                DATEDIFF(SECOND, @start_time, @end_time), @row_count, 'SUCCESS');

        PRINT '>> Rows Loaded: ' + CAST(@row_count AS NVARCHAR);
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';
        PRINT '>> Running DQ Checks...';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'Row Count > 0', 'Completeness',
            'SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE 0 END FROM bronze.crm_cust_info';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'NULL cst_id', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_cust_info WHERE cst_id IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'Duplicate cst_id', 'Uniqueness',
            'SELECT COUNT(*) FROM (SELECT cst_id FROM bronze.crm_cust_info WHERE cst_id IS NOT NULL GROUP BY cst_id HAVING COUNT(*) > 1) t';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'NULL cst_key', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_cust_info WHERE cst_key IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'Unwanted Spaces - First/Last Name', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_cust_info WHERE cst_firstname != TRIM(cst_firstname) OR cst_lastname != TRIM(cst_lastname)';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'NULL First/Last Name', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_cust_info WHERE cst_firstname IS NULL OR cst_lastname IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'Invalid cst_marital_status Values', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_cust_info WHERE cst_marital_status IS NOT NULL AND UPPER(TRIM(cst_marital_status)) NOT IN (''S'',''M'',''SINGLE'',''MARRIED'')';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'Invalid cst_gndr Values', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_cust_info WHERE cst_gndr IS NOT NULL AND UPPER(TRIM(cst_gndr)) NOT IN (''M'',''F'',''MALE'',''FEMALE'')';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_cust_info', 'Future or NULL cst_create_date', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_cust_info WHERE cst_create_date > GETDATE() OR cst_create_date IS NULL';

    END TRY
    BEGIN CATCH
        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status, error_message)
        VALUES ('bronze.crm_cust_info', @start_time, GETDATE(), NULL, NULL, 'FAILED', ERROR_MESSAGE());
        PRINT 'ERROR loading crm_cust_info: ' + ERROR_MESSAGE();
    END CATCH


    /* ============================================================
       2. bronze.crm_prd_info
    ============================================================ */
    BEGIN TRY
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.crm_prd_info';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        SET @end_time = GETDATE();
        SELECT @row_count = COUNT(*) FROM bronze.crm_prd_info;

        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status)
        VALUES ('bronze.crm_prd_info', @start_time, @end_time,
                DATEDIFF(SECOND, @start_time, @end_time), @row_count, 'SUCCESS');

        PRINT '>> Rows Loaded: ' + CAST(@row_count AS NVARCHAR);
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';
        PRINT '>> Running DQ Checks...';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'Row Count > 0', 'Completeness',
            'SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE 0 END FROM bronze.crm_prd_info';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'NULL prd_id', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_id IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'Duplicate prd_id', 'Uniqueness',
            'SELECT COUNT(*) FROM (SELECT prd_id FROM bronze.crm_prd_info WHERE prd_id IS NOT NULL GROUP BY prd_id HAVING COUNT(*) > 1) t';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'NULL prd_key', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_key IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'Unwanted Spaces - prd_key/prd_nm', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_key != TRIM(prd_key) OR prd_nm != TRIM(prd_nm)';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'NULL prd_cost', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_cost IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'Negative prd_cost', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_cost < 0';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'Zero prd_cost', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_cost = 0';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'Invalid prd_line Values', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_line IS NOT NULL AND UPPER(TRIM(prd_line)) NOT IN (''M'',''R'',''S'',''T'')';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'NULL prd_start_dt', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_start_dt IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_prd_info', 'End Date Before Start Date', 'Consistency',
            'SELECT COUNT(*) FROM bronze.crm_prd_info WHERE prd_end_dt < prd_start_dt';

    END TRY
    BEGIN CATCH
        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status, error_message)
        VALUES ('bronze.crm_prd_info', @start_time, GETDATE(), NULL, NULL, 'FAILED', ERROR_MESSAGE());
        PRINT ' ERROR loading crm_prd_info: ' + ERROR_MESSAGE();
    END CATCH


    /* ============================================================
       3. bronze.crm_sales_details
    ============================================================ */
    BEGIN TRY
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.crm_sales_details';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        SET @end_time = GETDATE();
        SELECT @row_count = COUNT(*) FROM bronze.crm_sales_details;

        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status)
        VALUES ('bronze.crm_sales_details', @start_time, @end_time,
                DATEDIFF(SECOND, @start_time, @end_time), @row_count, 'SUCCESS');

        PRINT '>> Rows Loaded: ' + CAST(@row_count AS NVARCHAR);
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';
        PRINT '>> Running DQ Checks...';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Row Count > 0', 'Completeness',
            'SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE 0 END FROM bronze.crm_sales_details';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'NULL sls_ord_num', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_ord_num IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'NULL sls_prd_key', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_prd_key IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Orphan sls_prd_key (FK Integrity)', 'Referential Integrity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details s
                LEFT JOIN bronze.crm_prd_info p ON s.sls_prd_key = p.prd_key
                WHERE p.prd_key IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Orphan sls_cust_id (FK Integrity)', 'Referential Integrity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details s
                LEFT JOIN bronze.crm_cust_info c ON s.sls_cust_id = c.cst_id
                WHERE c.cst_id IS NULL';

        -- Date checks
        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Invalid sls_order_dt Format/Zero', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Invalid sls_ship_dt Format/Zero', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Invalid sls_due_dt Format/Zero', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Order Date After Ship Date', 'Consistency',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_order_dt > sls_ship_dt';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Order Date After Due Date', 'Consistency',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_order_dt > sls_due_dt';

        -- Quantity checks
        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'NULL sls_quantity', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_quantity IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Negative sls_quantity', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_quantity < 0';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Zero sls_quantity', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_quantity = 0';

        -- Price checks (granular, as discussed)
        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'NULL sls_price', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_price IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Negative sls_price', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_price < 0';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Zero sls_price', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_price = 0';

        -- Sales checks
        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'NULL sls_sales', 'Completeness',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_sales IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Negative sls_sales', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_sales < 0';

        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Zero sls_sales', 'Validity',
            'SELECT COUNT(*) FROM bronze.crm_sales_details WHERE sls_sales = 0';

        -- Cross-field business rule (only where all 3 are valid/non-null)
        EXEC bronze.usp_run_dq_check
            'bronze.crm_sales_details', 'Sales != Quantity * Price', 'Business Rule',
            'SELECT COUNT(*) FROM bronze.crm_sales_details 
                WHERE sls_sales IS NOT NULL AND sls_quantity IS NOT NULL AND sls_price IS NOT NULL
                AND sls_sales != sls_quantity * sls_price';

    END TRY
    BEGIN CATCH
        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status, error_message)
        VALUES ('bronze.crm_sales_details', @start_time, GETDATE(), NULL, NULL, 'FAILED', ERROR_MESSAGE());
        PRINT 'ERROR loading crm_sales_details: ' + ERROR_MESSAGE();
    END CATCH


    /* ============================================================
       4. bronze.erp_loc_a101
    ============================================================ */
    BEGIN TRY
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.erp_loc_a101';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\LOC_A101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        SET @end_time = GETDATE();
        SELECT @row_count = COUNT(*) FROM bronze.erp_loc_a101;

        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status)
        VALUES ('bronze.erp_loc_a101', @start_time, @end_time,
                DATEDIFF(SECOND, @start_time, @end_time), @row_count, 'SUCCESS');

        PRINT '>> Rows Loaded: ' + CAST(@row_count AS NVARCHAR);
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';
        PRINT '>> Running DQ Checks...';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_loc_a101', 'Row Count > 0', 'Completeness',
            'SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE 0 END FROM bronze.erp_loc_a101';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_loc_a101', 'NULL cid', 'Completeness',
            'SELECT COUNT(*) FROM bronze.erp_loc_a101 WHERE cid IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_loc_a101', 'Duplicate cid', 'Uniqueness',
            'SELECT COUNT(*) FROM (SELECT cid FROM bronze.erp_loc_a101 WHERE cid IS NOT NULL GROUP BY cid HAVING COUNT(*) > 1) t';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_loc_a101', 'NULL/Blank cntry', 'Completeness',
            'SELECT COUNT(*) FROM bronze.erp_loc_a101 WHERE cntry IS NULL OR TRIM(cntry) = ''''';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_loc_a101', 'Orphan cid (FK Integrity vs crm_cust_info)', 'Referential Integrity',
            'SELECT COUNT(*) FROM bronze.erp_loc_a101 l
                LEFT JOIN bronze.crm_cust_info c ON REPLACE(l.cid, ''-'', '''') = c.cst_key
                WHERE c.cst_key IS NULL';

    END TRY
    BEGIN CATCH
        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status, error_message)
        VALUES ('bronze.erp_loc_a101', @start_time, GETDATE(), NULL, NULL, 'FAILED', ERROR_MESSAGE());
        PRINT ' ERROR loading erp_loc_a101: ' + ERROR_MESSAGE();
    END CATCH


    /* ============================================================
       5. bronze.erp_cust_az12
    ============================================================ */
    BEGIN TRY
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.erp_cust_az12';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\CUST_AZ12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        SET @end_time = GETDATE();
        SELECT @row_count = COUNT(*) FROM bronze.erp_cust_az12;

        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status)
        VALUES ('bronze.erp_cust_az12', @start_time, @end_time,
                DATEDIFF(SECOND, @start_time, @end_time), @row_count, 'SUCCESS');

        PRINT '>> Rows Loaded: ' + CAST(@row_count AS NVARCHAR);
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';
        PRINT '>> Running DQ Checks...';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_cust_az12', 'Row Count > 0', 'Completeness',
            'SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE 0 END FROM bronze.erp_cust_az12';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_cust_az12', 'NULL cid', 'Completeness',
            'SELECT COUNT(*) FROM bronze.erp_cust_az12 WHERE cid IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_cust_az12', 'NULL bdate', 'Completeness',
            'SELECT COUNT(*) FROM bronze.erp_cust_az12 WHERE bdate IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_cust_az12', 'Future Birthdates', 'Validity',
            'SELECT COUNT(*) FROM bronze.erp_cust_az12 WHERE bdate > GETDATE()';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_cust_az12', 'Unrealistic Birthdates (< 1900)', 'Validity',
            'SELECT COUNT(*) FROM bronze.erp_cust_az12 WHERE bdate < ''1900-01-01''';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_cust_az12', 'Invalid gen Values', 'Validity',
            'SELECT COUNT(*) FROM bronze.erp_cust_az12 WHERE gen IS NOT NULL AND UPPER(TRIM(gen)) NOT IN (''M'',''F'',''MALE'',''FEMALE'')';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_cust_az12', 'Orphan cid (FK Integrity vs crm_cust_info)', 'Referential Integrity',
            'SELECT COUNT(*) FROM bronze.erp_cust_az12 e
                LEFT JOIN bronze.crm_cust_info c ON 
                    CASE WHEN e.cid LIKE ''NAS%'' THEN SUBSTRING(e.cid, 4, LEN(e.cid)) ELSE e.cid END = c.cst_key
                WHERE c.cst_key IS NULL';

    END TRY
    BEGIN CATCH
        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status, error_message)
        VALUES ('bronze.erp_cust_az12', @start_time, GETDATE(), NULL, NULL, 'FAILED', ERROR_MESSAGE());
        PRINT '✖ ERROR loading erp_cust_az12: ' + ERROR_MESSAGE();
    END CATCH


    /* ============================================================
       6. bronze.erp_px_cat_g1v2
    ============================================================ */
    BEGIN TRY
        PRINT '------------------------------------------------';
        PRINT 'Loading Table: bronze.erp_px_cat_g1v2';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\anna_tereshchuk\Downloads\dwh_source_file\source_erp\PX_CAT_G1V2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

        SET @end_time = GETDATE();
        SELECT @row_count = COUNT(*) FROM bronze.erp_px_cat_g1v2;

        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status)
        VALUES ('bronze.erp_px_cat_g1v2', @start_time, @end_time,
                DATEDIFF(SECOND, @start_time, @end_time), @row_count, 'SUCCESS');

        PRINT '>> Rows Loaded: ' + CAST(@row_count AS NVARCHAR);
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';
        PRINT '>> Running DQ Checks...';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_px_cat_g1v2', 'Row Count > 0', 'Completeness',
            'SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE 0 END FROM bronze.erp_px_cat_g1v2';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_px_cat_g1v2', 'NULL id', 'Completeness',
            'SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2 WHERE id IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_px_cat_g1v2', 'Duplicate id', 'Uniqueness',
            'SELECT COUNT(*) FROM (SELECT id FROM bronze.erp_px_cat_g1v2 WHERE id IS NOT NULL GROUP BY id HAVING COUNT(*) > 1) t';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_px_cat_g1v2', 'NULL cat/subcat', 'Completeness',
            'SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2 WHERE cat IS NULL OR subcat IS NULL';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_px_cat_g1v2', 'Unwanted Spaces - cat/subcat/maintenance', 'Validity',
            'SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2 WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)';

        EXEC bronze.usp_run_dq_check
            'bronze.erp_px_cat_g1v2', 'Invalid maintenance Values', 'Validity',
            'SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2 WHERE maintenance IS NOT NULL AND UPPER(TRIM(maintenance)) NOT IN (''YES'',''NO'')';

    END TRY
    BEGIN CATCH
        INSERT INTO bronze.load_log (table_name, load_start, load_end, duration_sec, row_count, status, error_message)
        VALUES ('bronze.erp_px_cat_g1v2', @start_time, GETDATE(), NULL, NULL, 'FAILED', ERROR_MESSAGE());
        PRINT 'ERROR loading erp_px_cat_g1v2: ' + ERROR_MESSAGE();
    END CATCH


    /* ============================================================
       BATCH SUMMARY
    ============================================================ */
    DECLARE @batch_end DATETIME = GETDATE();
    PRINT '================================================';
    PRINT 'BRONZE LAYER LOAD COMPLETE';
    PRINT 'Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start, @batch_end) AS NVARCHAR) + 's';
    PRINT '================================================';

    IF EXISTS (SELECT 1 FROM bronze.dq_log WHERE status = 'FAIL' AND check_date >= @batch_start)
    BEGIN
        PRINT 'DQ ISSUES DETECTED THIS RUN:';
        SELECT table_name, check_name, check_category, issue_count
        FROM bronze.dq_log
        WHERE status = 'FAIL' AND check_date >= @batch_start
        ORDER BY table_name, check_category;
    END
    ELSE
    BEGIN
        PRINT ' ALL DQ CHECKS PASSED';
    END
END
GO
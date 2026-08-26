/* =============================================================
   GENERIC DQ CHECK PROCEDURE
   ============================================================= */

CREATE OR ALTER PROCEDURE bronze.usp_run_dq_check
    @table_name     NVARCHAR(128),
    @check_name     NVARCHAR(200),
    @check_category NVARCHAR(50),
    @sql_check      NVARCHAR(MAX)   -- must return a single INT count of issues
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @issue_count INT;
    DECLARE @status NVARCHAR(20);

    BEGIN TRY
        DECLARE @sql NVARCHAR(MAX) = N'SELECT @cnt = (' + @sql_check + N')';
        EXEC sp_executesql @sql, N'@cnt INT OUTPUT', @cnt = @issue_count OUTPUT;

        SET @status = CASE WHEN @issue_count = 0 THEN 'PASS' ELSE 'FAIL' END;

        INSERT INTO bronze.dq_log (table_name, check_name, check_category, issue_count, status)
        VALUES (@table_name, @check_name, @check_category, @issue_count, @status);

        IF @status = 'FAIL'
            PRINT ' FAIL: ' + @check_name + ' -> ' + CAST(@issue_count AS NVARCHAR) + ' issue(s)';
        ELSE
            PRINT ' PASS: ' + @check_name;

    END TRY
    BEGIN CATCH
        INSERT INTO bronze.dq_log (table_name, check_name, check_category, issue_count, status)
        VALUES (@table_name, @check_name, @check_category, -1, 'ERROR');
        PRINT ' ERROR running check: ' + @check_name + ' -> ' + ERROR_MESSAGE();
    END CATCH
END
GO
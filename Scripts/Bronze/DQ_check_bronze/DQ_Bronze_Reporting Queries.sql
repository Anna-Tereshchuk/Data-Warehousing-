-- Load performance history
SELECT * FROM bronze.load_log ORDER BY log_date DESC;

-- All DQ results from latest run
SELECT * FROM bronze.dq_log 
WHERE check_date >= (SELECT MAX(load_start) FROM bronze.load_log)
ORDER BY table_name, check_category;

-- Only failures
SELECT * FROM bronze.dq_log WHERE status = 'FAIL' ORDER BY check_date DESC;

-- Pass rate scorecard per table
SELECT 
    table_name,
    COUNT(*) AS total_checks,
    SUM(CASE WHEN status = 'PASS' THEN 1 ELSE 0 END) AS passed,
    SUM(CASE WHEN status = 'FAIL' THEN 1 ELSE 0 END) AS failed,
    CAST(SUM(CASE WHEN status = 'PASS' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS pass_rate_pct
FROM bronze.dq_log
GROUP BY table_name
ORDER BY pass_rate_pct ASC;

-- Worst offenders (checks with highest issue counts)
SELECT TOP 20 table_name, check_name, check_category, issue_count
FROM bronze.dq_log
WHERE status = 'FAIL'
ORDER BY issue_count DESC;
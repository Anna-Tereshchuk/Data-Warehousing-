/* =============================================================
   BRONZE LAYER — LOGGING INFRASTRUCTURE
   ============================================================= */

IF OBJECT_ID('bronze.load_log', 'U') IS NOT NULL DROP TABLE bronze.load_log;
CREATE TABLE bronze.load_log (
    log_id          INT IDENTITY(1,1) PRIMARY KEY,
    table_name      NVARCHAR(128),
    load_start      DATETIME,
    load_end        DATETIME,
    duration_sec    INT,
    row_count       INT,
    status          NVARCHAR(20),      -- SUCCESS / FAILED
    error_message   NVARCHAR(MAX) NULL,
    log_date        DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('bronze.dq_log', 'U') IS NOT NULL DROP TABLE bronze.dq_log;
CREATE TABLE bronze.dq_log (
    dq_id           INT IDENTITY(1,1) PRIMARY KEY,
    table_name      NVARCHAR(128),
    check_name      NVARCHAR(200),
    check_category  NVARCHAR(50),      -- Completeness / Uniqueness / Validity / Consistency / Business Rule / Referential Integrity
    issue_count     INT,
    status          NVARCHAR(20),      -- PASS / FAIL / ERROR
    check_date      DATETIME DEFAULT GETDATE()
);
GO
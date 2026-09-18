SET NOCOUNT ON;

------------------------------------------------------------
-- CLEANUP
------------------------------------------------------------

DROP INDEX IF EXISTS IX_DailyStatus_Queue ON dbo.DailyStatus;
DROP INDEX IF EXISTS IX_DailyStatus_Account ON dbo.DailyStatus;
DROP INDEX IF EXISTS IX_DailyStatus_Queue_Account ON dbo.DailyStatus;


------------------------------------------------------------
-- BASELINE - NO INDEX
------------------------------------------------------------

PRINT '========== BASELINE - NO INDEX ==========';

DECLARE @start DATETIME2, @end DATETIME2;

-- Warm-up
SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id
    FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

-- Run 1
SET @start = SYSDATETIME();

SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id
    FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 1: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


-- Run 2
SET @start = SYSDATETIME();

SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id
    FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 2: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


-- Run 3
SET @start = SYSDATETIME();

SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id
    FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 3: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


-- Run 4
SET @start = SYSDATETIME();

SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id
    FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 4: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


-- Run 5
SET @start = SYSDATETIME();

SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id
    FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 5: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


------------------------------------------------------------
-- ACCOUNT INDEX
------------------------------------------------------------

PRINT '========== ACCOUNT INDEX ==========';

CREATE INDEX IX_DailyStatus_Account
ON dbo.DailyStatus (account_id)
INCLUDE (changed_datetime, queue, status);

-- Warm-up
SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id
    FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

-- 5 runs
SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 1: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 2: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 3: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 4: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 5: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';

DROP INDEX IX_DailyStatus_Account ON dbo.DailyStatus;


------------------------------------------------------------
-- QUEUE INDEX
------------------------------------------------------------

PRINT '========== QUEUE INDEX ==========';

CREATE INDEX IX_DailyStatus_Queue
ON dbo.DailyStatus (queue)
INCLUDE (account_id, changed_datetime, status);

-- Warm-up
SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

-- 5 runs
SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 1: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 2: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 3: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 4: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 5: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';

DROP INDEX IX_DailyStatus_Queue ON dbo.DailyStatus;


------------------------------------------------------------
-- QUEUE + ACCOUNT INDEX
------------------------------------------------------------

PRINT '========== QUEUE + ACCOUNT INDEX ==========';

CREATE INDEX IX_DailyStatus_Queue_Account
ON dbo.DailyStatus (queue, account_id)
INCLUDE (changed_datetime, status);

-- Warm-up
SELECT
    d.account_id, a.name, a.address,
    d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

-- 5 runs
SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 1: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 2: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 3: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 4: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';


SET @start = SYSDATETIME();

SELECT d.account_id, a.name, a.address,
       d.changed_datetime, d.queue, d.status
FROM dbo.DailyStatus d
JOIN dbo.Accounts a ON a.account_id = d.account_id
WHERE d.account_id IN (
    SELECT DISTINCT account_id FROM dbo.DailyStatus
    WHERE queue IN ('COLLECTIONS', 'LEGAL')
);

SET @end = SYSDATETIME();
PRINT 'Run 5: ' + CAST(DATEDIFF(MILLISECOND, @start, @end) AS VARCHAR(20)) + ' ms';

DROP INDEX IX_DailyStatus_Queue_Account ON dbo.DailyStatus;


-- =======================================================================
--                            TASK 2
-- =======================================================================

-- accounts that had a queue OR status change on or after 2025-01-01
SELECT DISTINCT account_id
FROM dbo.DailyStatus
WHERE changed_datetime >= '2025-01-01';

-- the most recent update for each of those accounts, without join
WITH LatestStatus AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY account_id
               ORDER BY changed_datetime DESC
           ) AS rn
    FROM dbo.DailyStatus
    WHERE changed_datetime >= '2025-01-01'
)
SELECT
    account_id,
    changed_datetime AS latest_update_datetime,
    queue,
    status
FROM LatestStatus
WHERE rn = 1;



-- =======================================================================
--                            TASK 3
-- =======================================================================

-- add account details
WITH LatestStatus AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY account_id
               ORDER BY changed_datetime DESC
           ) AS rn
    FROM dbo.DailyStatus
    WHERE changed_datetime >= '2025-01-01'
)
SELECT
    d.account_id,
    a.name,
    a.address,
    d.changed_datetime AS latest_update_datetime,
    d.queue,
    d.status
FROM LatestStatus d
JOIN dbo.Accounts a
    ON a.account_id = d.account_id
WHERE d.rn = 1;

-- create storage for the final dataset
DROP TABLE IF EXISTS dbo.AccountActivity;

CREATE TABLE dbo.AccountActivity (
    account_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    address NVARCHAR(500),
    latest_update_datetime DATETIME2 NOT NULL,
    queue NVARCHAR(100),
    status NVARCHAR(100)
);

-- store the final dataset
WITH LatestStatus AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY account_id
               ORDER BY changed_datetime DESC
           ) AS rn
    FROM dbo.DailyStatus
    WHERE changed_datetime >= '2025-01-01'
)
INSERT INTO dbo.AccountActivity (
    account_id,
    name,
    address,
    latest_update_datetime,
    queue,
    status
)
SELECT
    d.account_id,
    a.name,
    a.address,
    d.changed_datetime,
    d.queue,
    d.status
FROM LatestStatus d
JOIN dbo.Accounts a
    ON a.account_id = d.account_id
WHERE d.rn = 1;

-- resulted in a 498 row account activity table


-- =======================================================================
--                            TASK 4
-- =======================================================================

-- how many accounts are in those queues in the November 2025 monthly snapshot
SELECT COUNT(*) AS account_count
FROM dbo.MonthlyStatus
WHERE month = '2025-11-01'
  AND queue IN ('COLLECTIONS', 'LEGAL');

-- check if there is exactly one November snapshot per account
SELECT
    account_id,
    COUNT(*) AS snapshot_count
FROM dbo.MonthlyStatus
WHERE month = '2025-11-01'
GROUP BY account_id
HAVING COUNT(*) > 1;

-- most recent DailyStatus change
WITH QualifyingAccounts AS (
    SELECT account_id
    FROM dbo.MonthlyStatus
    WHERE month = '2025-11-01'
      AND queue IN ('COLLECTIONS', 'LEGAL')
),
LatestChange AS (
    SELECT
        d.*,
        ROW_NUMBER() OVER (
            PARTITION BY d.account_id
            ORDER BY d.changed_datetime DESC
        ) AS rn
    FROM dbo.DailyStatus d
    JOIN QualifyingAccounts q
        ON q.account_id = d.account_id
)
SELECT
    account_id,
    changed_datetime AS latest_update_datetime,
    queue,
    status
FROM LatestChange
WHERE rn = 1
ORDER BY account_id;

-- one account appears in the November snapshot but has no corresponding row in DailyStatus
-- deciding how to handle it
SELECT m.account_id
FROM dbo.MonthlyStatus m
LEFT JOIN dbo.DailyStatus d
    ON d.account_id = m.account_id
WHERE m.month = '2025-11-01'
  AND m.queue IN ('COLLECTIONS', 'LEGAL')
  AND d.account_id IS NULL;

SELECT *
FROM dbo.MonthlyStatus
WHERE account_id = 37924
  AND month = '2025-11-01';

--  the account exists in Accounts
SELECT *
FROM dbo.Accounts
WHERE account_id = 37924;

SELECT
    COUNT(*) AS missing_daily_history
FROM dbo.MonthlyStatus m
LEFT JOIN dbo.DailyStatus d
    ON d.account_id = m.account_id
WHERE m.month = '2025-11-01'
  AND m.queue IN ('COLLECTIONS', 'LEGAL')
  AND d.account_id IS NULL;

-- use the November snapshot state and leave latest_update_datetime as NULL
WITH QualifyingAccounts AS (
    SELECT
        account_id,
        queue,
        status
    FROM dbo.MonthlyStatus
    WHERE month = '2025-11-01'
      AND queue IN ('COLLECTIONS', 'LEGAL')
),
LatestChange AS (
    SELECT
        d.account_id,
        d.changed_datetime,
        d.queue,
        d.status,
        ROW_NUMBER() OVER (
            PARTITION BY d.account_id
            ORDER BY d.changed_datetime DESC
        ) AS rn
    FROM dbo.DailyStatus d
    JOIN QualifyingAccounts q
        ON q.account_id = d.account_id
)
SELECT
    q.account_id,
    a.name,
    a.address,
    d.changed_datetime AS latest_update_datetime,
    q.queue,
    q.status
FROM QualifyingAccounts q
JOIN dbo.Accounts a
    ON a.account_id = q.account_id
LEFT JOIN LatestChange d
    ON d.account_id = q.account_id
   AND d.rn = 1
ORDER BY q.account_id;


-- creaing sorage
DROP TABLE IF EXISTS dbo.LatestLegalCollections;

CREATE TABLE dbo.LatestLegalCollections (
    account_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    address NVARCHAR(500),
    latest_update_datetime DATETIME2 NULL,
    queue NVARCHAR(100),
    status NVARCHAR(100)
);

-- inserting data
WITH QualifyingAccounts AS (
    SELECT
        account_id,
        queue,
        status
    FROM dbo.MonthlyStatus
    WHERE month = '2025-11-01'
      AND queue IN ('COLLECTIONS', 'LEGAL')
),
LatestChange AS (
    SELECT
        d.account_id,
        d.changed_datetime,
        ROW_NUMBER() OVER (
            PARTITION BY d.account_id
            ORDER BY d.changed_datetime DESC
        ) AS rn
    FROM dbo.DailyStatus d
    JOIN QualifyingAccounts q
        ON q.account_id = d.account_id
)
INSERT INTO dbo.LatestLegalCollections (
    account_id,
    name,
    address,
    latest_update_datetime,
    queue,
    status
)
SELECT
    q.account_id,
    a.name,
    a.address,
    d.changed_datetime,
    q.queue,
    q.status
FROM QualifyingAccounts q
JOIN dbo.Accounts a
    ON a.account_id = q.account_id
LEFT JOIN LatestChange d
    ON d.account_id = q.account_id
   AND d.rn = 1;

-- resulted in a 145 row LatestLegalCollections table
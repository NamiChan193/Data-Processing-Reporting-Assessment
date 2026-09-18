
BULK INSERT dbo.Accounts
FROM 'C:\SQLData\accounts_processed.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

--SELECT COUNT(*) AS row_count
--FROM dbo.Accounts;


BULK INSERT dbo.DailyStatus
FROM 'C:\SQLData\daily_status_processed.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

--SELECT COUNT(*) AS row_count
--FROM dbo.DailyStatus;

--SELECT TOP 5 *
--FROM dbo.DailyStatus
--ORDER BY changed_datetime;


BULK INSERT dbo.MonthlyStatus
FROM 'C:\SQLData\monthly_status_processed.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

--SELECT COUNT(*) AS row_count
--FROM dbo.MonthlyStatus;

--SELECT TOP 5 *
--FROM dbo.MonthlyStatus
--ORDER BY month;
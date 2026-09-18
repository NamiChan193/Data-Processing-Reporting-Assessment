USE [CodingChallenge]

DROP TABLE IF EXISTS dbo.DailyStatus;
DROP TABLE IF EXISTS dbo.MonthlyStatus;
DROP TABLE IF EXISTS dbo.Accounts;

CREATE TABLE dbo.Accounts (
    account_id INT PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    address NVARCHAR(500)
);

CREATE TABLE dbo.DailyStatus (
    account_id INT NOT NULL REFERENCES dbo.Accounts(account_id),
    queue NVARCHAR(100),
    status NVARCHAR(100),
    changed_datetime DATETIME2 NOT NULL,
    CHECK (queue IS NULL OR TRIM(queue) <> ''),
    CHECK (status IS NULL OR TRIM(status) <> '')
);

CREATE TABLE dbo.MonthlyStatus (
    account_id INT NOT NULL REFERENCES dbo.Accounts(account_id),
    queue NVARCHAR(100),
    status NVARCHAR(100),
    month DATE NOT NULL,
    CHECK (queue IS NULL OR TRIM(queue) <> ''),
    CHECK (status IS NULL OR TRIM(status) <> '')
);
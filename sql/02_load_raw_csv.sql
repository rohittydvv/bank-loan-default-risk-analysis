-- =====================================================
-- 02: LOAD RAW CSV FILES
-- Purpose: Bulk insert CSV data into staging tables
-- =====================================================

USE BankLoanRisk;
GO

CREATE OR ALTER PROCEDURE stg.load_csv AS
BEGIN

-- Load borrower.csv

TRUNCATE TABLE stg.borrower;  -- Clear existing data

BULK INSERT stg.borrower
FROM 'E:\Loan Project\Borrower.csv'
WITH (
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    TABLOCK
);

-- Load loan.csv

TRUNCATE TABLE stg.loan;  -- Clear existing data

BULK INSERT stg.loan
FROM 'E:\Loan Project\Loan.csv'
WITH (
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    TABLOCK
);

END

EXEC stg.load_csv --TO EXECUTE THE STORED PROCEDURE

-- =====================================================
-- VALIDATION: Check row counts loaded successfully
-- =====================================================
SELECT 'stg.borrower' AS table_name, COUNT(*) AS rows_loaded FROM stg.borrower
UNION ALL
SELECT 'stg.loan' AS table_name, COUNT(*) AS rows_loaded FROM stg.loan;



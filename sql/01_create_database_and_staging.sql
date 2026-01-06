/*
=====================================================
01: CREATE DATABASE & STAGING TABLES
Purpose: Create database and raw staging tables
matching CSV structure exactly
=====================================================
*/

-- Create Database & Use it
CREATE DATABASE BankLoanRisk;
GO
USE BankLoanRisk;
GO

-- Create schemas for organization
CREATE SCHEMA stg;  -- Raw and cleaned data
GO
CREATE SCHEMA dw;       -- Data warehouse (dimensions + facts)
GO

-- Creating: stg.borrower
IF OBJECT_ID('stg.borrower', 'U') IS NOT NULL 
    DROP TABLE stg.borrower;
GO

CREATE TABLE stg.borrower (
    memberId BIGINT,
    residentialState VARCHAR(10),
    yearsEmployment VARCHAR(20),
    homeOwnership VARCHAR(20),
    annualIncome INT,
    incomeVerified TINYINT,
    dtiRatio DECIMAL(5,2),
    lengthCreditHistory INT,
    numTotalCreditLines INT,
    numOpenCreditLines INT,
    numOpenCreditLines1Year INT,
    revolvingBalance INT,
    revolvingUtilizationRate DECIMAL(6,2),
    numDerogatoryRec INT,
    numDelinquency2Years INT,
    numChargeoff1year INT,
    numInquiries6Mon INT
);

-- Creating: stg.loan
IF OBJECT_ID('stg.loan', 'U') IS NOT NULL 
    DROP TABLE stg.loan;
GO

CREATE TABLE stg.loan (
    loanId BIGINT,
    memberId BIGINT,
    loanDate DATE,
    purpose VARCHAR(50),
    isJointApplication TINYINT,
    loanAmount INT,
    term VARCHAR(20),
    interestRate DECIMAL(5,2),
    monthlyPayment INT,
    grade VARCHAR(5),
    loanStatus VARCHAR(30)
);

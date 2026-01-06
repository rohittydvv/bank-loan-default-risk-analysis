
/*=====================================================
03: CREATE CLEAN TABLES
Purpose: Create cleaned borrower & loan tables with
derived columns
=====================================================
*/

-- Drop if exists
IF OBJECT_ID('dw.borrower_clean', 'U') IS NOT NULL DROP TABLE dw.borrower_clean;
IF OBJECT_ID('dw.loan_clean', 'U') IS NOT NULL DROP TABLE dw.loan_clean;

-- -----------------------------------------------------
-- CLEANED BORROWER TABLE (acts as dim_borrower)
-- -----------------------------------------------------
CREATE TABLE dw.borrower_clean (
    member_id BIGINT PRIMARY KEY,
    residential_state VARCHAR(10),
    years_employment VARCHAR(20),
    home_ownership VARCHAR(20),
    annual_income INT,
    income_verified TINYINT,
    dti_ratio DECIMAL(5,2),
    length_credit_history INT,
    num_total_credit_lines INT,
    num_open_credit_lines INT,
    num_open_credit_lines_1_year INT,
    revolving_balance INT,
    revolving_utilization_rate DECIMAL(6,2),
    num_derogatory_rec INT,
    num_delinquency_2_years INT,
    num_chargeoff_1_year INT,
    num_inquiries_6_mon INT,
    income_band VARCHAR(20),
    risk_history_flag TINYINT
);
GO

---------------------------------------------------------
-- Inserting Data Into dw.borrower_clean Table
---------------------------------------------------------
INSERT INTO dw.borrower_clean (
    member_id,
    residential_state,
    years_employment,
    home_ownership,
    annual_income,
    income_verified,
    dti_ratio,
    length_credit_history,
    num_total_credit_lines,
    num_open_credit_lines,
    num_open_credit_lines_1_year,
    revolving_balance,
    revolving_utilization_rate,
    num_derogatory_rec,
    num_delinquency_2_years,
    num_chargeoff_1_year,
    num_inquiries_6_mon,
    income_band,
    risk_history_flag
                    )
SELECT
    DISTINCT(memberId),
    ISNULL(NULLIF(TRIM(residentialState), ''), 'Unknown') AS residential_state,
    ISNULL(NULLIF(TRIM(yearsEmployment), ''), 'Unknown') AS years_employment,
    ISNULL(NULLIF(TRIM(homeOwnership), ''), 'Unknown') AS home_ownership,
    annualIncome AS annual_income,
    ISNULL(incomeVerified, 0) AS income_verified,
    CASE 
        WHEN dtiRatio BETWEEN 0 AND 100 THEN dtiRatio
        ELSE NULL 
    END AS dti_ratio,
    lengthCreditHistory,
    numTotalCreditLines,
    ISNULL(numOpenCreditLines, 0) AS numOpenCreditLines,
    numOpenCreditLines1Year,
    revolvingBalance,
    revolvingUtilizationRate,
    ISNULL(numDerogatoryRec, 0) AS num_derogatory_rec,
    ISNULL(numDelinquency2Years, 0) AS num_delinquency_2_years,
    ISNULL(numChargeoff1year, 0) AS num_chargeoff_1_year,
    ISNULL(numInquiries6Mon, 0) AS num_inquiries_6_mon,
    CASE 
        WHEN annualIncome < 50000 THEN 'Low'
        WHEN annualIncome < 55000 THEN 'Medium'
        ELSE 'High'
    END AS income_band,
    CASE
        WHEN numDerogatoryRec > 0 OR numDelinquency2Years > 1
        OR numChargeoff1year > 0 THEN 1 ELSE 0
        END AS risk_history_flag
FROM stg.borrower
WHERE 
    memberId IS NOT NULL;

-- -----------------------------------------------------
-- CLEANED LOAN TABLE (acts as fact_loan)
-- -----------------------------------------------------
CREATE TABLE dw.loan_clean (
    loan_id BIGINT PRIMARY KEY,
    borrower_id BIGINT NOT NULL,
    origination_date DATE NOT NULL,
    purpose VARCHAR(50),
    is_joint_application TINYINT,
    loan_amount INT,
    term VARCHAR(20),
    interest_rate DECIMAL(5,2),
    monthly_payment INT,
    grade VARCHAR(5),
    loan_status VARCHAR(30),
    default_flag TINYINT,
    interest_rate_band VARCHAR(20)
);
GO

---------------------------------------------------------
-- Inserting Data Into dw.loan_clean Table
---------------------------------------------------------
INSERT INTO dw.loan_clean (
    loan_id,
    borrower_id,
    origination_date,
    purpose,
    is_joint_application,
    loan_amount,
    term,
    interest_rate,
    interest_rate_band,
    monthly_payment,
    grade,
    loan_status,
    default_flag
                    )
SELECT
    loanId,
    memberId AS borrower_id,
    loanDate AS origination_date,
    ISNULL(NULLIF(TRIM(purpose), ''), 'Unknown') AS purpose,
    ISNULL(isJointApplication, 0) AS is_joint_application,
    loanAmount,
    LEFT(term,2) AS term_months,
    interestRate,
    CASE 
        WHEN interestRate < 8 THEN 'Low (<8%)'
        WHEN interestRate < 12 THEN 'Medium (8-12%)'
        ELSE 'High (>=12%)'
    END AS interest_rate_band,
    monthlyPayment,
    grade,
    TRIM(loanStatus) AS loan_status,
    CASE
        WHEN loanStatus = 'Default' THEN 1 ELSE 0
    END AS default_flag
FROM stg.loan
WHERE 
    loanId IS NOT NULL
    AND loanAmount IS NOT NULL
    AND term IS NOT NULL
    AND memberId IS NOT NULL;
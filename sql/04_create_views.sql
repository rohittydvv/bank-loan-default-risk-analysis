-- =====================================================
-- 04: ANALYTICAL VIEWS (directly on borrower_clean + loan_clean)
-- Purpose: Provide ready-made datasets for Tableau & analysis
-- =====================================================

USE BankLoanRisk;
GO

-- --------------------------------------------
-- View 1: Loan-level performance detail
-- --------------------------------------------
CREATE OR ALTER VIEW dw.vw_loan_performance_detail AS
SELECT
    l.loan_id,
    l.borrower_id,
    l.origination_date,
    YEAR(l.origination_date) AS origination_year,
    DATEPART(QUARTER, l.origination_date) AS origination_quarter,
    
    -- Loan fields
    l.loan_amount,
    l.term,
    l.interest_rate,
    l.interest_rate_band,
    l.monthly_payment,
    l.grade,
    l.purpose,
    l.is_joint_application,
    l.loan_status,
    l.default_flag,
    
    -- Borrower fields
    b.residential_state,
    b.years_employment,
    b.home_ownership,
    b.annual_income,
    b.income_band,
    b.dti_ratio,
    b.length_credit_history,
    b.num_total_credit_lines,
    b.num_open_credit_lines,
    b.num_open_credit_lines_1_year,
    b.revolving_balance,
    b.revolving_utilization_rate,
    b.num_derogatory_rec,
    b.num_delinquency_2_years,
    b.num_chargeoff_1_year,
    b.num_inquiries_6_mon,
    b.risk_history_flag
FROM dw.loan_clean l
JOIN dw.borrower_clean b
    ON l.borrower_id = b.member_id;
GO

-- --------------------------------------------
-- View 2: Default rate by risk segment
-- --------------------------------------------
CREATE OR ALTER VIEW dw.vw_default_rate_by_segment AS
SELECT
    grade,
    purpose,
    income_band,
    residential_state,
  
    COUNT(*) AS total_loans,
    SUM(default_flag) AS default_loans,
    CAST(AVG(CAST(default_flag AS DECIMAL(5,4))) * 100 AS DECIMAL(5,2)) AS default_rate_pct,
    
    SUM(loan_amount) AS total_exposure,
    SUM(CASE WHEN default_flag = 1 THEN loan_amount ELSE 0 END) AS defaulted_exposure
FROM dw.vw_loan_performance_detail
GROUP BY
    grade, purpose, income_band, residential_state;
GO

-- --------------------------------------------
-- View 3: Default rate by interest band & tenure
-- --------------------------------------------
CREATE OR ALTER VIEW dw.vw_default_rate_by_pricing AS
SELECT
    interest_rate_band,
    term,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS default_loans,
    CAST(AVG(CAST(default_flag AS DECIMAL(5,4))) * 100 AS DECIMAL(5,2)) AS default_rate_pct,
    AVG(interest_rate) AS avg_interest_rate,
    AVG(loan_amount) AS avg_loan_amount
FROM dw.vw_loan_performance_detail
GROUP BY interest_rate_band, term;
GO

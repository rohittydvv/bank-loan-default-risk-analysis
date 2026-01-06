-- =====================================================
-- 05: CORE BUSINESS INSIGHTS QUERIES
-- Purpose: Use borrower_clean + loan_clean (via views) for storytelling
-- =====================================================

USE BankLoanRisk;
GO

-- --------------------------------------------
-- QUERY 1: Portfolio-level KPIs
-- --------------------------------------------
-- What: Overall health of the loan book
SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_exposure,
    CAST(AVG(CAST(default_flag AS DECIMAL(5,4))) * 100 AS DECIMAL(5,2)) AS portfolio_default_rate_pct,
    AVG(interest_rate) AS avg_interest_rate,
    AVG(loan_amount) AS avg_loan_amount
FROM dw.loan_clean;

-- --------------------------------------------
-- QUERY 2: Top 10 high-risk segments (grade + income_band + purpose)
-- --------------------------------------------
SELECT TOP 10
    grade,
    income_band,
    purpose,
    COUNT(*) AS loans,
    SUM(default_flag) AS defaults,
    CAST(AVG(CAST(default_flag AS DECIMAL(5,4))) * 100 AS DECIMAL(5,2)) AS default_rate_pct,
    SUM(loan_amount) AS exposure
FROM dw.vw_loan_performance_detail
GROUP BY grade, income_band, purpose
HAVING COUNT(*) >= 50
ORDER BY default_rate_pct DESC;

-- --------------------------------------------
-- QUERY 3: Vintage analysis (by origination year & quarter)
-- --------------------------------------------
SELECT
    origination_year,
    origination_quarter,
    COUNT(*) AS loans_issued,
    SUM(default_flag) AS defaults,
    CAST(AVG(CAST(default_flag AS DECIMAL(5,4))) * 100 AS DECIMAL(5,2)) AS default_rate_pct,
    SUM(loan_amount) AS exposure
FROM dw.vw_loan_performance_detail
GROUP BY origination_year, origination_quarter
ORDER BY origination_year, origination_quarter;

-- --------------------------------------------
-- QUERY 4: Credit behaviour vs default (risk_history_flag)
-- --------------------------------------------
SELECT
    risk_history_flag,
    CASE risk_history_flag WHEN 1 THEN 'Risky credit history' ELSE 'Clean credit history' END AS profile,
    COUNT(*) AS loans,
    SUM(default_flag) AS defaults,
    CAST(AVG(CAST(default_flag AS DECIMAL(5,4))) * 100 AS DECIMAL(5,2)) AS default_rate_pct,
    AVG(dti_ratio) AS avg_dti_ratio,
    AVG(loan_amount) AS avg_loan_amount
FROM dw.vw_loan_performance_detail
GROUP BY risk_history_flag;

-- --------------------------------------------
-- QUERY 5: Income band vs default (for business narrative)
-- --------------------------------------------
SELECT
    income_band,
    COUNT(*) AS loans,
    SUM(default_flag) AS defaults,
    CAST(AVG(CAST(default_flag AS DECIMAL(5,4))) * 100 AS DECIMAL(5,2)) AS default_rate_pct,
    AVG(CAST(annual_income AS DECIMAL(15,2))) AS avg_income,
    AVG(CAST(loan_amount AS DECIMAL(15,2))) AS avg_loan_amount
FROM dw.vw_loan_performance_detail
GROUP BY income_band
ORDER BY default_rate_pct DESC;

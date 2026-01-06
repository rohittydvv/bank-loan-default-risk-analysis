# Bank Loan Default Risk Analysis  
**SQL Server · Python · Credit Risk Analytics**

---

## 📌 Project Overview
This project analyzes a bank’s loan portfolio to **identify default risk drivers, high-risk borrower segments and exposure concentration**.  
The goal was to move beyond raw default rates and provide **decision-ready insights** that credit, risk and pricing teams can actually use.

The analysis combines:
- **SQL Server** for data modeling, feature engineering and risk aggregation  
- **Python** for exploratory analysis, statistical insight and visualization  

The result is a structured, end-to-end credit risk analysis similar to what is used in real lending and risk teams.

---

## 🏦 Business Problem
Loan defaults directly impact profitability and capital allocation.  
However, risk is often **unevenly distributed** across:
- borrower income levels  
- credit history quality  
- loan pricing and tenure  
- loan purpose and grade  

The key business questions were:
- Where are defaults concentrated within the portfolio?
- Which borrower and loan attributes drive higher default rates?
- Are interest rates and pricing aligned with observed risk?
- Which segments represent the highest **exposure at risk**?

---

## 🎯 Objective
To build a **transparent and scalable credit risk analytics layer** that:
- surfaces high-risk segments  
- quantifies default rates and exposure  
- supports portfolio monitoring and pricing decisions  
- feeds BI dashboards and further analysis  

---

## 🧱 Data Architecture & SQL Design
SQL Server acts as the **single source of truth** for all transformations and metrics.

### Core Clean Tables
- `dw.loan_clean` – loan-level facts and outcomes  
- `dw.borrower_clean` – borrower demographics and credit behavior  

### Analytical Views
Reusable analytical views were created to standardize risk analysis.

#### 1️⃣ `dw.vw_loan_performance_detail`
Loan-level analytical dataset combining:
- loan attributes: amount, term, interest rate, grade, purpose, status  
- borrower attributes: income, DTI, credit history, utilization  
- derived features: interest rate band, income band, risk history flag  

This view acts as the **foundation for Python analysis and Tableau dashboards**.

#### 2️⃣ `dw.vw_default_rate_by_segment`
Aggregated default metrics by:
- grade  
- purpose  
- income band  
- residential state  

Includes:
- total loans  
- default rate (%)  
- total exposure  
- defaulted exposure  

Used to identify **high-risk and high-exposure segments**.

#### 3️⃣ `dw.vw_default_rate_by_pricing`
Analyzes default behavior across:
- interest rate bands  
- loan tenure  

Helps evaluate whether **pricing reflects underlying risk**.

---

## 📊 Key SQL Business Insights
Core SQL queries were written to answer portfolio-level questions:

- **Portfolio health KPIs**  
  Total loans, total exposure, average interest rate, portfolio default rate  

- **Top high-risk segments**  
  Identified grade–income–purpose combinations with elevated default rates and meaningful volume  

- **Vintage analysis**  
  Default behavior by origination year and quarter to detect deterioration over time  

- **Credit behavior impact**  
  Compared borrowers with risky vs clean credit history using `risk_history_flag`  

- **Income band analysis**  
  Showed how default risk varies across income levels, supporting underwriting thresholds  

---

## 🐍 Python Analysis (EDA & Risk Drivers)
Python was used for **exploratory analysis and insight generation**, not data cleaning.

The main dataset was loaded from:
- `dw.vw_loan_performance_detail`

### Key Analyses Performed
- **Portfolio overview**
  - ~98k loans analyzed  
  - Portfolio default rate ≈ **10%**  
  - Loan vintages from 2014–2016  

- **Exploratory Data Analysis**
  - Loan amount, interest rate, DTI, income, utilization distributions  
  - Clear separation between defaulted and non-defaulted loans  

- **Default rate by segment**
  - Loan grade  
  - Income band  
  - Loan purpose  

- **Pricing vs risk**
  - High interest rate band (≥12%) showed materially higher default rates  
  - Low-rate loans had significantly lower risk, validating pricing discipline  

- **Correlation analysis**
  Strongest correlations with default:
  - Debt-to-Income (DTI)  
  - Revolving credit utilization  
  - Recent credit inquiries  

These findings align with real-world credit risk theory.

---

## 📈 Key Insights & Impact
### 🔍 What the analysis revealed
- Default risk rises sharply with **higher DTI and utilization**  
- Certain loan grades and purposes consistently underperform  
- High-interest loans carry both **higher default rates and large exposure**  
- Borrowers with adverse credit history materially worsen portfolio risk  

### 💡 Business impact
- Enables **early identification of high-risk segments**  
- Supports **pricing and underwriting policy refinement**  
- Improves **portfolio monitoring and exposure management**  
- Provides a clean analytical layer for **Tableau dashboards**  

---

## 🧰 Tools & Technologies
- **SQL Server Express** – data modeling & analytics  
- **Python** – pandas, numpy, matplotlib, seaborn, plotly  

---

## 📂 Repository Structure
```
bank-loan-default-risk-analysis/
├── sql/
│ ├── 01_create_database_and_staging.sql
│ ├── 02_load_raw_csv.sql
│ ├── 03_clean_data.sql
│ ├── 04_create_views.sql
│ ├── 05_insights_queries.sql
│
├── python/
│ ├── 
│ ├── eda_&_analysis.ipynb
│ ├── eda_&_analysis.pdf        #Python notebook converted into PDF
│
└─ README.md
```

---

## 👤 Author

**Rohit Yadav**  
📧 rohit.ydvv23@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/rohittydvv/)

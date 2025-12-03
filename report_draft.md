# HR Employee Attrition Analysis Report
**Course:** 7COM1079 - Statistical Programming  
**Date:** December 3, 2025  
**Authors:** Ali Iqbal, Ahmed Yar, Nouman Akbar, Ataullah, Muhammad Asim

---

## 1. Introduction

This report presents a statistical analysis of the IBM HR Employee Attrition dataset to investigate factors related to employee turnover. The dataset contains 1,470 employee records with 35 variables including demographics, job characteristics, and attrition status.

## 2. Research Question

**Is there a significant difference in monthly income between employees who left the company and those who stayed?**

## 3. Hypotheses

- **H₀ (Null Hypothesis):** There is no significant difference in mean monthly income between employees who left and those who stayed (μ₁ = μ₂)
- **H₁ (Alternative Hypothesis):** There is a significant difference in mean monthly income between the two groups (μ₁ ≠ μ₂)
- **Significance Level:** α = 0.05

## 4. Methodology

### 4.1 Data Preparation
- Dataset: IBM HR Employee Attrition (1,470 records)
- Variables analyzed: Attrition (Yes/No), MonthlyIncome
- No missing values detected

### 4.2 Descriptive Statistics
- Employees who stayed (No): n = 1,233
- Employees who left (Yes): n = 237

[TODO: Add mean, median, SD for both groups]

### 4.3 Statistical Testing

**Normality Testing:**
- Shapiro-Wilk test performed on both groups
- Result: Non-normal distribution detected (p < 0.05)
- Decision: Use non-parametric Mann-Whitney U test

**Mann-Whitney U Test:**
- Non-parametric alternative to independent t-test
- Tests if two groups come from same distribution

## 5. Results

[TODO: Add test results, p-value, decision]
[TODO: Add effect size and practical significance]
[TODO: Include visualizations]

## 6. Discussion

[TODO: Interpret findings]
[TODO: Discuss implications]
[TODO: Limitations]

## 7. Conclusion

[TODO: Summary and recommendations]

---

## References
- IBM HR Analytics Employee Attrition Dataset
- Field, A. (2013). Discovering Statistics Using IBM SPSS Statistics

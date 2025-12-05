# HR Employee Attrition Analysis
**Course:** 7COM1079 - Statistical Programming  
**Institution:** University of Hertfordshire  
**Submission Date:** December 5, 2025

## Team Members
- Ali Iqbal (ai24ace@herts.ac.uk)
- Ahmed Yar (ay24abg@herts.ac.uk)
- Nouman Akbar (na24adx@herts.ac.uk)
- Ataullah (au24abh@herts.ac.uk)
- Muhammad Asim (ma24ari@herts.ac.uk)

## Project Overview
Statistical analysis investigating the relationship between monthly income and employee attrition using the IBM HR Employee Attrition dataset (1,470 records).

**Research Question:** Is there a significant difference in monthly income between employees who left the company and those who stayed?

## Key Findings
- **Statistically Significant Difference Found:** p < 0.001
- **Effect Size:** Employees who left earned $2,045 less on average
- **Test Used:** Mann-Whitney U test (non-parametric)
- **Conclusion:** Income is significantly associated with employee attrition

## Project Structure
```
├── README.md                   # Project documentation
├── Analysis.R                  # Main statistical analysis script
├── exploration.R               # Initial data exploration
├── research_questions.md       # Research design documentation
├── report_draft.md             # Full analysis report
├── WA_Fn-UseC_-HR-Employee-Attrition.csv  # Dataset
├── income_histogram.png        # Income distribution visualization
├── income_boxplot.png          # Boxplot comparison
└── .gitignore                  # Git ignore rules
```

## How to Run Analysis
```r
# Set working directory to project folder
setwd("path/to/final_assignment")

# Run main analysis
source("Analysis.R")

# Output: Statistical test results and visualizations
```

## Dependencies
- R (version 4.0 or higher)
- Base R packages (no additional installations required)

## Results Summary
- **Mann-Whitney U Test Statistic (W):** 108,620
- **P-value:** < 2.2e-16
- **Decision:** Reject H₀ at α = 0.05
- **Interpretation:** Strong evidence that income differs between attrition groups

## Documentation
- Full methodology and results in `report_draft.md`
- Research design in `research_questions.md`
- Visualizations: `income_histogram.png`, `income_boxplot.png`

## References
- IBM HR Analytics Employee Attrition Dataset
- Mann-Whitney U Test (Wilcoxon Rank-Sum Test)
- Shapiro-Wilk Normality Test

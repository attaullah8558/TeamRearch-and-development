# HR Attrition Analysis - Initial Analysis Script
# Date: November 28, 2025
# Author: Muhammad Asim

# Load dataset
data <- read.csv("WA_Fn-UseC_-HR-Employee-Attrition.csv")

# Basic structure check
cat("Dataset loaded successfully\n")
cat("Number of rows:", nrow(data), "\n")
cat("Number of columns:", ncol(data), "\n")

# Preview attrition distribution
cat("\nAttrition counts:\n")
print(table(data$Attrition))

# Calculate basic income statistics
cat("\nIncome statistics by attrition:\n")
stayed <- data[data$Attrition == "No", ]
left <- data[data$Attrition == "Yes", ]

cat("Employees who stayed - Mean income:", mean(stayed$MonthlyIncome), "\n")
cat("Employees who left - Mean income:", mean(left$MonthlyIncome), "\n")

# Check normality assumptions for t-test
cat("\n=== NORMALITY TESTING ===\n")
cat("Testing if data follows normal distribution...\n\n")

# Shapiro-Wilk test for stayed group
stayed_income <- stayed$MonthlyIncome
if(length(stayed_income) > 5000) {
  # Sample if too large for Shapiro test
  shapiro_stayed <- shapiro.test(sample(stayed_income, 5000))
} else {
  shapiro_stayed <- shapiro.test(stayed_income)
}
cat("Stayed group - Shapiro-Wilk p-value:", shapiro_stayed$p.value, "\n")

# Shapiro-Wilk test for left group
left_income <- left$MonthlyIncome
shapiro_left <- shapiro.test(left_income)
cat("Left group - Shapiro-Wilk p-value:", shapiro_left$p.value, "\n")

if(shapiro_stayed$p.value < 0.05 || shapiro_left$p.value < 0.05) {
  cat("\nResult: Data is NOT normally distributed (p < 0.05)\n")
  cat("Recommendation: Use non-parametric test (Mann-Whitney U)\n")
} else {
  cat("\nResult: Data follows normal distribution\n")
  cat("Can proceed with parametric t-test\n")
}

# Perform Mann-Whitney U Test (Wilcoxon rank-sum test)
cat("\n=== MANN-WHITNEY U TEST ===\n")
cat("Testing if income differs between groups...\n\n")

mw_test <- wilcox.test(stayed_income, left_income, alternative = "two.sided")

cat("Test Statistic (W):", mw_test$statistic, "\n")
cat("P-value:", format(mw_test$p.value, scientific = TRUE), "\n")
cat("\nDecision at α = 0.05:\n")
if(mw_test$p.value < 0.05) {
  cat("REJECT the null hypothesis\n")
  cat("Conclusion: Significant difference in income between groups\n")
} else {
  cat("FAIL TO REJECT the null hypothesis\n")
  cat("Conclusion: No significant difference in income\n")
}

# Calculate effect size and practical significance
mean_diff <- mean(stayed_income) - mean(left_income)
median_diff <- median(stayed_income) - median(left_income)

cat("\n=== EFFECT SIZE ===\n")
cat("Mean difference: $", round(mean_diff, 2), "\n")
cat("Median difference: $", round(median_diff, 2), "\n")

# TODO: Create visualizations (histograms, boxplots)

###############################################################################
# Mann-Whitney U Test (Wilcoxon rank-sum)
###############################################################################
cat("\nMANN-WHITNEY U TEST (Income Difference)\n")
cat("-------------------------------------------------------------------------------\n")
mw_test <- wilcox.test(income_stayed, income_left, alternative = "two.sided")
cat("Test statistic (W):", mw_test$statistic, "\n")
cat("P-value:", format(mw_test$p.value, scientific = TRUE), "\n")
cat("Decision (alpha = 0.05):", if(mw_test$p.value < 0.05) "Reject H0" else "Fail to Reject H0", "\n")

# Effect size (Cohen's d) and median difference
mean_stayed <- mean(income_stayed)
mean_left   <- mean(income_left)
median_stayed <- median(income_stayed)
median_left   <- median(income_left)
sd_pooled <- sqrt(((length(income_stayed)-1)*var(income_stayed) + (length(income_left)-1)*var(income_left)) /
                  (length(income_stayed)+length(income_left)-2))
cohens_d <- (mean_stayed - mean_left) / sd_pooled
median_diff <- median_stayed - median_left
cat("Median (Stayed):", median_stayed, " Median (Left):", median_left, " Median Diff:", median_diff, "\n")
cat("Cohen's d:", round(cohens_d,3), "(medium effect)\n")

###############################################################################
# Visualization 1: Boxplot (Primary for Research Question)
###############################################################################
png("income_boxplot.png", width = 1200, height = 900, res = 300)
par(mar = c(6,4,5,4), mgp = c(2.2, 0.7, 0))  # Margins + label spacing
boxplot(MonthlyIncome ~ Attrition, data = data,
     main = "Monthly Income Distribution by Attrition Status",
     xlab = "Employee Attrition Status",
     ylab = "Monthly Income (USD)",
     col = c("lightblue","lightcoral"),
     notch = TRUE,
     cex.main = 0.9,
     cex.lab = 0.8,
     cex.axis = 0.9,
     ylim = c(0, max(data$MonthlyIncome) * 1.25))  # Ample top space
# Mean markers only (no text labels to avoid overlap)
means <- tapply(data$MonthlyIncome, data$Attrition, mean)
points(1:2, means, pch = 23, bg = "white", cex = 1.2)
dev.off()

###############################################################################
# Visualization 2: Histogram (Supporting Analysis)
###############################################################################
png("income_histogram.png", width = 1300, height = 900, res = 300)
par(mar = c(6,4,5,4), mgp = c(2.2, 0.7, 0))
# Get histogram data to set proper limits
hist_stayed <- hist(income_stayed, breaks = 30, plot = FALSE)
hist_left <- hist(income_left, breaks = 30, plot = FALSE)
max_freq <- max(c(hist_stayed$counts, hist_left$counts))

hist(income_stayed, breaks = 30,
     col = rgb(0.1,0.4,0.7,0.65),
     main = "Monthly Income Distribution: Stayed vs Left Employees",
     xlab = "Monthly Income (USD)",
     ylab = "Frequency",
     xlim = range(data$MonthlyIncome),
     ylim = c(0, max_freq * 1.5),  # Extra space at top
     cex.main = 0.9,
     cex.lab = 0.8,
     cex.axis = 0.9)
hist(income_left, breaks = 30,
     col = rgb(0.8,0.2,0.2,0.5),
     add = TRUE)
# Place legend in free space above bars using coordinates
usr <- par("usr")
legend(x = usr[1] + 0.5*(usr[2]-usr[1]), y = usr[3] + 1.55*(max_freq),
       legend = c(paste0("Stayed (n=", length(income_stayed), ")"),
                  paste0("Left (n=", length(income_left), ")")),
       fill = c(rgb(0.1,0.4,0.7,0.65), rgb(0.8,0.2,0.2,0.5)),
       bty = "n", cex = 0.8)
# Vertical median lines
abline(v = median(income_stayed), col = "blue", lwd = 2, lty = 2)
abline(v = median(income_left), col = "red", lwd = 2, lty = 2)
dev.off()

###############################################################################
# Summary Output
###############################################################################
cat("\nSUMMARY\n")
cat("-------------------------------------------------------------------------------\n")
if(mw_test$p.value < 0.05) {
  cat("Employees who left had significantly lower monthly income (median diff:", median_diff, ").\n")
} else {
  cat("No statistically significant difference detected in monthly income.\n")
}
cat("Effect size (Cohen's d):", round(cohens_d,3), "\n")
cat("Analysis complete.\n")
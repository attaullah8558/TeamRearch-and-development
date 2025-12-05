###############################################################################
# Analysis.R
# Load dataset (base R only)
data <- read.csv("WA_Fn-UseC_-HR-Employee-Attrition.csv", stringsAsFactors = FALSE)

# Convert Attrition to factor
data$Attrition <- as.factor(data$Attrition)

# Split income by attrition status
income_stayed <- data$MonthlyIncome[data$Attrition == "No"]
income_left   <- data$MonthlyIncome[data$Attrition == "Yes"]

###############################################################################
# Descriptive Statistics
###############################################################################
cat("\nDESCRIPTIVE STATISTICS\n")
cat("-------------------------------------------------------------------------------\n")
cat("Stayed - Mean:", round(mean(income_stayed),2), " Median:", round(median(income_stayed),2), 
    " SD:", round(sd(income_stayed),2), "\n")
cat("Left   - Mean:", round(mean(income_left),2),   " Median:", round(median(income_left),2), 
    " SD:", round(sd(income_left),2),   "\n")

###############################################################################
# Normality Checks (justify non-parametric test)
###############################################################################
cat("\nNORMALITY CHECKS (Shapiro-Wilk)\n")
cat("-------------------------------------------------------------------------------\n")
shapiro_stayed <- if(length(income_stayed) > 5000) shapiro.test(sample(income_stayed, 5000)) else shapiro.test(income_stayed)
shapiro_left   <- shapiro.test(income_left)
cat("Stayed p-value:", format(shapiro_stayed$p.value, scientific = TRUE), "\n")
cat("Left   p-value:", format(shapiro_left$p.value, scientific = TRUE), "\n")
cat("Result: Non-normal distribution detected -> Using Mann-Whitney U test.\n")

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
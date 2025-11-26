# HR Attrition Dataset - Initial Exploration
# Date: November 27, 2025
# Author: Nouman Akbar

# Load dataset
data <- read.csv("WA_Fn-UseC_-HR-Employee-Attrition.csv")

# Basic exploration
cat("Dataset dimensions:", dim(data), "\n")
cat("Column names:\n")
print(names(data))

# Check for missing values
cat("\nMissing values:\n")
print(colSums(is.na(data)))

# Basic summary statistics
cat("\nAttrition counts:\n")
print(table(data$Attrition))

# TODO: Add more detailed analysis
# TODO: Create visualizations

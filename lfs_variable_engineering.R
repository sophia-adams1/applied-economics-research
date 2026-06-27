# ==============================================================================
# Conditional Feature Engineering via case_when
# Scenario: Categorising a theoretical UK Labour Force Survey (LFS) micro-data sample
# ==============================================================================

install.packages("janitor")
library(dplyr)
library(janitor)

# 1. SETUP SIMULATED LFS MICRO-DATA
# We will deliberately inject NA values to demonstrate institutional non-response data,
# which is common when handling official UK labour statistics.

lfs_sample <- data.frame(
  individual_id = 1001:1008,
  hourly_wage   = c(11.44, 45.20, NA, 18.50, 9.50, 28.00, NA, 11.44), 
  weekly_hours  = c(37.5, 40.0, 20.0, 15.0, 12.0, 35.0, 37.5, 16.0),
  union_member  = c(TRUE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE)
)

print(lfs_sample)


# 2. VARIABLE ENGINEERING WITH case_when() INSIDE mutate()

# We use relational operators (<, >=, ==), logicals (&, |), and helpers (is.na) to build a new robust 'labour_market_status' column.

lfs_classified <- lfs_sample %>%
  mutate(
    labour_market_status = case_when(
      # Condition 1: Handle missing values first:
      is.na(hourly_wage) ~ "Non-response",
      
      # Condition 2: Relational operators showing illegal sub-minimum wage brackets:
      hourly_wage < 11.44 ~ "Below minimum wage",
      
      # Condition 3: Logical AND (&) combining wage and part-time hours (< 30)
      hourly_wage >= 11.44 & hourly_wage < 20.00 & weekly_hours < 30.0 ~ "Low-mid wage part-time",
      
      # Condition 4: Logical AND (&) combining wage and full-time hours (>= 30)
      hourly_wage >= 11.44 & hourly_wage < 20.00 & weekly_hours >= 30.0 ~ "Low-mid wage full-time",
      
      # Condition 5: Capturing high earners:
      hourly_wage >= 20.00 ~ "High wage professional",
      
      # Condition 6: use TRUE to make a safety net for everybody else left over:
      TRUE ~ "Unclassified residual"
    )
  )


# 3. VERIFICATION & SPREADSHEET VIEW
View(lfs_classified)


# 4. STATISTICS: PROPORTIONS VIA janitor::tabyl()

# You must ensure your engineered categories make demographic sense.
# tabyl() generates a clean frequency table with absolute counts and percentage shares.
lfs_classified %>%
  tabyl(labour_market_status) %>%
  adorn_pct_formatting(digits = 1) %>% # Converts decimals to crisp percentages (e.g., 25.0%)
  adorn_totals("row")                  # Adds a summary row at the bottom confirming a 100% split
# ==============================================================================
# Structural Reshaping & Data Tidying via tidyr
# pivot_longer and pivot_wider
# ==============================================================================

install.packages("tidyr")
library(tidyr)
library(dplyr)

# 1. SETUP SIMULATED MESSY ONS WIDE PANEL (BACKTICK TRAP)
# Use of backticks - to ensure correct naming of columns during data cleaning.

ons_wide <- data.frame(
  region_id   = c("UKC", "UKG", "UKI"),
  region_name = c("North East", "West Midlands", "London"),
  `2024_rate` = c(72.1, 74.3, NA),     # Includes an NA to demonstrate drop patterns
  `2025_rate` = c(72.8, 75.0, 78.2),
  `2026_rate` = c(73.5, 74.8, 79.1),
  check.names = FALSE                  
)
print(ons_wide)

# 2. PIVOT LONGER: COLUMN SELECTION PATTERNS
# Depending on how many columns are in a survey, we use different selections.

# Pattern A: Range Selection (column x : column y)
# Perfect when you have a block of contiguous time-series columns.
long_range <- ons_wide %>% 
  pivot_longer(
    cols     = `2024_rate`:`2026_rate`, 
    names_to = "raw_variable", 
    values_to = "employment_rate"
  )
head(long_range)

# Pattern B: Explicit Vector Selection (c(colx, coly, colz)) which is best practice when target columns are scattered or specific. Should look the same as Pattern A.
long_vector <- ons_wide %>% 
  pivot_longer(
    cols      = c(`2024_rate`, `2025_rate`, `2026_rate`), 
    names_to  = "raw_variable", 
    values_to = "employment_rate"
  )
head(long_vector)

# Pattern C: Exclusion Selection (-variable1, -variable2): "pivot everything EXCEPT my structural identifier variables".
long_exclusion <- ons_wide %>% 
  pivot_longer(
    cols      = c(-region_id, -region_name), 
    names_to  = "raw_variable", 
    values_to = "employment_rate"
  )
head(long_exclusion)

# 3. ADVANCED CLEANING: STRING SPLITTING / TYPE TRANSFORMS / DROPPING NAs

# Here, we use advanced arguments to split "2024_rate" and purge missing data.
panel_long_clean <- ons_wide %>% 
  pivot_longer(
    cols            = c(-region_id, -region_name),
    names_to        = c("year", "metric"),     # Splits the column name into two distinct variables
    names_sep       = "_",                     # Identifies the character split
    names_transform = list(year = as.integer), # Converts text "2024" directly into an integer vector
    values_to       = "metric_value",
    values_drop_na  = TRUE                     # Automatically purges the incomplete London 2024 row
  )

print(panel_long_clean)


# 4. PIVOT WIDER: RECONSTRUCTING ARRAYS FOR ESTIMATION

# While long data is required for ggplot2, certain legacy econometric estimators, spatial weight matrices, or balanced table views require data to be wide.
panel_wide_reconstructed <- panel_long_clean %>% 
  pivot_wider(
    names_from  = year,            # Takes the integer years and turns them back into headers
    values_from = metric_value   # Spreads the numeric observations across those headers
  )

print(panel_wide_reconstructed)
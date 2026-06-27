# ==============================================================================
# Vectorised Column Automation via dplyr::across()
# Streamlining cleaning and summary statistics for a simulated UK Regional Registry
# ==============================================================================

library(dplyr)
library(tidyr)

# 1. SETUP SIMULTATED RAW REGIONAL DATASET
# We have a mix of character IDs, raw percentages that need decimal conversion, and currency columns that need a uniform 5% inflation adjustment.
regional_raw <- data.frame(
  region_id          = c("UKC", "UKG", "UKI", "UKJ"),
  region_name        = c("North East", "West Midlands", "London", "South East"),
  employment_rate_pc = c(72.1, 74.3, 78.2, 79.5),
  activity_rate_pc   = c(76.5, 77.1, 81.0, 82.3),
  wage_median_2025   = c(28500, 31000, 42500, 36000),
  wage_median_2026   = c(29400, 31800, 44000, 37200)
)
print(regional_raw)


# 2. BATCH MUTATION: AUTOMATED TRANSFORMATIONS WITH across()
# Instead of writing separate mutate lines for every column, we use across() to clean grouped column structures simultaneously using two different selectors.
regional_clean <- regional_raw %>%
  mutate(
    # Pattern A: Using where() to convert all character columns to factors.
    across(where(is.character), as.factor),
    # Pattern B: Tidyselect helper ends_with(), convert percentages to true decimals
    across(ends_with("_pc"), ~ .x / 100),
    # Pattern C: Tidyselect helper starts_with(), apply a 5% inflation adjustment and create BRAND NEW columns instead of overwriting, using the '.names' argument.
    across(starts_with("wage"), ~ .x * 1.05, .names = "{.col}_real")
  )
# Characters are now factors, percentages are decimals, and new '_real' wage columns have been dynamically generated.
glimpse(regional_clean)


# 3. MULTI-METRIC SUMMARIES WITH across()
# In policy briefs, you constantly need to output tables showing the mean and median across multiple indicators. across() does this easily.
macro_summary_table <- regional_clean %>%
  summarise(
    across(
      .cols  = c(employment_rate_pc, activity_rate_pc, wage_median_2026),
      .fns   = list(national_avg = mean, national_med = median),
      .names = "{.col}__{.fn}" # REGISTERED A DOUBLE UNDERSCORE HERE
    )
  )
# Now we split explicitly at the double underscore boundary.
macro_summary_final <- macro_summary_table %>%
  pivot_longer(
    cols = everything(),
    names_to = c("economic_indicator", "metric"),
    names_sep = "__"         # MATCHED THE DOUBLE UNDERSCORE HERE
  )
print(macro_summary_final)
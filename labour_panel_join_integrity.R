# ==============================================================================
# Advanced Relational Data Pipelines & Join Integrity (left, semi, anti joins)
# Purpose: Evading Merge Traps, Multi-Key Matching, and Filtering Joins
# Scenario: Micro-data panel of workers matched to time-varying training & firms
# ==============================================================================

library(dplyr)

# ------------------------------------------------------------------------------
# 1. SETUP SIMULATED PANEL DATA
# ------------------------------------------------------------------------------

# Table 1: Base Worker Panel (Tracked over Space & Time)
# 3 workers observed over 2 years = 6 baseline observations
worker_panel <- data.frame(
  worker_id = c(1, 1, 2, 2, 3, 3),
  year      = c(2025, 2026, 2025, 2026, 2025, 2026),
  firm_id   = c(101, 101, 101, 102, 102, 102),
  wage      = c(22.50, 24.50, 19.00, 21.00, 30.00, 32.50)
)
head(worker_panel)

# Table 2: Time-Varying Training Log
# Contains multiple modules completed by workers across different years
training_log <- data.frame(
  worker_id = c(1, 1, 2, 3),
  year      = c(2025, 2026, 2026, 2025),
  course    = c("Excel Metrics", "R Econometrics", "SQL Core", "Management")
)
head(training_log)

# Table 3: Firm Registry (Structural Characteristics)
firm_registry <- data.frame(
  firm_id = c(101, 102),
  region  = c("North East", "London"),
  subsidized = c(TRUE, FALSE)
)
head(firm_registry)

print(paste("Baseline Worker Panel Observations:", nrow(worker_panel))) # Should be 6

# If we only join on 'worker ID', R looks at Worker 1 in 2025, and matches it to BOTH Worker 1 2025/2026 rows in the other dataset. This creates a bunch of rows. 
bad_join <- left_join(worker_panel, training_log, by = "worker_id")
# Should get a warning message that detects an expected many-to-many relationship
print(paste("Post-Join Row Count:", nrow(bad_join))) 
# Row count is now 8, not 6 = WRONG (this messes up  your causal identification)

# Explicitly catching the row inflation trap
if (nrow(bad_join) != nrow(worker_panel)) {
  warning("Row count inflation.")
}


# Resolve this trap by binding across both individual ID AND temporal dimensions
correct_panel_join <- left_join(worker_panel, training_log, by = c("worker_id", "year"))

print(paste("Corrected Panel Row Count:", nrow(correct_panel_join)))
# Success as it should be 6 rows again.

# Many workers belong to one firm. We specify 'relationship' to assert this logic.
# If firm_registry accidentally contained duplicate rows, then this code would instantly show an error instead of silently corrupting the wage dataset.
final_master_df <- left_join(
  correct_panel_join, 
  firm_registry, 
  by = "firm_id", 
  relationship = "many-to-one"
)
head(final_master_df, 6)


subsidized_firms <- firm_registry %>% filter(subsidized == TRUE)

# A. SEMI-JOIN: Keep only rows from worker_panel that match subsidized firms
# Can isolate a clean Treatment Group without pulling in extra columns
treatment_group <- semi_join(worker_panel, subsidized_firms, by = "firm_id")
print(paste("Treatment Group Rows (Subsidized Firms Only):", nrow(treatment_group)))

# B. ANTI-JOIN: Keep only rows from worker_panel that DO NOT match subsidized firms
# Can isolate a clean, unexposed Control Group
control_group <- anti_join(worker_panel, subsidized_firms, by = "firm_id")
print(paste("Control Group Rows (Unsubsidized Firms Only):", nrow(control_group)))

# Joins were successful as you should get 3 rows in each (3 + 3 = 6 original rows).



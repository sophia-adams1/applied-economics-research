# ==============================================================================
# Portfolio Master: Bypassing Metadata Headers, Title Taps, and Specific Cells
# Scenario: Ingesting simulated official spreadsheets with non-standard starting rows
# ==============================================================================
install.packages("readr")
library(readr)
library(janitor)
install.packages("readxl")
library(readxl)

# SETUP SIMULATED RAW ONS FILE STREAM

# we simulate a raw CSV export with titles and source notes occupying the first few rows before the actual data table.

raw_ons_stream <- "Table 1a: Regional Productivity Indices
Released: June 2026 | Source: Simulated
region_code,region_name,productivity_index
UKC,North East,102.4
UKG,West Midlands,105.1
UKI,London,122.8"


# STRATEGY 1: Specify where the data begins as soon as you open the file. The 'skip' parameter:
# If the actual column names are on Row 3, we want to 
# 'skip' exactly the 2 rows of titles/junk above it. Row 3 then automatically becomes the header.
clean_via_skip <- read_csv(raw_ons_stream, skip = 2)
print(clean_via_skip)

# STRATEGY 2: janitor::row_to_names():
# Sometimes, you don't want to skip rows blindly because you need to programmatically check what the titles were, OR you are dealing with a complex data pipeline.
# We read the data in raw (letting R name columns 'X1', 'X2'), then promote Row 3.
raw_loaded_df <- read_csv(raw_ons_stream, col_names = FALSE)
print(head(raw_loaded_df, 3))
clean_via_janitor <- raw_loaded_df %>%
  janitor::row_to_names(row_number = 3) %>%
  clean_names() # forces headers into clean lowercase_snake_case
print(clean_via_janitor)

# STRATEGY 3: Targeted Excel Range Extraction:
# Official Excel files (.xlsx) often embed multiple distinct tables inside a single worksheet. We use 'range' to pull a specific block.
# We map the exact sheet and cell coordinates (top-left to bottom-right).

extract_excel_subtable <- function(file_path) {
  target_table <- read_excel(
    path  = file_path,
    sheet = "Table_1a",
    range = "B5:F25" # Targets the precise data matrix, ignoring peripheral text notes
  )
  return(target_table)
}
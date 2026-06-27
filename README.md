# Applied Economics & Policy Research Portfolio

Welcome to my repository of core empirical tools for applied economic analysis. This portfolio showcases production-grade R scripts designed for public sector research, labour market analysis and macroeconomic policy evaluation. 

These R scripts focus on solving the persistent challenges of applied research: parsing messy official microdata, enforcing relational database integrity, automating structural data manipulation and applying robust high-dimensional econometrics (not following a standard textbook).

---

## Technical Competencies

* **Econometric Modelling:** High-dimensional panel data, multi-way fixed effects (FE) and robust clustering using optimal estimation libraries (`fixest`).
* **Data Pipeline Design:** Structuring reproducible data ingestion routines, structural matrix pivoting and defensive data cleaning at file boundaries.
* **Data Integrity & Auditing:** Systematic row attrition analysis, relational join verification and validation of longitudinal panel tracking.
* **Spatial & Microdata Engineering:** Geoprocessing spatial regional indicators and engineering conditional stratification logic for large-scale social surveys.

---

## Repository Architecture & Script Walkthrough
The assets in this repository map onto the typical lifecycle of an empirical research project, from raw file ingestion to econometric estimation.

### 1. Data Ingestion & Structural Pipelines
* **`reproducible_data_ingestion.R`**
    * *Purpose:* This script handles defensive data ingestion from unformatted administrative source spreadsheets. This script automatically bypasses non-standard metadata blocks and programatically establishes clean data boundaries for analysis.
* **`ons_data_structural_reshaping.R`**
    * *Purpose:* This script targets complex matrix data structures (typical of official statistical releases like ONS). The script also automates the conversion of wide, hierarchical sheets into tidy long-form panel structures optimised for statistical analysis.

### 2. Processing, Integrity & Feature Engineering
* **`labour_panel_join_integrity.R`**
    * *Purpose:* This script implements rigid, multi-key relational joins across independent longitudinal survey sweeps. It includes built-in diagnostic logging to audit row attrition, sample drops and consistency of identifiers across waves.
* **`lfs_variable_engineering.R`**
    * *Purpose:* This script replicates structural data cleaning protocols for major household microdata (e.g. Labour Force Survey). The script utilises advanced multi-conditional logic to harmonise shifting demographic definitions, and isolate missing metadata flags.
* **`dplyr_across_transformations.R`**
    * *Purpose:* This script showcases clean, vectorised feature engineering routines using DRY (Don't Repeat Yourself) mechanics. Demonstrates batch-scoped transformations across dozens of numeric outcome variables simultaneously, without bloating the script.

### 3. Exploratory Analysis & Advanced Modelling
* **`exploratory_data_analysis.R`**
    * *Purpose:* This script establishes baseline descriptive statistics, distribution diagnostics and time-series aggregations. It features a clean, unified `ggplot2` visualisation layout which adopts professional graphic design standards (for policy briefs).
* **`fixest_fixed_effects.R`**
    * *Purpose:* This script shows high-dimensional fixed effects panel regressions using optimal computational algorithms (matching standard industry benchmarks for causal inference).
* **`regional_funding_spatial_analysis.R`**
    * *Purpose:* This script incorporates spatial economic dimensions into policy evaluation. Uses vector GIS tools to parse regional shapefiles, join localised financial indicators and map spatial disparities across geographic cohorts.

---

## Technical Toolkit

* **Language:** R (Advanced)
* **Core Ecosystem:** `tidyverse` (`dplyr`, `ggplot2`, `tidyr`, `purrr`, `readxl`)
* **Econometrics & Geospatial:** `fixest`, `sf`

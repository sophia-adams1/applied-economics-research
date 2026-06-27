

install.packages("fixest")
library(fixest)            
library(ggplot2)

wagepan <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/wagepan.csv")
View(wagepan)
head(wagepan, 10)
str(wagepan)

###################

# 1. Pooled OLS (Baseline with no controls for unobserved heterogeneity)
model_ols  <- feols(lwage ~ married + union + exper, data = wagepan)

# 2. Individual Fixed Effects (Controls for person-specific traits)
model_fe  <- feols(lwage ~ married + union + exper | nr, data = wagepan)

# 3. Two-Way Fixed Effects (Controls for both person AND macro year shocks)
model_twfe <- feols(lwage ~ married + union | nr + year, data = wagepan)
# 4. Interaction Model (Built for the event-study plot)
model_int  <- feols(lwage ~ married + i(year, union, ref = 1980) | nr + year, data = wagepan)


# This generates the clean event-study plot showing dynamic shifts over time.
print("Generating Event-Study Interaction Plot...")
iplot(model_int, 
      main = "Dynamic Shift in Union Wage Premium Over Time",
      xlab = "Panel Timeline (Omitted Reference Base: 1980)",
      pt.join = TRUE)


# Dictionary to clean up variable names for a professional output
var_dictionary <- c(
  married = "Marital Status (1 = Married)",
  union   = "Union Membership Status",
  lwage   = "Log of Hourly Earnings"
)

# Economic journal standard significance thresholds
custom_stars <- c("***" = 0.01, "**" = 0.05, "*" = 0.1)

print("Displaying Custom Markdown Regression Matrix:")
etable(model_ols, model_fe, model_twfe, 
       headers = c("Pooled OLS", "Individual FE", "Two-Way FE"),
       cluster = "nr", 
       keep_raw = "married|union", 
       dict = var_dictionary, 
       signifCode = custom_stars, 
       se.below = TRUE, 
       digits = 3)





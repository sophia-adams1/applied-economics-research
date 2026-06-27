# Tidyverse: Data Wrangling.
# Gapminder dataset - looking at things like life expectancy vs. GDP.
# filter(), arrange(), mutate() and pipe %>% .

# Install the right packages.
install.packages("gapminder")
install.packages("dplyr")
library(gapminder)
library(dplyr)
gapminder
# Dataset has 1,704 observations/rows and 6 columns: country, continent, year, life expectancy, population, gdp per capita.


# Filter() function for when you want to look at a subset of the observations, based on a particular condition. Common first step in the analysis.
# You use a pipe: %>% : percent is greater than percent. It says: whatever is before it, you feed it into the next step.
# Use a logical equal == to compare 2 values. A single equals = means something else.
gapminder %>%
  filter(year == 2007)
# Here we can see there are now 142 rows, so there are 142 countries in the dataset.
# You can still use the whole gapminder object for further analysis._
# If you only wanted to  get observations from the United States:
gapminder %>%
  filter(country == "United States")
# You can also define multiple conditions inside the filter() function.
# This is useful for extracting a single observation you're looking for.
# You separate arguments (arguments are x == y) with a comma.
gapminder %>%
  filter(year == 2007, country == "United States")
gapminder %>%
  filter (year == 2002, country == "China")


# The arrange() function sorts a table based on a variable.
# In ascending or descending order, based on the variables.
# Good for finding the most extreme values in a dataset.
gapminder%>%
  arrange(gdpPercap)
# Here it starts with the lowest GDP per capita of Democratic Republic of Congo in 2002.
# To arrange in descending order:
gapminder%>%
  arrange(desc(gdpPercap))
# Here it starts with the highest GDP per capita of Kuwait in 1957.


# You can combines the 2 verbs filter() and arrange().
# For example, if you wanted to see the highest GDP per capita within one specific year.
# Add a pipe to tell it to then arrange.
gapminder%>%
  filter(year == 2007) %>%
  arrange(desc(gdpPercap))
# Note there is no ascending version, you'd just arrange as normal.
gapminder %>%
  filter(year == 1957) %>%
  arrange(desc(pop))


# The mutate() function. Change an original column, change the variables to help analyse.
gapminder %>%
  mutate(pop = pop / 1000000)
# Using mutate tO add a varibale. What if you wanted to have a column of GDP per capita x population?
gapminder %>%
  mutate(gdp = gdpPercap * pop)
# gdp is the new column here. You can't use spaces, hence lifeExp or gdpPercap.


# Suppose we want to know the countries with the highest gdp (gdpPercap x pop) in 2007?
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(year == 2007) %>%
  arrange(desc(gdp))


# Tidyverse_Data_visualisation
# This chapter = a graph, rather than a table.
# How to make a scatterplot using an X and Y axis.
# It's useful to assign the specific data you want (e.g. all the countries specifically in 2007) to a new variable.
# Aesthetics in this R script = x, y, colour and size.

library(gapminder)
library(dplyr)
gapminder
gapminder_2007 <- gapminder %>%
  filter(year == 2007)
gapminder_2007


# Say you want to compare GDP per Capita and Life Expectancy.
library(ggplot2)
ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()


# Say you now want to do the same but for 1952, and population instead of life expectancy on the x axis.
gapminder_1952 <- gapminder %>%
  filter(year == 1952)
gapminder_1952
ggplot(gapminder_1952, aes(x = pop, y = gdpPercap)) +
  geom_point()


# Now for a graph with population on the x axis and life expectancy on the y axis.
ggplot(gapminder_1952, aes(x = pop, y = lifeExp)) +
  geom_point()


# What if a lot of the data is clustered at one end and sparse at the other end?
# Useful to use a log scale to even everything out without altering the data.
# How to add a log scale: in this case, we want the x axis to be a bit more spread out.
ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  scale_x_log10()


# How to put BOTH the x and y axes on a log scale:
ggplot(gapminder_1952, aes(x = pop, y = gdpPercap)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10()


# How to add aesthetics COLOUR and SIZE.
# Colour: A good way to represent categorical variables, like continent, is through colour. It'll add a colour code itself, and use the American spelling in the code.
# Size: You can change the size of each plot to be a big or small circle. This could change according to if the population is big or small.
ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = continent,
                           size = pop)) +
  geom_point() +
  scale_x_log10()


# Scatter plot comparing pop and lifeExp, with color representing continent, and the x axis on a log scale.
ggplot(gapminder_1952, aes(x = pop, y = lifeExp, color = continent,
                           size = pop)) +
  geom_point() +
  scale_x_log10()


# Faceting: You can divide your plot into sub-plots, for example where you have a separate plot for each continent's GDP per Capita. Split the plot by ~ condition.
ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~ continent)


# Now do faceting of the gapminder dataset but by year.
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, 
                      size = pop)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~ year)

# Tidyverse; Grouping & Summarising.

library(gapminder)
library(dplyr)
library(ggplot2)

# Summarize to find the median life expectancy
gapminder %>%
  summarize(medianlifeExp = median(lifeExp))

# Filter for 1957 then summarize the median life expectancy
gapminder %>%
  filter(year == 1957) %>%
  summarize(medianLifeExp = median(lifeExp))

# Filter for 1957 then summarize the median life expectancy and the maximum GDP per capita
gapminder %>%
  filter(year == 1957) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

# Find median life expectancy and maximum GDP per capita in each year
gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

# Find median life expectancy and maximum GDP per capita in each continent in 1957
gapminder %>%
  filter(year == 1957) %>%
  group_by(continent) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

# Find median life expectancy and maximum GDP per capita in each continent/year combination
gapminder %>%
  group_by(year, continent) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

# Turn a new table into an object that can be visualised with ggplot2.
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# Create a scatter plot showing the change in medianLifeExp over time
ggplot(by_year, aes(x = year, y = medianLifeExp)) +
  geom_point() +
  expand_limits(y = 0)

# Summarize medianGdpPercap within each continent within each year: by_year_continent
by_year_continent <- gapminder %>%
  group_by(continent, year) %>%
  summarize(medianGdpPercap = median(gdpPercap))

# Plot the change in medianGdpPercap in each continent over time
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, color = continent)) +
  geom_point() +
  expand_limits(y = 0)

# Summarize the median GDP and median life expectancy per continent in 2007
by_continent_2007 <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(medianGdpPercap = median(gdpPercap), medianLifeExp = median(lifeExp))

# Use a scatter plot to compare the median GDP and median life expectancy
ggplot(by_continent_2007, aes(x = medianGdpPercap, y = medianLifeExp, color = continent)) +
  geom_point()


# New types of plots and adding a title to the graph.
# Line plot, bar plot, Histogram and Box plot.
# What's the point? To be able to view summary statistics (e.g. mean, median) over time and space.
library(dplyr)
library(gapminder)
library(ggplot2)

###################################################################################

# LINE PLOTS: Change geom_point() to: geom_line() to make it a line plot.
# Summarize the median gdpPercap by year, then save it as by_year
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(medianGdpPercap = median(gdpPercap))
# Create a line plot showing the change in medianGdpPercap over time
ggplot(by_year, aes(x = year, y = medianGdpPercap)) +
  geom_line() +
  expand_limits(y = 0)

# Summarize the median gdpPercap by year & continent, save as by_year_continent
by_year_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarize(medianGdpPercap = median(gdpPercap))
# Create a line plot showing the change in medianGdpPercap by continent over time
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, color = continent)) +
  geom_line() +
  expand_limits(y = 0)

###################################################################################

# BAR PLOTS: Use geom_col(). The X axis is often the categorical variable such as continent. Y is often numerical and determines the height.
# Summarize the median gdpPercap by continent in 1952
by_continent <- gapminder %>%
  group_by(continent) %>%
  filter(year == 1952) %>%
  summarize(medianGdpPercap = median(gdpPercap))
# Create a bar plot showing medianGdp by continent
ggplot(by_continent, aes(x = continent, y = medianGdpPercap)) +
  geom_col()

# Filter for observations in the Oceania continent in 1952
oceania_1952 <- gapminder %>%
  filter(continent == "Oceania", year == 1952)
# Create a bar plot of gdpPercap by country
ggplot(oceania_1952, aes(x = country, y = gdpPercap)) +
  geom_col()

###################################################################################

# HISTOGRAMS: Use geom_histogram() and it only has an x axis aesthetic. The width of each column is automatic, but you can customise it using binwidth. You might also need to put the x axis on a log scale like you did in a scatter plot: scale_x_log10(). A histogram is useful for examining the distribution of a numeric variable, such as the life expactancy of each country.
# Create the dataset to create a histogram.
gapminder_1952 <- gapminder %>%
  filter(year == 1952) %>%
  mutate(pop_by_mil = pop / 1000000)
# Create a histogram of population (pop_by_mil) where the number of bins is 50.
ggplot(gapminder_1952, aes(x = pop_by_mil)) +
  geom_histogram(bins = 50)

# Now make a histogram less skewed.
gapminder_1952 <- gapminder %>%
  filter(year == 1952)
# Create a histogram of population (pop), with x on a log scale
ggplot(gapminder_1952, aes(x = pop)) +
  geom_histogram() +
  scale_x_log10()

###################################################################################

# BOX PLOTS: Think standard deviation. In the histograms, we looked at countries' life expactancies, but we can't tell what continent they're all in. What if we wanted to distinguish by continent? Use a box plot.
# Use geom_boxplot(). The x axis is often categorical.
# The black line in the middle of each plot is the median of the content's distribution.
# The top and bottom of each box represent the 75th percentile and 25th percentile, so half the distribution lies in that box.And the 'whiskers' (lines going up and down) cover additional countries.
# Any dots represent outliers.

# Get your dataset to make the box plot.
gapminder_1952 <- gapminder %>%
  filter(year == 1952)
# Create a boxplot comparing gdpPercap among continents
ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) +
  geom_boxplot() +
  scale_y_log10()

###################################################################################

# ADDING A TITLE TO YOUR GRAPH (SCATTER, LINE, BAR, HISTOGRAM, BOX PLOT)
# it's just ggtitle("title name")

gapminder_1952 <- gapminder %>%
  filter(year == 1952)
# Create a boxplot comparing gdpPercap among continents
ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) +
  geom_boxplot() +
  scale_y_log10() +
  ggtitle("Comparing GDP per capita across continents")











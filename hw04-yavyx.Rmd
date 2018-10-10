---
title: "Homework #4"
author: "Javier Castillo-Arnemann"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

First, as usual, we'll load the necessary packages:

```{r}
library(gapminder)
library(knitr)
suppressPackageStartupMessages(library(tidyverse))
```


##Activity 1
*Make a tibble with one row per year and columns for life expectancy for two or more countries.
Use `knitr::kable()` to make this table look pretty in your rendered homework.
Take advantage of this new data shape to scatterplot life expectancy for one country against that of another.*

For this activity, we will choose the country with the highest average life expectancy in each continent and compare them.

We first create a dataframe that has the information for the countries with the highest average life expectancy.
```{r}
max_life_exp_countries <- gapminder %>% 
  group_by(continent, country) %>%
  summarize(mean_lifeExp = mean(lifeExp)) %>%  #Get the mean life expectancy in each country
  filter(mean_lifeExp == max(mean_lifeExp)) #Get the highest life expectancy for each continent
```

Then we can use this dataframe's countries to filter the countries in the gapminder dataset:
```{r}
spread_lifeExp <- gapminder %>%
  filter(country %in% max_life_exp_countries$country) %>% #Using the %in% operator to filter correctly
  select(year, country, lifeExp) %>%
  spread(key = country, value = lifeExp) 

kable(spread_lifeExp, align = "c") #Align values to the center
```

Now, let's plot some of this information. We will compare the life expectancies of Japan and Reunion.
```{r}
spread_lifeExp%>%
  ggplot(aes(Reunion, Japan)) +
  geom_point() +
  labs(title = "Life Expectancy of Reunion vs Japan") +
  geom_smooth()
```

This plot is a good example of an important concept in statistics: correlation does not imply causation. Even though there is a strong correlation between the life expectancies in Japan and Reunion, it is highly unlikely that one is the direct cause for the other.

##Activity 2
*Create your own cheatsheet patterned after Jenny’s but focused on something you care about more than comics!*

For this activity, I created two small `.csv` files that contain some information about Major League Baseball (MLB) players and teams. We'll start by importing this data to R.
```{r}
mlb_players <- read_csv("mlb_players.csv")
mlb_teams <- read_csv("mlb_teams.csv")
kable(mlb_players)
kable(mlb_teams)
```

We'll try the `join` functions one by one to see what happens:

### `left_join`
```{r}
kable(left_join(mlb_players, mlb_teams, by = "team"))
```

Here we can see that for Max Scherzer's team, the Nationals, there is no information available, so his league and division get `NA` values, and we get 7 rows because there are 7 rows in `mlb_players`. This is because we are matching the values in `mlb_teams` to `mlb_players`.

### `right_join`
```{r}
kable(right_join(mlb_players, mlb_teams, by = "team"))
```

Here we can see that because there are no players in the dataset for the Cubs or White Sox, we get `NA` values for their players and positions, and we get 8 rows because there are 8 rows in `mlb_teams`. This is because we are matching the values in `mlb_players` to `mlb_teams`.

### `inner_join`
```{r}
kable(inner_join(mlb_players, mlb_teams, by = "team"))
```

Here we only see 6 rows because it's matching only the entries that have data in both sets, so we don't get any `NA` values.

### `full_join`
```{r}
kable(full_join(mlb_players, mlb_teams, by = "team"))
```

Here we see 9 rows because it's trying to match all the data from both datasets. It's like a combination of `left_join` and `right_join`.

### `semi_join`
```{r}
kable(semi_join(mlb_players, mlb_teams, by = "team"))
```

This is a "filtering" join, because it doesn't add the variables in `mlb_teams`, just filters the observations in `mlb_players` that have entries in `mlb_teams`.

### `anti_join`
```{r}
kable(anti_join(mlb_players, mlb_teams, by = "team"))
```

This is also a "filtering" join, but does exactly the opposite of `semi_join` because it filters the observations in `mlb_players` that **do not** have entries in `mlb_teams`.

##Activity 3
Here we are comparing the base R `merge()` function with `dplyr`'s `join` functions.

```{r}
kable(merge(mlb_players, mlb_teams, by = "team"))
```

This is equivalent to the `inner_join()` function, as all 6 entries that had information in both datasets were merged together. After a look in the [documentation](https://stat.ethz.ch/R-manual/R-devel/library/base/html/merge.html), we can see that the main difference between `merge()` and the `inner_join()` functions is that in `merge()` there are arguments to specify how the merging should be done, which are analogous to the left, right, semi and full `dplyr` joins.

##References
* [R studio Data Wrangling Cheat Sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
* [cm009](https://github.com/yavyx/STAT545_participation/blob/master/cm009/cm009.Rmd) and [cm010](https://github.com/yavyx/STAT545_participation/blob/master/cm010/cm010-exercise.Rmd)



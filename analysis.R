# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel
# @project: State Testing Analysis
# @file:    analysis.R
# @desc:    Analysis of testing data

library(tidyverse)
library(ggplot2)
library(GGally)
library(hrbrthemes)

ks = read_csv("Keystone/keystone.csv")
ps = read_csv("PSSA/pssa.csv")

# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2015?

# Objective 2: How they compare to the state trend since 2015?
m = aov(Score ~ as_factor(Baseline) + as_factor(Subject) + Year, data = ks)
summary(m)

m1 = glm(Score ~ as_factor(Baseline) + as_factor(Subject) + Year, data = ks)
summary(m1)

plot(m)
ggpairs(m)


# Objective 3: Is there any COVID impact we might be able to deduce?
m = aov(Score ~ as_factor(Subject) + Year + as_factor(Baseline) + 
          as_factor(District) + as_factor(School) + 
          as_factor(County), data = ks)
summary(m)


m2 = glm(Score ~ as_factor(Subject) + Year + as_factor(Baseline) + 
           as_factor(District) + as_factor(School) + 
           as_factor(County), data = ks)
summary(m2)

plot(m)
ggpairs(m)

m3 = glm(Score ~ as_factor(Baseline) + Year, data = ks)
summary(m3)

p1 = ggplot(data = ks, aes(x = Year, y = Score)) +
  geom_bar(stat = "identity", fill = "blue") +
  facet_wrap(~ as_factor(Baseline))

p1

# Objective 4: Any other information that data might tell us?


# Objective 5: Visualizing the averages of scores from each year.

# Objective 5a. As a whole.

# Objective 5b. Grouped by subject.

# Objective 5c. Grouped by district.


# Objective 6. Compare scores between districts.


# Objective 7. (John's objective)


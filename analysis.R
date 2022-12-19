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
cohorts = read_csv("Cohorts/cohorts.csv")

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

ks$County = as_factor(ks$County)
str(ks$County)
levels(ks$County) = c("State", "Colombia", "Montour")
levels(ks$County)


p2 = ggplot(data = ks, aes(fill = as_factor(Baseline), y = Score, x = as_factor(County))) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~Year) +
  xlab("State vs Counties")

p2

#BelowBasic: Colombia County outperformed State and Montour County prior to COVID.
#After COVID, Colombia County suffered some against State Level. Montour County ranked the worst
#throughout the years and reached all time low in 2021.

#Basic: Colombia County outperformed both State and Montour County throughout the years.
#After COVID, all levels experienced some losses. Montour County kept ranking the worst.

#Proficient: Once again Colombia County outperformed State and Montour County throughout the years.
#Both Montour and Colombia Counties fared better compared to State levels. There was a 
#some decline in Montour County in 2021 causing the score averages to reach to state levels.
#However in 2022, there was a strong spike in Proficient in Montour and Colombia,
#outpacing State

#Advanced: Colombia County outperformed State and Montour County across the years.
#Montour County performed slightly better than State. Once again, in 2021, there
#was a slight delcine in scores possibly due to COVID

#As graph suggests, all baseline levels experienced some decline in scores due to COVID
#with one exception. As a matter of fact in 2021, there was a spike in Advanced Baseline which 
#suggests that COVID was not a determinator for scores in this level.
#Proficient level seemed to suffer the most due to COVID19 pandemic.

# Objective 4: Any other information that data might tell us?


# Objective 5: Visualizing the averages of scores from each year.

# Objective 5a. As a whole.

# Objective 5b. Grouped by subject.

# Objective 5c. Grouped by district.


# Objective 6. Compare scores between districts.


# Objective 7. Study Cohorts
cohorts

# Cohorts Local Level
#             |<------PSSA----------->|
#                               |<--------Keystone----->|
#          2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022
# Cohort 1    4     5     6     7     8                11
# Cohort 2    5     6     7     8                11
# No 2020
# Cohort 3    7     8                11
# Cohort 4    8                11




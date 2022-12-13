# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel
# @project: State Testing Analysis
# @file:    analysis.R
# @desc:    Analysis of testing data

library(tidyverse)
library(ggplot2)
library(GGally)

ks = read_csv("Keystone/keystone.csv")
ps = read_csv("PSSA/pssa.csv")

m = aov(Score ~ as_factor(Baseline) + as_factor(Subject) + Year, data = ks)
summary(m)

m1 = glm(Score ~ as_factor(Baseline) + as_factor(Subject) + Year, data = ks)
summary(m1)

plot(m)
ggpairs(m)

ks1 = read.csv("Keystone/keystone.csv")
plot(ks1)


# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2015?

# Objective 2: How they compare to the state trend since 2015?

# Objective 3: Is there any COVID impact we might be able to deduce?

# Objective 4: Any other information that data might tell us?

# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel
# @project: State Testing Analysis
# @file:    analysis.R
# @desc:    Analysis of testing data

library(tidyverse)

ks = read_csv("Keystone/keystone.csv")
ps = read_csv("PSSA/pssa.csv")


# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2015?

# Objective 2: How they compare to the state trend since 2015?

# Objective 3: Is there any COVID impact we might be able to deduce?

# Objective 4: Any other information that data might tell us?

# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel
# @project: State Testing Analysis
# @file:    analysis.R
# @desc:    Analysis of testing data

library(tidyverse)

ks.sc = read_csv("Keystone/School/keystone_school.csv")
ks.st = read_csv("Keystone/State/keystone_state.csv")
ps.sc = read_csv("PSSA/School/pssa_school.csv")
ps.st = read_csv("PSSA/State/pssa_state.csv")


# Objects imported

# ks.sc      - keystone/school dataset
# ks.sc.cols - keystone/school columns          Subject, Scored, Baseline, Score, Year, County, District, School

# ks.st      - keystone/state dataset
# ks.st.cols - keystone/state columns           Subject, Scored, Baseline, Score, Year

# ps.sc      - PSSA/school dataset
# ps.sc.cols - PPSA/school columns              Subject, Scored, Baseline, Score, Year, County, District, School, Grade, SchoolNum

# ps.st      - PSSA/state dataset
# ps.st.cols - PSSA/state columns               Subject, Scored, Baseline, Score, Year,                           Grade 



# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2015?

# Objective 2: How they compare to the state trend since 2015?

# Objective 3: Is there any COVID impact we might be able to deduce?

# Objective 4: Any other information that data might tell us?

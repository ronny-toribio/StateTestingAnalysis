# @authors: Ronny Toribio, Anna Schlecht, Kadir Altunel
# @project: State Testing Analysis
# @file:    objectives.R
# @desc:    Project Objectives

source("api.R")

# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2015?

#PSSA
plot_trends1(
  ps,
  "PSSA Testing Averages in Columbia and Montour Counties",
  "Graphs/Obj1PS.png"
)

#Keystone
plot_trends1(
  ks,
  "Keystone Testing Averages in Columbia and Montour Counties",
  "Graphs/Obj1KS.png"
)

# Objective 2: How they compare to the state trend since 2015?

# Objective 2 PSSA
plot_trends2(
  ps,
  "State",
  "Top PSSA Scores in Pennsylvania",
  "Graphs/Obj2statePS.png"
)

plot_trends2(
  ps,
  "Columbia",
  "Top PSSA Scores in Columbia county",
  "Graphs/Obj2columbiaPS.png"
)

plot_trends2(
  ps,
  "Montour",
  "Top PSSA Scores in Montour county",
  "Graphs/Obj2montourPS.png"
)

# Objective 2 PSSA Interpretation

# PSSA data also shows similar observations all levels for the top category.
# For state level, average score percentage dipped in 2017 and went back to 2016
# levels in 2018 and 2019. There was a decline in 2021 and a slight increase in 2022
# In Colombia County, average score percentage stayed steady from 2016 to 2019.
# There was a decline in percentage in 2021 which showed some recovery in 2022.
# In Montour County, average score percentage rose all time high in 2019 in
# observed years (2016-2022). There was a sharp decline in 2021 and some
# recovery in 2022. 


# Objective 2 Keystone
plot_trends2(
  ks,
  "State",
  "Top Keystone Scores in Pennsylvania",
  "Graphs/Obj2stateKS.png"
)

plot_trends2(
  ks,
  "Columbia",
  "Top Keystone Scores in Columbia county",
  "Graphs/Obj2columbiaKS.png"
)

plot_trends2(
  ks,
  "Montour",
  "Top Keystone Scores in Montour county",
  "Graphs/Obj2montourKS.png"
)

# Objective 2 Keystone Interpretation

# When we look at the graphs, we see that top category, which combines advanced
# and proficient categories, fluctuates for every levels (State, Montour County,
# and Colombia County).
# For state level, average score percentage for top category is trending lower
# than its high in 2016. We see that average score percentage declined in 2017
# and rose in 2018 and then started declining again for the rest of the years.
# In Colombia County, average score for the top category is also trending lower
# than its high in 2016. We see that average score percentage declined in 2017
# and rose in 2018 and stayed steady for 2019. However, it started to dip
# in 2021 and 2022
# In Montour County, average score for the top category shows fluctuations for
# the years observed. The average score percentage dipped in 2017 only to rise
# and dip again in 2018 and 2019 respectively. The same pattern of rise and dip
# was also observed in 2021 and 2022.


# Objective 3: Is there any COVID impact we might be able to deduce?

# PSSA
plot_trends3(
  ps,
  list(
    list(
      "county" = "State",
      "subject" = "English",
      "title" = "Top PSSA Scores in Pennsylvania for English",
      "filename" = "Graphs/Obj3stateEngPS.png"
    ),
    list(
      "county" = "State", 
      "subject" = "Math", 
      "title" = "Top PSSA Scores in Pennsylvania for Math", 
      "filename" = "Graphs/Obj3stateMathPS.png"
    ),
    list(
      "county" = "State", 
      "subject" = "Science", 
      "title" = "Top PSSA Scores in Pennsylvania for Science", 
      "filename" = "Graphs/Obj3stateSciPS.png"
    ),
    list(
      "county" = "Columbia", 
      "subject" = "English", 
      "title" = "Top PSSA Scores in Columbia county for English", 
      "filename" = "Graphs/Obj3columbiaEngPS.png"
    ),
    list(
      "county" = "Columbia", 
      "subject" = "Math",
      "title" = "Top PSSA Scores in Columbia county for Math", 
      "filename" = "Graphs/Obj3columbiaMathPS.png"
    ),
    list(
      "county" = "Columbia", 
      "subject" = "Science", 
      "title" = "Top PSSA Scores in Columbia county for Science", 
      "filename" = "Graphs/Obj3columbiaSciPS.png"
    ),
    list(
      "county" = "Montour",
      "subject" = "English", 
      "title" = "Top PSSA Scores in Montour county for English",
      "filename" = "Graphs/Obj3montourEngPS.png"
    ),
    list(
      "county" = "Montour", 
      "subject" = "Math", 
      "title" = "Top PSSA Scores in Montour county for Math", 
      "filename" = "Graphs/Obj3montourMathPS.png"
    ),
    list(
      "county" = "Montour", 
      "subject" = "Science", 
      "title" = "Top PSSA Scores in Montour county for Science", 
      "filename" = "Graphs/Obj3montourSciPS.png"
    )
  )
)


# Keystone
plot_trends3(
  ks,
  list(
    list(
      "county" = "State",
      "subject" = "English",
      "title" = "Top Keystone Scores in Pennsylvania for English",
      "filename" = "Graphs/Obj3stateEngKS.png"
    ),
    list(
      "county" = "State", 
      "subject" = "Math", 
      "title" = "Top Keystone Scores in Pennsylvania for Math", 
      "filename" = "Graphs/Obj3stateMathKS.png"
    ),
    list(
      "county" = "State", 
      "subject" = "Science", 
      "title" = "Top Keystone Scores in Pennsylvania for Science", 
      "filename" = "Graphs/Obj3stateSciKS.png"
    ),
    list(
      "county" = "Columbia", 
      "subject" = "English", 
      "title" = "Top Keystone Scores in Columbia county for English", 
      "filename" = "Graphs/Obj3columbiaEngKS.png"
    ),
    list(
      "county" = "Columbia", 
      "subject" = "Math",
      "title" = "Top Keystone Scores in Columbia county for Math", 
      "filename" = "Graphs/Obj3columbiaMathKS.png"
    ),
    list(
      "county" = "Columbia", 
      "subject" = "Science", 
      "title" = "Top Keystone Scores in Columbia county for Science", 
      "filename" = "Graphs/Obj3columbiaSciKS.png"
    ),
    list(
      "county" = "Montour",
      "subject" = "English", 
      "title" = "Top Keystone Scores in Montour county for English",
      "filename" = "Graphs/Obj3montourEngKS.png"
    ),
    list(
      "county" = "Montour", 
      "subject" = "Math", 
      "title" = "Top Keystone Scores in Montour county for Math", 
      "filename" = "Graphs/Obj3montourMathKS.png"
    ),
    list(
      "county" = "Montour", 
      "subject" = "Science", 
      "title" = "Top Keystone Scores in Montour county for Science", 
      "filename" = "Graphs/Obj3montourSciKS.png"
    )
  )
)

# Objective 3 ANOVA analysis

# PSSA
ps_anova = aov(Score ~ Year + as_factor(County) + as_factor(District) + 
                 as_factor(School) + as_factor(Subject) + Scored +
                 as_factor(Category) + Score + Students, data = ps)
summary(ps_anova)

# Keystone
ks_anova = aov(Score ~ Year + as_factor(County) + as_factor(District) + 
                 as_factor(School) + as_factor(Subject) + Scored +
                 as_factor(Category) + Score + Students, data = ks)
summary(ks_anova)


# Objective 3 interpretation

# When we look at both Keystone and PSSA data, we can clearly see that, COVID-19
# has impacted top score average percentages. Especially in 2021, we see a sharp
# decline in all levels (State, Colombia County and Montour County). However,
# starting 2022, we see some recovery in percentages in those levels. 

# However, there's no linearity between years and average score percentages so as
# to say, we don't see an upward or downward trend every year. 
# The ANOVA table also indicates the absence of linearity in trend without
# any significant impact between top score average percentages and year.



# Objective 4: Visualizing the averages of scores from each year grouped by subject.

#PSSA
plot_trends4(
  ps, 
  "Top PSSA Scores By Subject", 
  "Graphs/Obj4PS.png"
)

#Keystone
plot_trends4(
  ks, 
  "Top Keystone Scores By Subject", 
  "Graphs/Obj4KS.png"
)


# Objective 5: Compare scores between districts

#PSSA
plot_trends5(
  ps, 
  "Top PSSA Scores By District", 
  "Graphs/Obj5PS.png"
)

#Keystone
plot_trends5(
  ks, 
  "Top Keystone Scores By District", 
  "Graphs/Obj5KS.png"
)


# Objective 6: Study Cohorts

# Cohorts Local Level
#             |<------PSSA----->|
#                               |<---Keystone--->|
#          2016, 2017, 2018, 2019, 2020, 2021, 2022
# Cohort 1    8                11
# Cohort 2    6     7     8                11
# Cohort 3    5     6     7     8                11

# Cohorts Timeline
plot_cohorts_timeline(
  cohorts, 
  "Graphs/Obj6_timeline.png"
)

# State
plot_trends6(
  cohorts, 
  "State", 
  "Cohorts Pennsylvania", 
  "Graphs/Obj6_state.png"
)

# Columbia county
plot_trends6(
  cohorts, 
  "Columbia", 
  "Cohorts Columbia county", 
  "Graphs/Obj6_columbia.png"
)

# Montour county
plot_trends6(
  cohorts, 
  "Montour", 
  "Cohorts Montour county", 
  "Graphs/Obj6_montour.png"
)



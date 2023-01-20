# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel
# @project: State Testing Analysis
# @file:    analysis.R
# @desc:    Analysis of testing data

library(tidyverse)

# Main theme
theme_main = function(base_size=11, base_family=""){
  theme(
    plot.background = element_rect(fill="black"),
    plot.title = element_text(color="white", size=24, face="bold", vjust=1),
    panel.background = element_rect(fill="darkblue", color="darkblue", linetype="solid"),
    strip.background = element_rect(fill="steelblue"),
    strip.text = element_text(color="white", face = "bold"),
    legend.background = element_rect(fill="black"),
    legend.text = element_text(color="white", size=24),
    legend.title = element_text(color="white", size=24),
    panel.grid.major = element_line(color="white", linetype="solid"),
    panel.grid.minor = element_line(color="white", linetype="solid"),
    panel.border = element_rect(color="darkblue", fill = NA),
    axis.line = element_line(color="darkblue"),
    axis.ticks = element_line(color="darkblue"),
    axis.text = element_text(color="white", size=24),
    axis.text.x = element_text(color="white",size=24),
    axis.text.y = element_text(color="white"),
    axis.title.x = element_text(color="white", face="bold", vjust=-1, size=24),
    axis.title.y = element_text(color="white", face="bold", angle=90, vjust=2, size=24)
  )
}
theme_set(theme_main())


# Change Trends utility functions
add_changes_trend = function(t){
  t$AvgScoreChangePos = t$AvgScoreChange
  t$AvgScoreChangePos[t$AvgScoreChangePos < 0] = NA
  t$AvgScoreChangeNeg = t$AvgScoreChange
  t$AvgScoreChangeNeg[t$AvgScoreChangeNeg > 0] = NA
  t
}

calc_changes_trend_by_county = function(t){
  column = (t %>% ungroup() %>% select(County) %>% distinct())$County
  result = tibble()
  for(i in column){
    selection = t %>% filter(County == i)
    selection$AvgScoreChange = round(selection$AvgScore - lag(selection$AvgScore), 2)
    result = bind_rows(result, selection)
  }
  add_changes_trend(result)
}

calc_changes_trend_by_subject = function(t){
  column = (t %>% ungroup() %>% select(Subject) %>% distinct())$Subject
  result = tibble()
  for(i in column){
    selection = t %>% filter(Subject == i)
    selection$AvgScoreChange = round(selection$AvgScore - lag(selection$AvgScore), 2)
    result = bind_rows(result, selection)
  }
  add_changes_trend(result)
}

calc_changes_trend_by_cohort = function(t){
  column = (t %>% ungroup() %>% select(Cohort) %>% distinct())$Cohort
  result = tibble()
  for(i in column){
    selection = t %>% filter(Cohort == i)
    selection$AvgScoreChange = round(selection$AvgScore - lag(selection$AvgScore), 2)
    result = bind_rows(result, selection)
  }
  add_changes_trend(result)
}

plot_cohorts = function(t, title){
  t = calc_changes_trend_by_cohort(t)
  pt = t %>%
    ggplot(aes(x=Grade, y=AvgScore, fill=Grade)) +
    geom_col(position="dodge") +
    geom_label(aes(x=Grade, y=AvgScore-1.5 , label = AvgScoreLabel), color="white") +
    geom_label(aes(x=Grade, y=20 , label = AvgScoreChangePos), color="green", fill="darkblue") +
    geom_label(aes(x=Grade, y=20 , label = AvgScoreChangeNeg), color="red", fill="darkblue") +
    facet_wrap(~Cohort, labeller=labeller(Cohort=c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
    labs(title=title)
  plot(pt)
}

# PSSA and Keystone datasets
ps = read_csv("PSSA/pssa.csv")
ks = read_csv("Keystone/keystone.csv")
ps$County = as_factor(ps$County)
ks$County = as_factor(ks$County)
ps$Category = as_factor(ps$Category)
ks$Category = as_factor(ks$Category)

# Cohorts dataset
cohorts = read_csv("Cohorts/cohorts.csv")
cohorts$County = as_factor(cohorts$County)
cohorts$Category = as_factor(cohorts$Category)
cohorts$Grade = as_factor(cohorts$Grade)
cohorts$Cohort = as.integer(cohorts$Cohort)


# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2015?

#PSSA
obj1ps = ps %>%
  filter(County != "State" & Category == "Top") %>%
  select(Year, County, Category, Students, Scored) %>%
  group_by(Year, County) %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore=Students/Scored*100, AvgScoreLabel=round(AvgScore,2))
obj1ps = calc_changes_trend_by_county(obj1ps)
pobj1ps = obj1ps %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = position_dodge2(0.9)) +
  geom_label(aes(x=Year, y=AvgScore-1.5, label = AvgScoreLabel), position = position_dodge2(0.9), color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  labs(title = "PSSA Testing Averages in Columbia and Montour Counties") +
  xlab("Years") + 
  ylab("Cumulative Average Score (%)")
plot(pobj1ps)
ggsave("Graphs/Obj1PS.png", pobj1ps, pobj1ks, width=900, height=900, units="px")

#Keystone
obj1ks = ks %>%
  filter(County != "State" & Category == "Top") %>%
  select(Year, County, Category, Students, Scored) %>%
  group_by(Year, County) %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore=Students/Scored*100, AvgScoreLabel=round(AvgScore,2))
obj1ks = calc_changes_trend_by_county(obj1ks)
pobj1ks = obj1ks %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = position_dodge2(0.9)) +
  geom_label(aes(x=Year, y=AvgScore-1.5, label = AvgScoreLabel), position = position_dodge2(0.9), color="white") +
  geom_label(aes(x=Year, y=25 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=25 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  labs(title = "Keystone Testing Averages in Columbia and Montour Counties")+
  xlab("Years") + 
  ylab("Cumulative Average Score (%)")
plot(pobj1ks)
ggsave("Resources/Obj1KS.png", pobj1ks, width=900, height=900, units="px")


# Objective 2: How they compare to the state trend since 2015?

# Objective 2 PSSA
ps_group_by_year_county_top = ps %>% 
  select(Year, County, Category, Scored, Students) %>%
  group_by(Year, County) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored*100, AvgScoreLabel = round(AvgScore, 2))
ps_group_by_year_county_top = calc_changes_trend_by_county(ps_group_by_year_county_top)

ps_state_bar = ps_group_by_year_county_top %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "red", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="red", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Score Average for Top Category by Years in State") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_state_bar)
ggsave("Resources/Obj2statePS.png", ps_state_bar, width=900, height=900, units="px")

ps_columbia_bar =  ps_group_by_year_county_top %>%
  filter(County == "Columbia") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "steelblue", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="steelblue", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Score Average for Top Category by Years in Columbia County") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_columbia_bar)
ggsave("Resources/Obj2columbiaPS.png", ps_columbia_bar, width=900, height=900, units="px")

ps_montour_bar = ps_group_by_year_county_top%>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "magenta", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="magenta", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Score Average for Top Category by Years in Montour County") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_montour_bar)
ggsave("Resources/Obj2montourPS.png", ps_montour_bar, width=900, height=900, units="px")

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
ks_group_by_year_county_top = ks %>% 
  select(Year, County, Category, Scored, Students) %>%
  group_by(Year, County) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored*100, AvgScoreLabel = round(AvgScore, 2))
ks_group_by_year_county_top = calc_changes_trend_by_county(ks_group_by_year_county_top)

ks_state_bar = ks_group_by_year_county_top %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "red", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="red", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Score Average for Top Category by Years in State") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_state_bar)
ggsave("Resources/Obj2stateKS.png", width = 900, height = 900)

ks_columbia_bar =  ks_group_by_year_county_top %>%
  filter(County == "Columbia") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "steelblue", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="steelblue", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Score Average for Top Category by Years in Columbia County") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_columbia_bar)
ggsave("Resources/Obj2columbiaKS.png", ks_columbia_bar, width = 900, height = 900)

ks_montour_bar = ks_group_by_year_county_top%>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "magenta", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="magenta", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Score Average for Top Category by Years in Montour County") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_montour_bar)
ggsave("Resources/Obj2montourKS.png", ks_montour_bar, width = 900, height = 900)

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

# Obj2 KS Unused
# ks_compact_combined_bar = ggplot(data = ks_group_by_year_county_top, aes(y = AvgScore, x = Year, fill = County)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "County") +
#   ggtitle("Score Average for Top Category by Years") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# ggsave("Resources/Obj2combinedKS.png", width = 900, height = 900)


# Objective 3 PSSA
ps_group_by_year_county_subject_top = ps %>%
  select(Year, County, Category, Scored, Students, Subject) %>%
  group_by(Year, County, Subject) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored*100, AvgScoreLabel = round(AvgScore, 2))
ps_state_subjects = calc_changes_trend_by_subject(ps_group_by_year_county_subject_top %>% filter(County == "State"))
ps_columbia_subjects = calc_changes_trend_by_subject(ps_group_by_year_county_subject_top %>% filter(County == "Columbia"))
ps_montour_subjects = calc_changes_trend_by_subject(ps_group_by_year_county_subject_top %>% filter(County == "Montour"))

# Objective 3 State
ps_state_subject_top_english = ps_state_subjects %>%
  filter(Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "red", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="red", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Pennsylvania for English") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_state_subject_top_english)
ggsave("Resources/Obj3stateEngPS.png", ps_state_subject_top_english, width = 900, height = 900)

ps_state_subject_top_math = ps_state_subjects %>%
  filter(Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "red", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="red", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Pennsylvania for Math") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_state_subject_top_math)
ggsave("Resources/Obj3stateMathPS.png", ps_state_subject_top_math, width = 900, height = 900)

ps_state_subject_top_science = ps_state_subjects %>%
  filter(Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "red", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="red", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Pennsylvania for Science") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_state_subject_top_science)
ggsave("Resources/Obj3stateSciencePS.png", ps_state_subject_top_science, width = 900, height = 900)



# Objective 3 Columbia

png(filename = "Obj3columbiaEngPS.png", width = 900, height = 900)

ps_columbia_subject_top_english = ps_columbia_subjects %>%
  filter(Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "steelblue", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="steelblue", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Columbia county for English") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_columbia_subject_top_english)


png(filename = "Obj3columbiaMathPS.png", width = 900, height = 900)

ps_columbia_subject_top_math = ps_columbia_subjects %>%
  filter(Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "steelblue", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="steelblue", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Columbia county for Math") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_columbia_subject_top_math)

png(filename = "Obj3columbiaSciencePS.png", width = 900, height = 900)

ps_columbia_subject_top_science = ps_columbia_subjects %>%
  filter(Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "steelblue", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="steelblue", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Columbia county for Science") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_columbia_subject_top_science)

# Objective 3 Montour

png(filename = "Obj3montourEngPS.png", width = 900, height = 900)

ps_montour_subject_top_english = ps_montour_subjects %>%
  filter(County == "Montour" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "magenta", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="magenta", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Montour county for English") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_montour_subject_top_english)

png(filename = "Obj3montourMathPS.png", width = 900, height = 900)

ps_montour_subject_top_math = ps_montour_subjects %>%
  filter(County == "Montour" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "magenta", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="magenta", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Montour county for Math") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_montour_subject_top_math)

png(filename = "Obj3montourSciPS.png", width = 900, height = 900)

ps_montour_subject_top_science = ps_montour_subjects %>%
  filter(County == "Montour" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "magenta", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="magenta", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Montour county for Science") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ps_montour_subject_top_science)



# Objective 3 Keystone
ks_group_by_year_county_subject_top = ks %>%
  select(Year, County, Category, Scored, Students, Subject) %>%
  group_by(Year, County, Subject) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored*100, AvgScoreLabel = round(AvgScore, 2))
ks_state_subjects = calc_changes_trend_by_subject(ks_group_by_year_county_subject_top %>% filter(County == "State"))
ks_columbia_subjects = calc_changes_trend_by_subject(ks_group_by_year_county_subject_top %>% filter(County == "Columbia"))
ks_montour_subjects = calc_changes_trend_by_subject(ks_group_by_year_county_subject_top %>% filter(County == "Montour"))

# Objective 3 State
ks_state_subject_top_english = ks_state_subjects %>%
  filter(Subject == "English") %>%
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "red", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="red", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Pennsylvania for English") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_state_subject_top_english)

ggsave("Resources/Obj3stateEngKS.png", width = 900, height = 900)

png(filename = "Obj3stateMathKS.png", width = 900, height = 900)

ks_state_subject_top_math = ks_state_subjects %>%
  filter(Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "red", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="red", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Pennsylvania for Math") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_state_subject_top_math)

ggsave()

png(filename = "Obj3stateScienceKS.png", width = 900, height = 900)

ks_state_subject_top_science = ks_state_subjects %>%
  filter(Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "red", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="red", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Pennsylvania for Science") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_state_subject_top_science)

ggsave()





# Columbia
png(filename = "Obj3columbiaEngKS.png", width = 900, height = 900)

ks_columbia_subject_top_english = ks_columbia_subjects %>%
  filter(County == "Columbia" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "steelblue", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="steelblue", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Columbia county for English") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_columbia_subject_top_english)

png(filename = "Obj3columbiaMathKS.png", width = 900, height = 900)

ks_columbia_subject_top_math = ks_columbia_subjects %>%
  filter(County == "Columbia" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "steelblue", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="steelblue", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Columbia county for Math") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_columbia_subject_top_math)

ggsave()

png(filename = "Obj3columbiaScienceKS.png", width = 900, height = 900)

ks_columbia_subject_top_science = ks_columbia_subjects %>%
  filter(County == "Columbia" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "steelblue", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="steelblue", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Columbia county for Science") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_columbia_subject_top_science)

ggsave()



png(filename = "Obj3montourEngKS.png", width = 900, height = 900)

ks_montour_subject_top_english = ks_montour_subjects %>%
  filter(County == "Montour" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "magenta", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="magenta", color="white") +
  geom_label(aes(x=Year, y=25 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=25 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Montour county for English") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_montour_subject_top_english)

png(filename = "Obj3montourMathKS.png", width = 900, height = 900)

ks_montour_subject_top_math = ks_montour_subjects %>%
  filter(County == "Montour" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "magenta", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="magenta", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Montour county for Math") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_montour_subject_top_math)

png(filename = "Obj3montourSciKS.png", width = 900, height = 900)

ks_montour_subject_top_science = ks_montour_subjects %>%
  filter(County == "Montour" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_col(position="dodge", fill = "magenta", width=0.4) +
  geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill="magenta", color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  ggtitle("Top Average Scores in Montour county for Science") +
  xlab("Years") + 
  ylab("Average Score in %")
plot(ks_montour_subject_top_science)


# ANOVA analysis PSSA
ps_anova = aov(Score ~ Year + as_factor(County) + as_factor(District) + 
                 as_factor(School) + as_factor(Subject) + Scored +
                 as_factor(Category) + Score + Students, data = ps)
summary(ps_anova)

# ANOVA analysis Keystone
ks_anova = aov(Score ~ Year + as_factor(County) + as_factor(District) + 
                 as_factor(School) + as_factor(Subject) + Scored +
                 as_factor(Category) + Score + Students, data = ks)
summary(ks_anova)

# Objective 3: Is there any COVID impact we might be able to deduce?

#-------------------------------------------------------------------------

# When we look at both Keystone and PSSA data, we can clearly see that, COVID-19
# has impacted top score average percentages. Especially in 2021, we see a sharp
# decline in all levels (State, Colombia County and Montour County). However,
# starting 2022, we see some recovery in percentages in those levels. 

# However, there's no linearity between years and average score percentages so as
# to say, we don't see an upward or downward trend every year. 
# The ANOVA table also indicates the absence of linearity in trend without
# any significant impact between top score average percentages and year.

#------------------------------------------------------------------------------




# Objective 4: Visualizing the averages of scores from each year.
# Objective 4a. Grouped by subject.
#Keystone
obj4bksa = ks %>%
  filter( Category == "Top") %>%
  group_by(Year, Subject) %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore=Students/Scored*100, AvgScoreLabel=round(AvgScore,2))
obj4bksa = calc_changes_trend_by_subject(obj4bksa)
pobj4bksa = obj4bksa %>%
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_col(position = position_dodge(0.9), width=0.9) +
  geom_label(aes(x=Year, y=AvgScore-1.5, label = AvgScoreLabel), position = position_dodge(0.9), color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  labs(title = "Keystone Top Yearly Testing Averages By Subject")+
  xlab("Years") + 
  ylab("Cumulative Average Score (%)")
plot(pobj4bksa)

#PSSA
obj4bpsa = ps %>%
  filter(Category == "Top") %>%
  group_by(Year, Subject) %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore=Students/Scored*100, AvgScoreLabel=round(AvgScore,2))
obj4bpsa = calc_changes_trend_by_subject(obj4bpsa)
pobj4bpsa = obj4bpsa %>%
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_col(position = position_dodge(0.9), width=0.9) +
  geom_label(aes(x=Year, y=AvgScore-1.5, label = AvgScoreLabel), position = position_dodge(0.9), color="white") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangePos), position = position_dodge2(0.9), color="green", fill="darkblue") +
  geom_label(aes(x=Year, y=20 , label = AvgScoreChangeNeg), position = position_dodge2(0.9), color="red", fill="darkblue") +
  labs(title = "PSSA Top Yearly Testing Averages By Subject")+
  xlab("Years") + 
  ylab("Cumulative Average Score (%)")
plot(pobj4bpsa)

# Objective 4b. Grouped by district.

#Keystone
obj4cksa = ks %>%
  filter(County!= "State" & Category == "Top") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)*100, AvgScoreLabel=round(AvgScore,0)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Top Keystone Yearly Testing Averages by District")+
  xlab("Years") + 
  ylab("Cumulative Average Score (%)")
plot(obj4cksa)

#PSSA
obj4cpsa = ps %>%
  filter(County!= "State" & Category == "Top") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)*100, AvgScoreLabel=round(AvgScore,2)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Top PSSA Yearly Testing Averages by District")+
  xlab("Years") + 
  ylab("Cumulative Average Score (%)")
plot(obj4cpsa)

# Objective 5: Compare scores between districts

#Keystone
obj4cksa = ks %>%
  filter(District!= "State" & Category == "Top") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)*100, AvgScoreLabel=round(AvgScore,0)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = position_dodge(0.9)) +
  geom_text(aes(x=Year, y=AvgScore+.5, label = AvgScoreLabel),angle=45,color= "white", position = position_dodge(0.9)) +
  labs(title = "Keystone Top Yearly Testing Averages by District")+
  xlab("Years") + 
  ylab("Cumulative Average Score (%)")
plot(obj4cksa)

#PSSA
obj4cpsa = ps %>%
  filter(District!= "State" & Category == "Top") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)*100, AvgScoreLabel=round(AvgScore,0)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = position_dodge(0.9)) +
  geom_text(aes(x=Year, y=AvgScore+.5, label = AvgScoreLabel),angle=45,color= "white", position = position_dodge(0.9))+
  labs(title = "PSSA Top Yearly Testing Averages by District")+
  xlab("Years") + 
  ylab("Cumulative Average Score (%)")
plot(obj4cpsa)


# Objective 6: Study Cohorts

# Cohorts Local Level
#             |<------PSSA----->|
#                               |<---Keystone--->|
#          2016, 2017, 2018, 2019, 2020, 2021, 2022
# Cohort 1    8                11
# No 2020
# Cohort 2    6     7     8                11
# Cohort 3    5     6     7     8                11


# Cohorts Timeline
cohorts_timeline = cohorts %>% 
  ggplot() + 
  geom_rect(aes(xmin = Year, xmax = Year + 1, ymin = Cohort-0.5, ymax = Cohort, fill = Grade)) +
  geom_text(aes(x = Year, y = Cohort, label = "")) +
  theme(
    axis.text.y = element_text(vjust=2)
  ) +
  labs(title = "Cohorts Timeline")
plot(cohorts_timeline)
ggsave("Resources/Obj6_timeline.png", cohorts_timeline)

# Cohorts Plot Function
plot_cohorts = function(cas, title, filename){
  cas1 = cas %>% filter(Cohort==1)
  cas1$AvgScoreChange = round(cas1$AvgScore-lag(cas1$AvgScore), 2)
  cas2 = cas %>% filter(Cohort==2)
  cas2$AvgScoreChange = round(cas2$AvgScore-lag(cas2$AvgScore), 2)
  cas3 = cas %>% filter(Cohort==3)
  cas3$AvgScoreChange = round(cas3$AvgScore-lag(cas3$AvgScore), 2)
  cas = rbind(cas1, cas2, cas3)
  rm(cas1)
  rm(cas2)
  rm(cas3)
  cas$AvgScoreChangePos = cas$AvgScoreChange
  cas$AvgScoreChangePos[cas$AvgScoreChangePos < 0] = NA
  cas$AvgScoreChangeNeg = cas$AvgScoreChange
  cas$AvgScoreChangeNeg[cas$AvgScoreChangeNeg > 0] = NA
  pcas = cas %>%
    ggplot(aes(x=Grade, y=AvgScore, fill=Grade)) +
    geom_col(position="dodge") +
    geom_label(aes(x=Grade, y=AvgScore-1.5 , label = AvgScoreLabel), color="white") +
    geom_label(aes(x=Grade, y=20 , label = AvgScoreChangePos), color="green", fill="darkblue") +
    geom_label(aes(x=Grade, y=20 , label = AvgScoreChangeNeg), color="red", fill="darkblue") +
    facet_wrap(~Cohort, labeller=labeller(Cohort=c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
    labs(title=title) +
    xlab("Grade") + 
    ylab("Cumulative Average Score (%)")
  plot(pcas)
}

# Objective 6b State
cas_state = cohorts %>%
  filter(Category=="Top" & County == "State") %>%
  select(Cohort, Grade, Students, Scored) %>%
  group_by(Cohort, Grade) %>%
  mutate(
    AvgScore = sum(Students)/sum(Scored) * 100,
    AvgScoreLabel = round(AvgScore, 2)
  ) %>% 
  select(-Students, -Scored) %>%
  distinct()
plot_cohorts(cas_state, "Cohorts State Level")
ggsave("Resources/Obj6b_state.png", pcas, width=900, height=900, units="px")

# Objective 6b Columbia county
cas_columbia = cohorts %>%
  filter(Category=="Top" & County == "Columbia") %>%
  select(Cohort, Grade, Students, Scored) %>%
  group_by(Cohort, Grade) %>%
  mutate(
    AvgScore = sum(Students)/sum(Scored) * 100,
    AvgScoreLabel = round(AvgScore, 2)
  ) %>% 
  select(-Students, -Scored) %>%
  distinct()
plot_cohorts(cas_columbia, "Cohorts Columbia Level")
ggsave("Resources/Obj6b_columbia.png", pcas, width=900, height=900, units="px")

# Objective 6b Montour county
cas_montour = cohorts %>%
  filter(Category=="Top" & County == "Montour") %>%
  select(Cohort, Grade, Students, Scored) %>%
  group_by(Cohort, Grade) %>%
  mutate(
    AvgScore = sum(Students)/sum(Scored) * 100,
    AvgScoreLabel = round(AvgScore, 2)
  ) %>% 
  select(-Students, -Scored) %>%
  distinct()
plot_cohorts(cas_montour, "Cohorts Montour Level")
ggsave("Resources/Obj6b_montour.png", pcas, width=900, height=900, units="px")




# Unused Graphs

# Obj2 PS unused
# ps_compact_combined_bar = ggplot(data = ps_group_by_year_county_top, aes(y = AvgScore, x = Year, fill = County)) + 
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "County") +
#   ggtitle("Score Average for Top Category by Years") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# ggsave("Resources/Obj2combinedPS.png", ps_compact_combined_bar, width = 1280, height = 1280)


# Obj2 KS unused
# png(filename = "Obj3montourCombKS.png", width = 900, height = 900)
# 
# ks_montour_subject_top_compact = ks_group_by_year_county_subject_top %>%
#   filter(County == "Montour") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "Subject") + 
#   ggtitle("Average Score of Top Category in Montour County by Subjects") +
#   xlab("Years") + 
#   ylab("Average Score in %")


# Obj3 ps unused
# unused
# ps_state_subject_top_compact = ps_group_by_year_county_subject_top %>%
#   filter(County == "State") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "Subject") + 
#   ggtitle("Average Score of Top Category in State by Subjects") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# ggsave("Obj3stateCombPS.png", ps_state_subject_top_compact, width = 900, height = 900)

# png(filename = "Obj3columbiaCombPS.png", width = 900, height = 900)
# 
# ps_columbia_subject_top_compact = ps_group_by_year_county_subject_top %>%
#   filter(County == "Columbia") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "Subject") + 
#   ggtitle("Average Score of Top Category in Columbia County by Subjects") +
#   xlab("Years") + 
#   ylab("Average Score in %")

# png(filename = "Obj3montourCombPS.png", width = 900, height = 900)
# 
# ps_montour_subject_top_compact = ps_group_by_year_county_subject_top %>%
#   filter(County == "Montour") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "Subject") + 
#   ggtitle("Average Score of Top Category in Montour County by Subjects") +
#   xlab("Years") + 
#   ylab("Average Score in %")

# png(filename = "Obj3stateCombKS.png", width = 900, height = 900)
# 
# ks_state_subject_top_compact = ks_group_by_year_county_subject_top %>%
#   filter(County == "State") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "Subject") + 
#   ggtitle("Average Score of Top Category in State by Subjects") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# ggsave()

# png(filename = "Obj3columbiaCombKS.png", width = 900, height = 900)
# 
# ks_columbia_subject_top_compact = ks_group_by_year_county_subject_top %>%
#   filter(County == "Columbia") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "Subject") + 
#   ggtitle("Average Score of Top Category in Columbia County by Subjects") +
#   xlab("Years") + 
#   ylab("Average Score in %")



# #granular graphs ps
# 
# ps_group_by_year_county_subject_school_top = ps %>% 
#   select(Year, County, School, Category, Scored, Students, Subject) %>%
#   group_by(Year, County, Subject, School) %>%
#   filter(Category == "Top") %>%
#   summarise(across(c(Scored, Students), sum)) %>%
#   mutate(AvgScore = Students/Scored,
#          AvgScoreLabel = round(AvgScore, 2))
# 
# 
# png(filename = "Misc1PS.png", width = 900, height = 900)
# 
# ps_columbia_top_school_english = ps_group_by_year_county_subject_school_top %>%
#   filter(County == "Columbia" & Subject == "English") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = School)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "School") + 
#   ggtitle("Average Score of Top Category in Columbia County Schools (English)") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# 
# ps_columbia_top_school_english
# 
# dev.off()
# 
# png(filename = "Misc2PS.png", width = 900, height = 900)
# 
# ps_columbia_top_school_math = ps_group_by_year_county_subject_school_top %>%
#   filter(County == "Columbia" & Subject == "Math") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = School)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "School") + 
#   ggtitle("Average Score of Top Category in Columbia County Schools (Math)") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# 
# ps_columbia_top_school_math
# 
# dev.off()
# 
# png(filename = "Misc3PS.png", width = 900, height = 900)
# 
# ps_columbia_top_school_science = ps_group_by_year_county_subject_school_top %>%
#   filter(County == "Columbia" & Subject == "Science") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = School)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "School") + 
#   ggtitle("Average Score of Top Category in Columbia County Schools (Science)") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# 
# ps_columbia_top_school_science
# 
# dev.off()
# 
# png(filename = "Misc4PS.png", width = 900, height = 900)
# 
# ps_columbia_top_school_subjects_compact = ps_group_by_year_county_subject_school_top %>%
#   filter(County == "Columbia") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = School)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "School") +
#   facet_wrap(~Subject) +
#   ggtitle("Average Score of Top Category in Columbia County Schools (All Subjects)") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# 
# ps_columbia_top_school_subjects_compact
# 
# dev.off()



# 
# #granular graphs ks
# 
# ks_group_by_year_county_subject_school_top = ks %>% 
#   select(Year, County, School, Category, Scored, Students, Subject) %>%
#   group_by(Year, County, Subject, School) %>%
#   filter(Category == "Top") %>%
#   summarise(across(c(Scored, Students), sum)) %>%
#   mutate(AvgScore = Students/Scored,
#          AvgScoreLabel = round(AvgScore, 2))
# 
# png(filename = "Misc1KS.png", width = 900, height = 900)
# 
# ks_columbia_top_school_english = ks_group_by_year_county_subject_school_top %>%
#   filter(County == "Columbia" & Subject == "English") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = School)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "School") + 
#   ggtitle("Average Score of Top Category in Columbia County Schools (English)") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# 
# ks_columbia_top_school_english
# 
# dev.off()
# 
# png(filename = "Misc2KS.png", width = 900, height = 900)
# 
# ks_columbia_top_school_math = ks_group_by_year_county_subject_school_top %>%
#   filter(County == "Columbia" & Subject == "Math") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = School)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "School") + 
#   ggtitle("Average Score of Top Category in Columbia County Schools (Math)") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# 
# ks_columbia_top_school_math
# 
# dev.off()
# 
# png(filename = "Misc3KS.png", width = 900, height = 900)
# 
# ks_columbia_top_school_science = ks_group_by_year_county_subject_school_top %>%
#   filter(County == "Columbia" & Subject == "Science") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = School)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "School") + 
#   ggtitle("Average Score of Top Category in Columbia County Schools (Science)") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# 
# ks_columbia_top_school_science
# 
# dev.off()
# 
# png(filename = "Misc4KS.png", width = 900, height = 900)
# 
# ks_columbia_top_school_subjects_compact = ks_group_by_year_county_subject_school_top %>%
#   filter(County == "Columbia") %>% 
#   ggplot(aes(x = Year, y = AvgScore, fill = School)) +
#   geom_bar(position="dodge", stat="identity") +
#   scale_fill_discrete(name = "School") +
#   facet_wrap(~Subject) +
#   ggtitle("Average Score of Top Category in Columbia County Schools (All Subjects)") +
#   xlab("Years") + 
#   ylab("Average Score in %")
# 
# ks_columbia_top_school_subjects_compact
# 
# dev.off()

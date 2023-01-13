# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel
# @project: State Testing Analysis
# @file:    analysis.R
# @desc:    Analysis of testing data

library(tidyverse)
library(ggplot2)
library(GGally)
library(hrbrthemes)
library(patchwork)
library(ggthemes)

theme_main = function(base_size=11, base_family=""){
  theme(
    plot.background = element_rect(fill="black"),
    plot.title = element_text(color="white", size=12, face="bold"),
    panel.background = element_rect(fill="darkblue", color="darkblue", linetype="solid"),
    strip.background = element_rect(fill="steelblue"),
    strip.text = element_text(color="white", face = "bold"),
    legend.background = element_rect(fill="black"),
    legend.text = element_text(color="white"),
    legend.title = element_text(color="white"),
    panel.grid.major = element_line(color="white", linetype="solid"),
    panel.grid.minor = element_line(color="white", linetype="solid"),
    panel.border = element_rect(color="darkblue", fill = NA),
    axis.line = element_line(color="darkblue"),
    axis.ticks = element_line(color="darkblue"),
    axis.text = element_text(color="white"),
    axis.text.x = element_text(color="white"),
    axis.text.y = element_text(color="white"),
    axis.title.x = element_text(color="white", face="bold", vjust=-2),
    axis.title.y = element_text(color="white", face="bold", angle=90, vjust=3)
  )
}

theme_set(theme_main())

ks = read_csv("Keystone/keystone.csv")
ps = read_csv("PSSA/pssa.csv")
cohorts = read_csv("Cohorts/cohorts.csv")

# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2015?
ks %>% group_by(County) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks
p11 = ggplot(data = ks, aes(x = County, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p11)


ps %>% group_by(County) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps
p12 = ggplot(data = ps, aes(x = County, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p12)

# Objective 2: How they compare to the state trend since 2015?


ks$County = as_factor(ks$County)
str(ks$County)
levels(ks$County) = c("State", "Colombia", "Montour")
levels(ks$County)


group_by_year_county_top = ks %>% 
  select(Year, County, Category, Scored, Students) %>%
  group_by(Year, County) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored)

group_by_year_county_top


group_by_year_state_subject_top = ks %>%
  select(Year, County, Category, Scored, Students, Subject) %>%
  group_by(Year, County, Subject) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored)

group_by_year_state_subject_top


group_by_year_county_subject_school_top = ks %>% 
  select(Year, County, School, Category, Scored, Students, Subject) %>%
  group_by(Year, County, Subject, School) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored)

group_by_year_county_subject_school_top


png(filename = "Obj2state.png", width = 1280, height = 1280)

state_bar = group_by_year_county_top %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "County") + 
  ggtitle("Score Average for Top Category by Years in State") +
  xlab("Years") + 
  ylab("Average Score in %")

state_bar

dev.off()

png(filename = "Obj2colombia.png", width = 1280, height = 1280)

colombia_bar =  group_by_year_county_top %>%
  filter(County == "Colombia") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years in Colombia County") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_bar

dev.off()

png(filename = "Obj2montour.png", width = 1280, height = 1280)

montour_bar = group_by_year_county_top%>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years in Montour County") +
  xlab("Years") + 
  ylab("Average Score in %")

montour_bar

dev.off()

png(filename = "Obj2combined.png", width = 1280, height = 1280)

compact_combined_bar = ggplot(data = group_by_year_county_top, aes(y = AvgScore, x = Year, fill = County)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years") +
  xlab("Years") + 
  ylab("Average Score in %")


compact_combined_bar

dev.off()



#anova analysis

anova = aov(Score ~ Year + as_factor(County) + as_factor(District) + 
              as_factor(School) + as_factor(Subject) + Scored +
              as_factor(Category) + Score + Students, data = ks)
summary(anova)

model = glm(Score ~ Year + as_factor(County) + as_factor(District) + 
              as_factor(School) + as_factor(Subject) + Scored +
              as_factor(Category) + Score + Students, data = ks)
summary(model)






# We see that in general, Montour and Colombia county fared better than State 
# since 2015 in terms of Category levels. Basic level showed a sharp increase in Montour
# and Colombia counties in 2022. Proficient level also showed a sharp
# increase especially in 2022 for Montour county

# Top Category showed a slight decline between 2019 - 2021 in State and Colombia County.
# Top Category remained steady in Montour throughout the time frame. 

# Advanced Category showed a sharp decline in Colombia County and State from 2019
# to 2021. Montour County Category were pretty much stable.

# Proficient Category showed an increase in Colombia County in 2021 and then
# it swung back to its previous levels in 2022. State and Montour County fluctuated
# slightly throughout the time frame without any significant observation.

# Basic Category  dropped slightly in Colombia county from 2018 to 2019. It remained
# steady in State from 2017 to 2019. Montour County showed a slight decline
# in 2019. Basic Category increased in both counties and state in 2021, only to
# drop slightly in Montour County and State in 2022. Colombia County showed
# a moderate decline in Basic Category. 

# BelowBasic Category remained stable for Montour County until 2019. There was a
# sharp increase between 2016 and 2017 in Colombia County and State. Both
# counties and state showed a decline in BelowBasic Category in 2019. There was
# a significant increase in all places in the Category from 2019 to 2021,
# especially in Colombia. From 2021 to 2022, Category remained stable in State 
# and dropped moderately in both counties



# Objective 3: Is there any COVID impact we might be able to deduce?


# Checking Category averages throughout the years for counties and subjects, it
# is interesting to see that COVID didn't impact Math and English for Categorys
# dramatically for Colombia, Montour and State. In fact, there was a significant
# improvement in the scores in 2022 compared to 2019 for math top, advanced
# and proficient Category in Colombia county.
# However, there was a steep decline in Science for Categorys between 2021
# and 2022 throughout the state which may be an indication of a COVID impact.

png(filename = "Obj3stateEng.png", width = 1280, height = 1280)

state_subject_top_english = group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

state_subject_top_english

dev.off()

png(filename = "Obj3stateMath.png", width = 1280, height = 1280)

state_subject_top_math = group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

state_subject_top_math

dev.off()

png(filename = "Obj3state.science", width = 1280, height = 1280)

state_subject_top_science = group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (Science") +
  xlab("Years") + 
  ylab("Average Score in %")

state_subject_top_science

dev.off()

png(filename = "Obj3stateComb.png", width = 1280, height = 1280)

state_subject_top_compact = group_by_year_state_subject_top %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

state_subject_top_compact

dev.off()

png(filename = "Obj3colombiaEng.png", width = 1280, height = 1280)

colombia_subject_top_english = group_by_year_state_subject_top %>%
  filter(County == "Colombia" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Colombia County by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_subject_top_english

dev.off()
png(filename = "Obj3colombiaMath.png", width = 1280, height = 1280)

colombia_subject_top_math = group_by_year_state_subject_top %>%
  filter(County == "Colombia" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Colombia County by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_subject_top_math

dev.off()

png(filename = "Obj3colombiaScience.png", width = 1280, height = 1280)

colombia_subject_top_science = group_by_year_state_subject_top %>%
  filter(County == "Colombia" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Colombia County by Subject (Science") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_subject_top_science

dev.off()

png(filename = "Obj3colombiaComb.png", width = 1280, height = 1280)

colombia_subject_top_compact = group_by_year_state_subject_top %>%
  filter(County == "Colombia") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Colombia County by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_subject_top_compact

dev.off()

png(filename = "Obj3montourEng.png", width = 1280, height = 1280)

montour_subject_top_english = group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

montour_subject_top_english

dev.off()

png(filename = "Obj3montourMath.png", width = 1280, height = 1280)

montour_subject_top_math = group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

montour_subject_top_math

dev.off()

png(filename = "Obj3montourSci.png", width = 1280, height = 1280)

montour_subject_top_science = group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (Science") +
  xlab("Years") + 
  ylab("Average Score in %")

montour_subject_top_science

dev.off()

png(filename = "Obj3montourComb.png", width = 1280, height = 1280)

montour_subject_top_compact = group_by_year_state_subject_top %>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

montour_subject_top_compact

dev.off()

#granular graphs

png(filename = "Misc1.png", width = 1280, height = 1280)

colombia_top_school_english = group_by_year_county_subject_school_top %>%
  filter(County == "Colombia" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Colombia County Schools (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_top_school_english

dev.off()

png(filename = "Misc2.png", width = 1280, height = 1280)

colombia_top_school_math = group_by_year_county_subject_school_top %>%
  filter(County == "Colombia" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Colombia County Schools (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_top_school_math

dev.off()

png(filename = "Misc3.png", width = 1280, height = 1280)

colombia_top_school_science = group_by_year_county_subject_school_top %>%
  filter(County == "Colombia" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Colombia County Schools (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_top_school_science

dev.off()

png(filename = "Misc4.png", width = 1280, height = 1280)

colombia_top_school_subjects_compact = group_by_year_county_subject_school_top %>%
  filter(County == "Colombia") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") +
  facet_wrap(~Subject) +
  ggtitle("Average Score of Top Category in Colombia County Schools (All Subjects)") +
  xlab("Years") + 
  ylab("Average Score in %")

colombia_top_school_subjects_compact

dev.off()


# From 2019 to 2022, Category levels seemed stable for the counties and the state
# There were only slight fluctuations which were inconclusive if COVID affected
# Category levels or not.



# Objective 4: Visualizing the averages of scores from each year.
# Objective 4a. As a whole.

ks %>% group_by(Year) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks

p3 = ggplot(data = ks, aes(x = Year, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p3)


ps %>% group_by(Year) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps
p4 = ggplot(data = ps, aes(x = Year, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p4)

# Objective 4b. Grouped by subject.
ks %>% group_by(Subject) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks
p5 = ggplot(data = ks, aes(x = Subject, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p5)


ps %>% group_by(Subject) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps

p6 = ggplot(data = ps, aes(x = Subject, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p6)

# Objective 4c. Grouped by district.

ks %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks
p7 = ggplot(data = ks, aes(x = District, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p7)


ps %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps

p8 = ggplot(data = ps, aes(x = District, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p8)

# Objective 5: Compare scores between districts.
ks %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks

p9 = ggplot(data = ks, aes(x = Score, y = District)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p9)


ps %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps
p10 = ggplot(data = ps, aes(x = Score, y = District)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Category))
plot(p10)


# Objective 6: Study Cohorts

# Cohorts Local Level
#             |<------PSSA----->|
#                               |<---Keystone--->|
#          2016, 2017, 2018, 2019, 2020, 2021, 2022
# Cohort 1    8                11
# No 2020
# Cohort 2    6     7     8                11
# Cohort 3    5     6     7     8                11

# prepare columns
cohorts$Cohort = as.integer(cohorts$Cohort)
cohorts$Grade = as_factor(cohorts$Grade)
cohorts$Category = as_factor(cohorts$Category)

# cohorts timeline
cohorts_timeline = cohorts %>% 
  ggplot() + 
  geom_rect(aes(xmin = Year, xmax = Year + 1, ymin = Cohort-0.5, ymax = Cohort, fill = Grade)) +
  geom_text(aes(x = Year, y = Cohort, label = "")) +
  theme(
    axis.text.y = element_text(vjust=4)
  ) +
  labs(title = "Cohorts Timeline")
plot(cohorts_timeline)
ggsave("Resources/Obj6_timeline.png", cohorts_timeline)


# average scores by cohort and grade
cas = cohorts %>%
  filter(Category=="Top") %>%
  select(Cohort, Grade, Students, Scored) %>%
  group_by(Cohort, Grade) %>%
  mutate(
    AvgScore = sum(Students)/sum(Scored) * 100,
    AvgScoreLabel = round(AvgScore, 2)
  ) %>% 
  select(-Students, -Scored) %>%
  distinct()

# get change for each cohort
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

# graph cas
obj6bc1t = cas %>%
  ggplot(aes(x=Grade, y=AvgScore, fill=Grade)) +
  geom_col(position="dodge") +
  geom_text(aes(x=Grade, y=AvgScore-1, label=AvgScoreLabel), color="white") +
  geom_text(aes(x=Grade, y=20, label=AvgScoreChangePos), color="green") +
  geom_text(aes(x=Grade, y=20, label=AvgScoreChangeNeg), color="red") +
  facet_wrap(~Cohort, labeller=labeller(Cohort=c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
  labs(title="Cohorts 1-3 All Grades Top Scores")
plot(obj6bc1t)
ggsave("Resources/Obj6a_cohort_grade.png", obj6bc1t)

# Objective 7: Any other information that data might tell us? Summary.


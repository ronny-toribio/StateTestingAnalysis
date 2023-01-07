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
    plot.title = element_text(color="white")
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
  facet_wrap(~ as_factor(Baseline))
plot(p11)


ps %>% group_by(County) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps
p12 = ggplot(data = ps, aes(x = County, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p12)

# Objective 2: How they compare to the state trend since 2015?


ks$County = as_factor(ks$County)
str(ks$County)
levels(ks$County) = c("State", "Colombia", "Montour")
levels(ks$County)


group_by_year_county = ks %>% 
  group_by(Year, County) %>%
  summarise(across(c(Scored, WScore), sum)) %>%
  mutate(WAvg = WScore/Scored)

group_by_year_county


group_by_year_county_baseline = ks %>% 
  group_by(Year, County, Baseline) %>%
  summarise(across(c(Scored, WScore), sum)) %>%
  mutate(WAvg = WScore/Scored)

group_by_year_county_baseline


group_by_year_county_baseline_subject = ks %>%
  group_by(Year, County, Baseline, Subject) %>%
  summarize(across(c(Scored, WScore), sum)) %>%
  mutate(WAvg = WScore/Scored)

group_by_year_county_baseline_subject

group_by_year_county_baseline_subject_school = ks %>%
  group_by(Year, County, Baseline, Subject, School) %>%
  summarize(across(c(Scored, WScore), sum)) %>%
  mutate(WAvg = WScore/Scored)

group_by_year_county_baseline_subject_school

state_bar = group_by_year_county %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = WAvg, fill = County)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "County") + 
  ggtitle("WAvg by Years in State")

state_bar


colombia_bar =  group_by_year_county %>%
  filter(County == "Colombia") %>% 
  ggplot(aes(x = Year, y = WAvg, fill = County)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "County") +
  ggtitle("WAvg by Years in Colombia County")

colombia_bar

montour_bar =  group_by_year_county %>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = WAvg, fill = County)) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "County") +
  ggtitle("WAvg by Years in Montour County")

montour_bar


combined_bar = state_bar + colombia_bar + montour_bar
combined_bar


compact_combined_bar = ggplot(data = group_by_year_county, aes(y = WAvg, x = Year, fill = as_factor(County))) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "County") +
  ggtitle("WAvg by Years in State, Colombia County and Montour County") 

compact_combined_bar


state_top = group_by_year_county_baseline %>%
  filter(County == "State" & Baseline == "Top") %>% 
  ggplot(aes(x = Year, y = WAvg, fill = as_factor(Baseline))) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Baseline") + 
  ggtitle("WAvg of Top Baseline by Years in State") 

state_top


colombia_top = group_by_year_county_baseline %>%
  filter(County == "Colombia" & Baseline == "Top") %>% 
  ggplot(aes(x = Year, y = WAvg, fill = as_factor(Baseline))) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Baseline") + 
  ggtitle("WAvg of Top Baseline by Years in Colombia")

colombia_top

montour_top = group_by_year_county_baseline %>%
  filter(County == "Montour" & Baseline == "Top") %>% 
  ggplot(aes(x = Year, y = WAvg, fill = as_factor(Baseline))) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Baseline") + 
  ggtitle("WAvg of Top Baseline by Years in Montour") 

montour_top

combined_top = state_top + colombia_top + montour_top
combined_top

compact_combined_top = ggplot(data = group_by_year_county_baseline %>% 
                                filter(Baseline == "Top"), 
                              aes(y = WAvg, x = Year, fill = as_factor(County))) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "County") +
  ggtitle("WAvg of Top Baseline in State, Colombia County and Montour County") 

compact_combined_top

all_baselines_by_county = ggplot(data = group_by_year_county_baseline, 
                                 aes(y = WAvg, x = County, fill = as_factor(Baseline))) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Baseline") +
  facet_wrap(~Year, ncol = 3) +
  ggtitle("WAvg by Baseline in State, Colombia County and Montour County")

all_baselines_by_county


colombia_subject_wg_top = group_by_year_county_baseline_subject_school %>%
  filter(County == "Colombia" & Baseline == "Top") %>% 
  ggplot(aes(x = Subject, y = WAvg, fill = as_factor(Baseline))) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Baseline") + 
  facet_wrap(~Year) +
  ggtitle("WAvg of Top Baseline in Colombia by Subjects") 

colombia_subject_wg_top

state_subject_wg_top = group_by_year_county_baseline_subject_school %>%
  filter(County == "State" & Baseline == "Top") %>% 
  ggplot(aes(x = Subject, y = WAvg, fill = as_factor(Baseline))) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Baseline") + 
  facet_wrap(~Year) +
  ggtitle("WAvg of Top Baseline in State by Subjects") 

state_subject_wg_top


montour_subject_wg_top = group_by_year_county_baseline_subject_school %>%
  filter(County == "Montour" & Baseline == "Top") %>% 
  ggplot(aes(x = Subject, y = WAvg, fill = as_factor(Baseline))) +
  geom_bar(position="dodge", stat="identity", fill = "green") +
  scale_fill_discrete(name = "Baseline") + 
  facet_wrap(~Year) +
  ggtitle("WAvg of Top Baseline in Montour by Subjects") 

montour_subject_wg_top

compact_subject_wg_top = ggplot(data = group_by_year_county_baseline_subject_school %>% 
                                  filter(Baseline == "Top"), 
                                aes(y = WAvg, x = Subject, fill = as_factor(County))) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "County") +
  facet_wrap(~Year) +
  ggtitle("WAvg of Top Baseline in State, Colombia County and Montour County by Subjects") 

compact_subject_wg_top

compact_subject_wg = ggplot(data = group_by_year_county_baseline_subject_school, 
                            aes(y = WAvg, x = Subject, fill = as_factor(Baseline))) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Baseline") +
  facet_wrap(~Year + County, ncol = 3) +
  ggtitle("WAvg of All Baselines in State, Colombia County and Montour County") 

compact_subject_wg

colombia_subject_wg_top_school = ggplot(data = group_by_year_county_baseline_subject_school %>%
                                          filter(Baseline == "Top" & County == "Colombia"),
                                        aes(y = WAvg, x = Subject, fill = as_factor(School))) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") +
  facet_wrap(~Year, ncol = 3) +
  ggtitle("WAvg of Top Baseline in Colombia County by School")

colombia_subject_wg_top_school




# We see that in general, Montour and Colombia county fared better than State 
# since 2015 in terms of baseline levels. Basic level showed a sharp increase in Montour
# and Colombia counties in 2022. Proficient level also showed a sharp
# increase especially in 2022 for Montour county

# Top baseline showed a slight decline between 2019 - 2021 in State and Colombia County.
# Top baseline remained steady in Montour throughout the time frame. 

# Advanced baseline showed a sharp decline in Colombia County and State from 2019
# to 2021. Montour County baseline were pretty much stable.

# Proficient baseline showed an increase in Colombia County in 2021 and then
# it swung back to its previous levels in 2022. State and Montour County fluctuated
# slightly throughout the time frame without any significant observation.

# Basic baseline  dropped slightly in Colombia county from 2018 to 2019. It remained
# steady in State from 2017 to 2019. Montour County showed a slight decline
# in 2019. Basic baseline increased in both counties and state in 2021, only to
# drop slightly in Montour County and State in 2022. Colombia County showed
# a moderate decline in Basic baseline. 

# BelowBasic baseline remained stable for Montour County until 2019. There was a
# sharp increase between 2016 and 2017 in Colombia County and State. Both
# counties and state showed a decline in BelowBasic baseline in 2019. There was
# a significant increase in all places in the baseline from 2019 to 2021,
# especially in Colombia. From 2021 to 2022, baseline remained stable in State 
# and dropped moderately in both counties



# Objective 3: Is there any COVID impact we might be able to deduce?


# Checking baseline averages throughout the years for counties and subjects, it
# is interesting to see that COVID didn't impact Math and English for baselines
# dramatically for Colombia, Montour and State. In fact, there was a significant
# improvement in the scores in 2022 compared to 2019 for math top, advanced
# and proficient baseline in Colombia county.
# However, there was a steep decline in Science for baselines between 2021
# and 2022 throughout the state which may be an indication of a COVID impact.


mps1 = aov(Score ~ as_factor(Subject) + Year + as_factor(Baseline) + 
           as_factor(District) + as_factor(School) + 
           as_factor(County), data = ks)
summary(mps1)


mps2 = glm(Score ~ as_factor(Subject) + Year + as_factor(Baseline) + 
           as_factor(District) + as_factor(School) + 
           as_factor(County), data = ks)
summary(mps2)


plot(mps1)
ggpairs(mps1)


mps3 = glm(Score ~ as_factor(Baseline) + Year, data = ks)
summary(mps3)

ps$County = as_factor(ps$County)
str(ps$County)
levels(ps$County) = c("State", "Colombia", "Montour")
levels(ps$County)


png(filename = "Obj3b.png", width = 1280, height = 1280)

p1ps = ggplot(data = ps, aes(fill = as_factor(Baseline), y = Score, x = as_factor(Subject))) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~Year + County, ncol = 3) +
  xlab("State vs Counties") +
  scale_fill_discrete(name = "Baseline")

p1ps

dev.off()


# From 2019 to 2022, baseline levels seemed stable for the counties and the state
# There were only slight fluctuations which were inconclusive if COVID affected
# baseline levels or not.



# Objective 4: Visualizing the averages of scores from each year.
# Objective 4a. As a whole.

ks %>% group_by(Year) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks

p3 = ggplot(data = ks, aes(x = Year, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p3)


ps %>% group_by(Year) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps
p4 = ggplot(data = ps, aes(x = Year, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p4)

# Objective 4b. Grouped by subject.
ks %>% group_by(Subject) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks
p5 = ggplot(data = ks, aes(x = Subject, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p5)


ps %>% group_by(Subject) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps

p6 = ggplot(data = ps, aes(x = Subject, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p6)

# Objective 4c. Grouped by district.

ks %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks
p7 = ggplot(data = ks, aes(x = District, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p7)


ps %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps

p8 = ggplot(data = ps, aes(x = District, y = Score)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p8)

# Objective 5: Compare scores between districts.
ks %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks

p9 = ggplot(data = ks, aes(x = Score, y = District)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p9)


ps %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps
p10 = ggplot(data = ps, aes(x = Score, y = District)) +
  geom_bar(stat = "identity", fill = "pink") +
  facet_wrap(~ as_factor(Baseline))
plot(p10)


# Objective 6: Study Cohorts

# Cohorts Local Level
#             |<------PSSA----------->|
#                               |<--------Keystone----->|
#          2016, 2017, 2018, 2019, 2020, 2021, 2022
# Cohort 1    8                11
# No 2020
# Cohort 2    6     7     8                11
# Cohort 3    5     6     7     8                11

cohorts %>% ggplot(aes(xmin=Year-1, xmax=Year, ymin=Cohort-1, ymax=Cohort, fill=as_factor(Grade))) + 
  geom_rect() +
  labs(title="Cohorts Timeline")

cohorts1 = cohorts %>% filter(Baseline != "Top")
cohorts1 %>% ggplot(aes(x=Grade, y=Score, fill=as_factor(Baseline))) + 
  geom_col() +
  facet_wrap(~Cohort, labeller=labeller(Cohort=c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
  labs(title="Cohorts 1-3 All Grades All Scores")

cohorts1_top = cohorts1 %>% filter(Baseline=="Advanced" | Baseline=="Proficient")
cohorts1_top %>% ggplot(aes(x=Grade, y=WScore, fill=as_factor(Baseline))) + 
  geom_col() + 
  facet_wrap(~Cohort, labeller=labeller(Cohort=c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
  labs(title="Cohorts 1-3 All Grades Top Scores")

cohorts2 = cohorts1 %>% filter(Grade==8 | Grade==11)
cohorts2 %>% ggplot(aes(x=Grade, y=WScore, fill=as_factor(Baseline))) + 
  geom_col() + 
  facet_wrap(~Cohort, labeller=labeller(Cohort=c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
  labs(title="Cohorts 1-3 Grades 8, 11 All Scores")

cohorts2_top = cohorts2 %>% filter(Baseline=="Advanced" | Baseline=="Proficient")
cohorts2_top %>% ggplot(aes(x=Grade, y=WScore, fill=as_factor(Baseline))) + 
  geom_col() + 
  facet_wrap(~Cohort, labeller=labeller(Cohort=c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
  labs(title="Cohorts 1-3 Grades 8, 11 Top Scores")

# Objective 7: Any other information that data might tell us? Summary.


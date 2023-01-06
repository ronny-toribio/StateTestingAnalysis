# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel, John Seibert
# @project: State Testing Analysis
# @file:    analysis.R
# @desc:    Analysis of testing data

library(tidyverse)
library(ggplot2)
library(GGally)
library(hrbrthemes)

theme_main = function(base_size=11, base_family=""){
  theme(
    plot.background = element_rect(fill="grey"),
    panel.background = element_rect(fill="darkblue", color="darkblue", linewidth=0.5, linetype="solid"),
    legend.background = element_rect(fill="grey"),
    panel.grid.major = element_line(color="white", linewidth=0.5, linetype="solid"),
    panel.grid.minor = element_line(color="white", linewidth=0.5, linetype="solid"),
    panel.border = element_rect(color="darkblue", fill = NA),
    axis.line = element_line(color="darkblue"),
    axis.ticks = element_line(color="darkblue"),
    axis.text = element_text(color="white")
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
m = aov(Score ~ as_factor(Baseline) + as_factor(Subject) + Year, data = ks)
summary(m)

m1 = glm(Score ~ as_factor(Baseline) + as_factor(Subject) + Year, data = ks)
summary(m1)

plot(m)
ggpairs(m)

ks$County = as_factor(ks$County)
str(ks$County)
levels(ks$County) = c("State", "Colombia", "Montour")
levels(ks$County)

png(filename = "Obj2a.png", width = 1280, height = 1280)

p = ggplot(data = ks, aes(y = Score, x = Year, fill = as_factor(County))) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~as_factor(Baseline))

p

dev.off()

# We see that in general, Montour and Colombia county fared better than State 
# since 2015 in terms of baseline levels. Basic level showed a sharp increase in Montour
# and Colombia counties in 2022. Proficient level also showed a sharp
# increase especially in 2022 for Montour county


mps = aov(Score ~ as_factor(Baseline) + as_factor(Subject) + Year, data = ps)
summary(mps)

m1ps = glm(Score ~ as_factor(Baseline) + as_factor(Subject) + Year, data = ps)
summary(m1ps)

plot(mps)
ggpairs(mps)

ps$County = as_factor(ps$County)
str(ps$County)
levels(ps$County) = c("State", "Colombia", "Montour")
levels(ps$County)



png(filename = "Obj2b.png", width = 1280, height = 1280)

pps = ggplot(data = ps, aes(y = Score, x = Year, fill = as_factor(County))) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~as_factor(Baseline))

pps

dev.off()

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
m1 = aov(Score ~ as_factor(Subject) + Year + as_factor(Baseline) + 
          as_factor(District) + as_factor(School) + 
          as_factor(County), data = ks)
summary(m1)


m2 = glm(Score ~ as_factor(Subject) + Year + as_factor(Baseline) + 
           as_factor(District) + as_factor(School) + 
           as_factor(County), data = ks)
summary(m2)


plot(m)
ggpairs(m)


m3 = glm(Score ~ as_factor(Baseline) + Year, data = ks)
summary(m3)


ks$County = as_factor(ks$County)
str(ks$County)
levels(ks$County) = c("State", "Colombia", "Montour")
levels(ks$County)


png(filename = "Obj3a.png", width = 1280, height = 1280)

p1 = ggplot(data = ks, aes(fill = as_factor(Baseline), y = Score, x = as_factor(Subject))) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~Year + County, ncol = 3) +
  xlab("State vs Counties") +
  scale_fill_discrete(name = "Baseline")

p1

dev.off()


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

# Objective 7: Any other information that data might tell us? Summary.


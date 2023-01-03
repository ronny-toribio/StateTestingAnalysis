# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel, John Seibert
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
kscm = ks %>% group_by(County) %>% mutate(Score=mean(Score)) %>% select(County, Score) %>% distinct()
kscm
png("Graphs/obj1-kscm.png")
plot(kscm)
dev.off()
ggpairs(kscm)
ggsave("Graphs/obj1-kscm-ggpairs.png")

pscm = ps %>% group_by(County) %>% mutate(Score=mean(Score)) %>% select(County, Score) %>% distinct()
pscm
png("Graphs/obj1-pscm.png")
plot(pscm)
dev.off()

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

newps = ps[60:1765, 1:10]
newps

png(filename = "Obj2b.png", width = 1280, height = 1280)

pps = ggplot(data = newps, aes(y = Score, x = Year, fill = as_factor(County))) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~as_factor(Baseline))

pps

dev.off()


# We see that in general, Montour and Colombia county fared better than State 
# since 2015 in terms of scores. Basic level showed a sharp increase in Montour
# and Colombia counties in 2022. Proficient level also showed a sharp
# increase especially in 2022 for Montour county


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

newps = ps[60:1765, 1:10]
newps

png(filename = "Obj3b.png", width = 1280, height = 1280)

p1ps = ggplot(data = newps, aes(fill = as_factor(Baseline), y = Score, x = as_factor(Subject))) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~Year + County, ncol = 3) +
  xlab("State vs Counties") +
  scale_fill_discrete(name = "Baseline")

p1ps

dev.off()


# Checking score averages throughout the years for counties and subjects, it
# is interesting to see that COVID didn't impact Math and English scores
# dramatically for Colombia, Montour and State. In fact, there was a significant
# improvement in the scores in 2022 compared to 2019 for math scores in Colombia
# county. Math scores remained stable if not slightly improved for both state
# and Montour. However, there was a steep decline in Science scores between 2021
# and 2022 throughout the state which may be an indication of a COVID impact.


# Objective 4: Any other information that data might tell us?


# Objective 5: Visualizing the averages of scores from each year.
# Objective 5a. As a whole.

ks %>% group_by(Year) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ks
png("Graphs/obj5a-ks-plot.png")
plot(ks)
dev.off()
ggpairs(ks)
ggsave("Graphs/obj5a-ks-ggpairs.png")

ps %>% group_by(Year) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ps
png("Graphs/obj5a-ps-plot.png")
plot(ps)

# Objective 5b. Grouped by subject.
kss = ks %>% group_by(Subject) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
kss
png("Graphs/obj5b-kss-plot.png")
plot(kss)
dev.off()
ggpairs(kss)
ggsave("Graphs/obj5b-kss-ggpairs.png")

pss = ps %>% group_by(Subject) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
pss
png("Graphs/obj5b-pss-plot.png")
plot(pss)
dev.off()

# Objective 5c. Grouped by district.

ksd = ks %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
ksd
png("Graphs/obj5c-ksd-plot.png")
plot(ksd)
dev.off()
ggpairs(ksd)
ggsave("Graphs/obj5c-ksd-ggpairs.png")

psd = ps %>% group_by(District) %>% mutate(Score=mean(Score)) %>% select(Score) %>% distinct()
psd
png("Graphs/obj5c-psd-plot.png")
plot(psd)
dev.off()

# Objective 6. Study Cohorts
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




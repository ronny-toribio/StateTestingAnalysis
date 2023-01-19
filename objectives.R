# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel
# @project: State Testing Analysis
# @file:    analysis.R
# @desc:    Analysis of testing data

library(tidyverse) # includes ggplot2, ggthemes

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


# PSSA and Keystone
ps = read_csv("PSSA/pssa.csv")
ks = read_csv("Keystone/keystone.csv")
ps$County = as_factor(ps$County)
ks$County = as_factor(ks$County)
ps$Category = as_factor(ps$Category)
ks$Category = as_factor(ks$Category)


# Cohorts
cohorts = read_csv("Cohorts/cohorts.csv")
cohorts$County = as_factor(cohorts$County)
cohorts$Category = as_factor(cohorts$Category)
cohorts$Grade = as_factor(cohorts$Grade)
cohorts$Cohort = as.integer(cohorts$Cohort)


# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2015?
#Keystone
obj1ks = ks %>%
  filter(County != "State" & Category == "Top") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge") +
  labs(title = "Keystone Testing Averages in Columbia and Montour Counties")
plot(obj1ks)
ggsave("Resources/obj1ks.png", obj1ks)

#PSSA
obj1ps = ps %>%
  filter(County != "State" & Category == "Top") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge") +
  labs(title = "PSSA Testing Averages in Columbia and Montour Counties")
plot(obj1ps)
ggsave("Resources/obj1ps.png", obj1ps)

# Objective 2: How they compare to the state trend since 2015?

ks_group_by_year_county_top = ks %>% 
  select(Year, County, Category, Scored, Students) %>%
  group_by(Year, County) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored,
         AvgScoreLabel = round(AvgScore, 2))

ks_group_by_year_county_top

ks_group_by_year_state_subject_top = ks %>%
  select(Year, County, Category, Scored, Students, Subject) %>%
  group_by(Year, County, Subject) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored,
         AvgScoreLabel = round(AvgScore, 2))

ks_group_by_year_state_subject_top

ks_group_by_year_county_subject_school_top = ks %>% 
  select(Year, County, School, Category, Scored, Students, Subject) %>%
  group_by(Year, County, Subject, School) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored,
         AvgScoreLabel = round(AvgScore, 2))

ks_group_by_year_county_subject_school_top


png(filename = "Obj2stateKS.png", width = 1280, height = 1280)

ks_state_bar = ks_group_by_year_county_top %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "red") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "County") + 
  ggtitle("Score Average for Top Category by Years in State") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_state_bar

dev.off()

png(filename = "Obj2columbiaKS.png", width = 1280, height = 1280)

ks_columbia_bar =  ks_group_by_year_county_top %>%
  filter(County == "Columbia") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "cyan") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years in Columbia County") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_bar

dev.off()

png(filename = "Obj2montourKS.png", width = 1280, height = 1280)

ks_montour_bar = ks_group_by_year_county_top%>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "violet") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years in Montour County") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_montour_bar

dev.off()

png(filename = "Obj2combinedKS.png", width = 1280, height = 1280)

ks_compact_combined_bar = ggplot(data = ks_group_by_year_county_top, aes(y = AvgScore, x = Year, fill = County)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years") +
  xlab("Years") + 
  ylab("Average Score in %")


ks_compact_combined_bar

dev.off()

png(filename = "Obj3stateEngKS.png", width = 1280, height = 1280)

ks_state_subject_top_english = ks_group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "English") %>%
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "red") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_state_subject_top_english

dev.off()

png(filename = "Obj3stateMathKS.png", width = 1280, height = 1280)

ks_state_subject_top_math = ks_group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "red") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_state_subject_top_math

dev.off()

png(filename = "Obj3stateScienceKS.png", width = 1280, height = 1280)

ks_state_subject_top_science = ks_group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "red") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (Science)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_state_subject_top_science

dev.off()

png(filename = "Obj3stateCombKS.png", width = 1280, height = 1280)

ks_state_subject_top_compact = ks_group_by_year_state_subject_top %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_state_subject_top_compact

dev.off()

png(filename = "Obj3columbiaEngKS.png", width = 1280, height = 1280)

ks_columbia_subject_top_english = ks_group_by_year_state_subject_top %>%
  filter(County == "Columbia" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "cyan") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Columbia County by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_subject_top_english

dev.off()

png(filename = "Obj3columbiaMathKS.png", width = 1280, height = 1280)

ks_columbia_subject_top_math = ks_group_by_year_state_subject_top %>%
  filter(County == "Columbia" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "cyan") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Columbia County by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_subject_top_math

dev.off()

png(filename = "Obj3columbiaScienceKS.png", width = 1280, height = 1280)

ks_columbia_subject_top_science = ks_group_by_year_state_subject_top %>%
  filter(County == "Columbia" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "cyan") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Columbia County by Subject (Science)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_subject_top_science

dev.off()

png(filename = "Obj3columbiaCombKS.png", width = 1280, height = 1280)

ks_columbia_subject_top_compact = ks_group_by_year_state_subject_top %>%
  filter(County == "Columbia") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Columbia County by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_subject_top_compact

dev.off()

png(filename = "Obj3montourEngKS.png", width = 1280, height = 1280)

ks_montour_subject_top_english = ks_group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "violet") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_montour_subject_top_english

dev.off()

png(filename = "Obj3montourMathKS.png", width = 1280, height = 1280)

ks_montour_subject_top_math = ks_group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "violet") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_montour_subject_top_math

dev.off()

png(filename = "Obj3montourSciKS.png", width = 1280, height = 1280)

ks_montour_subject_top_science = ks_group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "violet") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (Science)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_montour_subject_top_science

dev.off()

png(filename = "Obj3montourCombKS.png", width = 1280, height = 1280)

ks_montour_subject_top_compact = ks_group_by_year_state_subject_top %>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_montour_subject_top_compact

dev.off()

#granular graphs

png(filename = "Misc1KS.png", width = 1280, height = 1280)

ks_columbia_top_school_english = ks_group_by_year_county_subject_school_top %>%
  filter(County == "Columbia" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Columbia County Schools (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_top_school_english

dev.off()

png(filename = "Misc2KS.png", width = 1280, height = 1280)

ks_columbia_top_school_math = ks_group_by_year_county_subject_school_top %>%
  filter(County == "Columbia" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Columbia County Schools (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_top_school_math

dev.off()

png(filename = "Misc3KS.png", width = 1280, height = 1280)

ks_columbia_top_school_science = ks_group_by_year_county_subject_school_top %>%
  filter(County == "Columbia" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Columbia County Schools (Science)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_top_school_science

dev.off()

png(filename = "Misc4KS.png", width = 1280, height = 1280)

ks_columbia_top_school_subjects_compact = ks_group_by_year_county_subject_school_top %>%
  filter(County == "Columbia") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") +
  facet_wrap(~Subject) +
  ggtitle("Average Score of Top Category in Columbia County Schools (All Subjects)") +
  xlab("Years") + 
  ylab("Average Score in %")

ks_columbia_top_school_subjects_compact

dev.off()

#anova analysis

ks_anova = aov(Score ~ Year + as_factor(County) + as_factor(District) + 
                 as_factor(School) + as_factor(Subject) + Scored +
                 as_factor(Category) + Score + Students, data = ks)
summary(ks_anova)

ks_model = glm(Score ~ Year + as_factor(County) + as_factor(District) + 
                 as_factor(School) + as_factor(Subject) + Scored +
                 as_factor(Category) + Score + Students, data = ks)
summary(ks_model)

#----------------------------------------------------------------------
#PSSA Data


ps_group_by_year_county_top = ps %>% 
  select(Year, County, Category, Scored, Students) %>%
  group_by(Year, County) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored,
         AvgScoreLabel = round(AvgScore, 2))

ps_group_by_year_county_top


ps_group_by_year_state_subject_top = ps %>%
  select(Year, County, Category, Scored, Students, Subject) %>%
  group_by(Year, County, Subject) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored,
         AvgScoreLabel = round(AvgScore, 2))

ps_group_by_year_state_subject_top


ps_group_by_year_county_subject_school_top = ps %>% 
  select(Year, County, School, Category, Scored, Students, Subject) %>%
  group_by(Year, County, Subject, School) %>%
  filter(Category == "Top") %>%
  summarise(across(c(Scored, Students), sum)) %>%
  mutate(AvgScore = Students/Scored,
         AvgScoreLabel = round(AvgScore, 2))

ps_group_by_year_county_subject_school_top


png(filename = "Obj2statePS.png", width = 1280, height = 1280)

ps_state_bar = ps_group_by_year_county_top %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "red") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "County") + 
  ggtitle("Score Average for Top Category by Years in State") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_state_bar

dev.off()

png(filename = "Obj2columbiaPS.png", width = 1280, height = 1280)

ps_columbia_bar =  ps_group_by_year_county_top %>%
  filter(County == "Columbia") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "cyan") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years in Columbia County") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_bar

dev.off()

png(filename = "Obj2montourPS.png", width = 1280, height = 1280)

ps_montour_bar = ps_group_by_year_county_top%>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "violet") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years in Montour County") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_montour_bar

dev.off()

png(filename = "Obj2combinedPS.png", width = 1280, height = 1280)

ps_compact_combined_bar = ggplot(data = ps_group_by_year_county_top, aes(y = AvgScore, x = Year, fill = County)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "County") +
  ggtitle("Score Average for Top Category by Years") +
  xlab("Years") + 
  ylab("Average Score in %")


ps_compact_combined_bar

dev.off()

#anova analysis

ps_anova = aov(Score ~ Year + as_factor(County) + as_factor(District) + 
                 as_factor(School) + as_factor(Subject) + Scored +
                 as_factor(Category) + Score + Students, data = ps)
summary(ps_anova)

ps_model = glm(Score ~ Year + as_factor(County) + as_factor(District) + 
                 as_factor(School) + as_factor(Subject) + Scored +
                 as_factor(Category) + Score + Students, data = ps)
summary(ps_model)


#-------------------------------------------------------------------

#Keystone Data

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

#PSSA DATA

# PSSA data also shows similar observations all levels for the top category.

# For state level, average score percentage dipped in 2017 and went back to 2016
# levels in 2018 and 2019. There was a decline in 2021 and a slight increase in 2022

# In Colombia County, average score percentage stayed steady from 2016 to 2019.
# There was a decline in percentage in 2021 which showed some recovery in 2022.

# In Montour County, average score percentage rose all time high in 2019 in
# observed years (2016-2022). There was a sharp decline in 2021 and some
# recovery in 2022. 

#---------------------------------------------------------------------------

# Objective 3: Is there any COVID impact we might be able to deduce?

png(filename = "Obj3stateEngPS.png", width = 1280, height = 1280)

ps_state_subject_top_english = ps_group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "red") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_state_subject_top_english

dev.off()

png(filename = "Obj3stateMathPS.png", width = 1280, height = 1280)

ps_state_subject_top_math = ps_group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "red") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_state_subject_top_math

dev.off()

png(filename = "Obj3stateSciencePS.png", width = 1280, height = 1280)

ps_state_subject_top_science = ps_group_by_year_state_subject_top %>%
  filter(County == "State" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "red") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subject (Science)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_state_subject_top_science

dev.off()

png(filename = "Obj3stateCombPS.png", width = 1280, height = 1280)

ps_state_subject_top_compact = ps_group_by_year_state_subject_top %>%
  filter(County == "State") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in State by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_state_subject_top_compact

dev.off()

png(filename = "Obj3columbiaEngPS.png", width = 1280, height = 1280)

ps_columbia_subject_top_english = ps_group_by_year_state_subject_top %>%
  filter(County == "Columbia" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "cyan") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Columbia County by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_subject_top_english

dev.off()

png(filename = "Obj3columbiaMathPS.png", width = 1280, height = 1280)

ps_columbia_subject_top_math = ps_group_by_year_state_subject_top %>%
  filter(County == "Columbia" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "cyan") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Columbia County by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_subject_top_math

dev.off()

png(filename = "Obj3columbiaSciencePS.png", width = 1280, height = 1280)

ps_columbia_subject_top_science = ps_group_by_year_state_subject_top %>%
  filter(County == "Columbia" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "cyan") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Columbia County by Subject (Science)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_subject_top_science

dev.off()

png(filename = "Obj3columbiaCombPS.png", width = 1280, height = 1280)

ps_columbia_subject_top_compact = ps_group_by_year_state_subject_top %>%
  filter(County == "Columbia") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Columbia County by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_subject_top_compact

dev.off()

png(filename = "Obj3montourEngPS.png", width = 1280, height = 1280)

ps_montour_subject_top_english = ps_group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "violet") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_montour_subject_top_english

dev.off()

png(filename = "Obj3montourMathPS.png", width = 1280, height = 1280)

ps_montour_subject_top_math = ps_group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "violet") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_montour_subject_top_math

dev.off()

png(filename = "Obj3montourSciPS.png", width = 1280, height = 1280)

ps_montour_subject_top_science = ps_group_by_year_state_subject_top %>%
  filter(County == "Montour" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore)) +
  geom_bar(position="dodge", stat="identity", fill = "violet") +
  geom_label(aes(x = Year, y = AvgScore-0.03 , label = AvgScoreLabel)) +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subject (Science)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_montour_subject_top_science

dev.off()

png(filename = "Obj3montourCombPS.png", width = 1280, height = 1280)

ps_montour_subject_top_compact = ps_group_by_year_state_subject_top %>%
  filter(County == "Montour") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "Subject") + 
  ggtitle("Average Score of Top Category in Montour County by Subjects") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_montour_subject_top_compact

dev.off()

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

#granular graphs

png(filename = "Misc1PS.png", width = 1280, height = 1280)

ps_columbia_top_school_english = ps_group_by_year_county_subject_school_top %>%
  filter(County == "Columbia" & Subject == "English") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Columbia County Schools (English)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_top_school_english

dev.off()

png(filename = "Misc2PS.png", width = 1280, height = 1280)

ps_columbia_top_school_math = ps_group_by_year_county_subject_school_top %>%
  filter(County == "Columbia" & Subject == "Math") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Columbia County Schools (Math)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_top_school_math

dev.off()

png(filename = "Misc3PS.png", width = 1280, height = 1280)

ps_columbia_top_school_science = ps_group_by_year_county_subject_school_top %>%
  filter(County == "Columbia" & Subject == "Science") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") + 
  ggtitle("Average Score of Top Category in Columbia County Schools (Science)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_top_school_science

dev.off()

png(filename = "Misc4PS.png", width = 1280, height = 1280)

ps_columbia_top_school_subjects_compact = ps_group_by_year_county_subject_school_top %>%
  filter(County == "Columbia") %>% 
  ggplot(aes(x = Year, y = AvgScore, fill = School)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(name = "School") +
  facet_wrap(~Subject) +
  ggtitle("Average Score of Top Category in Columbia County Schools (All Subjects)") +
  xlab("Years") + 
  ylab("Average Score in %")

ps_columbia_top_school_subjects_compact

dev.off()



# Objective 4: Visualizing the averages of scores from each year.
# Objective 4a. As a whole.

#Keystone
obj4ksa = ks %>%
  filter(Category == "Top") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "Top Keystone Testing Averages")
plot(obj4ksa)

obj4ksb = ks %>%
  filter(Category == "Advanced") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green")  +
  labs(title = "Advanced Keystone Testing Averages")
plot(obj4ksb)

obj4ksc = ks %>%
  filter(Category == "Proficient") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "Proficient Keystone Testing Averages")
plot(obj4ksc)

obj4ksd = ks %>%
  filter(Category == "Basic") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green")  +
  labs(title = "Basic Keystone Testing Averages")
plot(obj4ksd)

obj4kse = ks %>%
  filter(Category == "BelowBasic") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green")  +
  labs(title = "Below Basic Keystone Testing Averages")
plot(obj4kse)

#PSSA
obj4psa = ps %>%
  filter(Category == "Top") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green")  +
  labs(title = "Top PSSA Testing Averages")
plot(obj4psa)

obj4psb = ps %>%
  filter(Category == "Advanced") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "Advanced PSSA Testing Averages")
plot(obj4psb)

obj4psc = ps %>%
  filter(Category == "Proficient") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "Proficient PSSA Testing Averages")
plot(obj4psc)

obj4psd = ps %>%
  filter(Category == "Basic") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green")  +
  labs(title = "Basic PSSA Testing Averages")
plot(obj4psd)

obj4pse = ps %>%
  filter(Category == "BelowBasic") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = County)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "Below Basic PSSA Testing Averages in Columbia and Montour Counties")
plot(obj4pse)


# Objective 4b. Grouped by subject.
#Keystone
obj4bksa = ks %>%
  filter(Subject == "Math" & Category == "Top") %>%
  group_by(Year, Subject) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "Keystone Yearly Testing Averages for Math")
plot(obj4bksa)

obj4bksb = ks %>%
  filter(Subject == "English" & Category == "Top") %>%
  group_by(Year, Subject) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "Keystone Yearly Testing Averages for English")
plot(obj4bksb)

obj4bksc = ks %>%
  filter(Subject == "Science" & Category == "Top") %>%
  group_by(Year, Subject) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill=Subject)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "Keystone Yearly Testing Averages for Science")
plot(obj4bksc)

#PSSA
obj4bpsa = ps %>%
  filter(Subject == "Math" & Category == "Top") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_col(position = "dodge", fill= "green")  +
  labs(title = "PSSA Yearly Testing Averages for Math")
plot(obj4bpsa)

obj4bpsb = ps %>%
  filter(Subject == "English" & Category == "Top") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "PSSA Yearly Testing Averages for English")
plot(obj4bpsb)

obj4bpsc = ps %>%
  filter(Subject == "Science" & Category == "Top") %>%
  group_by(Year, County) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
  geom_col(position = "dodge", fill= "green") +
  labs(title = "PSSA Yearly Testing Averages for Science")
plot(obj4bpsc)


# Objective 4c. Grouped by district.

obj4cksa = ks %>%
  filter(Category == "Top") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Top Keystone Yearly Testing Averages by District")
plot(obj4cksa)

obj4cksb = ks %>%
  filter(Category == "Advanced") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Advanced Keystone Yearly Testing Averages by District")
plot(obj4cksb)

obj4cksc = ks %>%
  filter(Category == "Proficient") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Proficient Keystone Yearly Testing Averages by District")
plot(obj4cksc)

obj4cksd = ks %>%
  filter(Category == "Basic") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Basic Keystone Yearly Testing Averages by District")
plot(obj4cksd)


obj4ckse = ks %>%
  filter(Category == "BelowBasic") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Below Basic Keystone Yearly Testing Averages by District")
plot(obj4ckse)

obj4cpsa = ps %>%
  filter(Category == "Top") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Top PSSA Yearly Testing Averages by District")
plot(obj4cpsa)

obj4cpsb = ps %>%
  filter(Category == "Advanced") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Advanced PSSA Yearly Testing Averages by District")
plot(obj4cpsb)

obj4cpsc = ps %>%
  filter(Category == "Proficient") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Proficient PSSA Yearly Testing Averages by District")
plot(obj4cpsc)

obj4cpsd = ps %>%
  filter(Category == "Basic") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Basic PSSA Yearly Testing Averages by District")
plot(obj4cpsd)


obj4cpse = ps %>%
  filter(Category == "BelowBasic") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Below Basic PSSA Yearly Testing Averages by District")
plot(obj4cpse)



# Objective 5: Compare scores between districts

obj4cksa = ks %>%
  filter(Category == "Top") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Keystone Yearly Testing Averages by District")
plot(obj4cksa)

obj4cpsa = ps %>%
  filter(Category == "Top") %>%
  group_by(Year, District) %>%
  mutate(AvgScore=sum(Students)/sum(Scored)) %>%
  ggplot(aes(x = Year, y = AvgScore, fill = District)) +
  geom_col(position = "dodge") +
  labs(title = "Keystone Yearly Testing Averages by District")
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
    labs(title=title)
  plot(pcas)
  ggsave(filename, pcas)
}

# Objective 6a All Counties
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
plot_cohorts(cas, "Cohorts All", "Resources/Obj6a.png")

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
plot_cohorts(cas_state, "Cohorts State Level", "Resources/Obj6b_state.png")

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
plot_cohorts(cas_columbia, "Cohorts Columbia Level", "Resources/Obj6b_columbia.png")

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
plot_cohorts(cas_montour, "Cohorts Montour Level", "Resources/Obj6b_montour.png")

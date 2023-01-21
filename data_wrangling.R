# @author:  Ronny Toribio
# @project: State Testing Analysis
# @file:    data_wrangling.R
# @desc:    Loads and organizes the testing dataset

library(tidyverse)

# Begin Suppress Warnings
options(warn=-1)

# Keystone School Level Data
ks.sc.2016 = readxl::read_xlsx("Keystone/School/2016.xlsx", skip=4)
ks.sc.2017 = readxl::read_xlsx("Keystone/School/2017.xlsx", skip=4)
ks.sc.2018 = readxl::read_xlsx("Keystone/School/2018.xlsx", skip=4)
ks.sc.2019 = readxl::read_xlsx("Keystone/School/2019.xlsx", skip=4)
# no 2020 data
ks.sc.2021 = readxl::read_xlsx("Keystone/School/2021.xlsx", skip=4)
ks.sc.2022 = readxl::read_xlsx("Keystone/School/2022.xlsx", skip=3)

# Organize columns
ks.sc.2016 = ks.sc.2016 %>% select(District, School, Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ks.sc.2017 = ks.sc.2017 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", County)
ks.sc.2018 = ks.sc.2018 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ks.sc.2019 = ks.sc.2019 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ks.sc.2021 = ks.sc.2021 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ks.sc.2022 = ks.sc.2022 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)

# Column names
ks.sc.cols = c("District", "School","Subject", "Group", "Scored", "Advanced", "Proficient", "Basic", "BelowBasic", "County")
colnames(ks.sc.2016) = ks.sc.cols
colnames(ks.sc.2017) = ks.sc.cols
colnames(ks.sc.2018) = ks.sc.cols
colnames(ks.sc.2019) = ks.sc.cols
colnames(ks.sc.2021) = ks.sc.cols
colnames(ks.sc.2022) = ks.sc.cols
rm(ks.sc.cols)

# Create keystone school level tibble
ks.sc = bind_rows(
  ks.sc.2016 %>% mutate(Year="2016"),
  ks.sc.2017 %>% mutate(Year="2017"),
  ks.sc.2018 %>% mutate(Year="2018"),
  ks.sc.2019 %>% mutate(Year="2019"),
  ks.sc.2021 %>% mutate(Year="2021"),
  ks.sc.2022 %>% mutate(Year="2022")
)

# Clean up of Keystone School data
rm(ks.sc.2016)
rm(ks.sc.2017)
rm(ks.sc.2018)
rm(ks.sc.2019)
rm(ks.sc.2021)
rm(ks.sc.2022)

# County to common case
ks.sc$County = str_to_sentence(ks.sc$County)

# Select Columbia and Montour counties
ks.sc = ks.sc %>% filter(County %in% c("Columbia", "Montour"))

# Remove historically underperforming rows and group column
ks.sc = ks.sc %>% filter(Group=="All Students") %>% select(-Group)

# Rename Columbia-Montour AVTS
ks.sc = ks.sc %>% mutate(across(School, str_replace, "COLUMBIA - MONTOUR AVTS", "COLUMBIA-MONTOUR AVTS"))
ks.sc = ks.sc %>% mutate(across(District, str_replace, "COLUMBIA - MONTOUR AVTS", "COLUMBIA-MONTOUR AVTS"))


# Keystone State Level Data
ks.st.2016 = readxl::read_xlsx("Keystone/State/2016.xlsx", skip=4)
ks.st.2017 = readxl::read_xlsx("Keystone/State/2017.xlsx", skip=3)
ks.st.2018 = readxl::read_xlsx("Keystone/State/2018.xlsx", skip=3)
ks.st.2019 = readxl::read_xlsx("Keystone/State/2019.xlsx", skip=3)
# no 2020 data
ks.st.2021 = readxl::read_xlsx("Keystone/State/2021.xlsx", skip=4)
ks.st.2022 = readxl::read_xlsx("Keystone/State/2022.xlsx", skip=2)

# Organize columns
ks.st.2016 = ks.st.2016 %>% select(Subject, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", Group) %>% filter(Group=="All Students") %>% select(-Group)
ks.st.2017 = ks.st.2017 %>% select(Subject, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic")
ks.st.2018 = ks.st.2018 %>% select(Subject, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                         %>% filter(Group=="All Students") %>% select(-Group)
ks.st.2019 = ks.st.2019 %>% select(Subject, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                         %>% filter(Group=="All Students") %>% select(-Group)
ks.st.2021 = ks.st.2021 %>% select(Subject, "Number scored 2021", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                    %>% filter(Group=="All Students") %>% select(-Group)
ks.st.2022 = ks.st.2022 %>% select(Subject, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic")

# Column names
ks.st.cols = c("Subject", "Scored", "Advanced", "Proficient", "Basic",  "BelowBasic")
colnames(ks.st.2016) = ks.st.cols
colnames(ks.st.2017) = ks.st.cols
colnames(ks.st.2018) = ks.st.cols
colnames(ks.st.2019) = ks.st.cols
colnames(ks.st.2021) = ks.st.cols
colnames(ks.st.2022) = ks.st.cols
rm(ks.st.cols)

# Create keystone state level tibble
ks.st = bind_rows(
  ks.st.2016 %>% mutate(Year="2016"),
  ks.st.2017 %>% mutate(Year="2017"),
  ks.st.2018 %>% mutate(Year="2018"),
  ks.st.2019 %>% mutate(Year="2019"),
  ks.st.2021 %>% mutate(Year="2021"),
  ks.st.2022 %>% mutate(Year="2022")
)

# Clean up of Keystone state data
rm(ks.st.2016)
rm(ks.st.2017)
rm(ks.st.2018)
rm(ks.st.2019)
rm(ks.st.2021)
rm(ks.st.2022)


# Merge state and school level Keystone data
ks.st = ks.st %>% mutate(District="", School="", County="State")
ks = bind_rows(ks.st, ks.sc) %>% arrange(Year)
rm(ks.sc)
rm(ks.st)
ks = ks %>% mutate(across(Subject, str_replace, "E", "English"))
ks = ks %>% mutate(across(Subject, str_replace, "M", "Math"))
ks = ks %>% mutate(across(Subject, str_replace, "S", "Science"))
ks = ks %>% mutate(across(Subject, str_replace, "Literature", "English"))
ks = ks %>% mutate(across(Subject, str_replace, "Algebra I", "Math"))
ks = ks %>% mutate(across(Subject, str_replace, "Biology", "Science"))

# Create Top column (Proficient + Advanced)
ks = ks %>% mutate(Top=Proficient+Advanced)

# Create Category and score columns
ks = bind_rows(
  ks %>% mutate(Category="Top",        Score=Top),
  ks %>% mutate(Category="Advanced",   Score=Advanced) ,
  ks %>% mutate(Category="Proficient", Score=Proficient),
  ks %>% mutate(Category="Basic",      Score=Basic),
  ks %>% mutate(Category="BelowBasic", Score=BelowBasic)
) %>% arrange(Year) %>% select(-Top, -Advanced, -Proficient, -Basic, -BelowBasic)

# Create Students column
ks = ks %>% mutate(Students=ceiling(Score / 100 * Scored))

# Organize columns for Keystone
ks = ks %>% select(Year, County, District, School, Subject, Scored, Category, Score, Students)

# Drop NA's in Score
ks = ks %>% filter(!is.na(Score))

# Export the Keystone data set as CSV for R and XLSX for tableau
write_csv(ks, "Keystone/keystone.csv")

# PSSA school level data
ps.sc.2016 = readxl::read_xlsx("PSSA/School/2016.xlsx", skip=4)
ps.sc.2017 = readxl::read_xlsx("PSSA/School/2017.xlsx", skip=4)
ps.sc.2018 = readxl::read_xlsx("PSSA/School/2018.xlsx", skip=4)
ps.sc.2019 = readxl::read_xlsx("PSSA/School/2019.xlsx", skip=4)
# no 2020 data
ps.sc.2021 = readxl::read_xlsx("PSSA/School/2021.xlsx", skip=6)[, 1:15]
ps.sc.2022 = readxl::read_xlsx("PSSA/School/2022.xlsx", skip=3)

# Organize columns
ps.sc.2016 = ps.sc.2016 %>% select(District, School, Subject, Group, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", County)
ps.sc.2017 = ps.sc.2017 %>% select("District Name", "School Name", Subject, Group, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", County)
ps.sc.2018 = ps.sc.2018 %>% select("District Name", "School Name", Subject, Group, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ps.sc.2019 = ps.sc.2019 %>% select("District Name", "School Name", Subject, Group, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ps.sc.2021 = ps.sc.2021 %>% select("District Name", "School Name", Subject, Group, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ps.sc.2022 = ps.sc.2022 %>% select("District Name", "School Name", Subject, "Student Group", Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)

# Column names
ps.sc.cols = c("District", "School", "Subject", "Group", "Grade", "Scored", "Advanced", "Proficient", "Basic", "BelowBasic", "County")
colnames(ps.sc.2016) = ps.sc.cols
colnames(ps.sc.2017) = ps.sc.cols
colnames(ps.sc.2018) = ps.sc.cols
colnames(ps.sc.2019) = ps.sc.cols
colnames(ps.sc.2021) = ps.sc.cols
colnames(ps.sc.2022) = ps.sc.cols
rm(ps.sc.cols)

# Create PSSA school level tibble
ps.sc = bind_rows(
  ps.sc.2016 %>% mutate(Year="2016"),
  ps.sc.2017 %>% mutate(Year="2017"),
  ps.sc.2018 %>% mutate(Year="2018"),
  ps.sc.2019 %>% mutate(Year="2019"),
  ps.sc.2021 %>% mutate(Year="2021"),
  ps.sc.2022 %>% mutate(Year="2022")
)

# Clean up of PSSA school data
rm(ps.sc.2016)
rm(ps.sc.2017)
rm(ps.sc.2018)
rm(ps.sc.2019)
rm(ps.sc.2021)
rm(ps.sc.2022)

# County to common case
ps.sc$County = str_to_sentence(ps.sc$County)

# Select Columbia and Montour counties
ps.sc = ps.sc %>% filter(County %in% c("Columbia", "Montour"))

# Remove historically underperforming rows and group column
ps.sc = ps.sc %>% filter(Group=="All Students") %>% select(-Group)


# PSSA state level data
ps.st.2016 = readxl::read_xlsx("PSSA/State/2016.xlsx", skip=4)
ps.st.2017 = readxl::read_xlsx("PSSA/State/2017.xlsx", skip=3)
ps.st.2018 = readxl::read_xlsx("PSSA/State/2018.xlsx", skip=4)
ps.st.2019 = readxl::read_xlsx("PSSA/State/2019.xlsx", skip=3)
# no 2020 data
ps.st.2021 = readxl::read_xlsx("PSSA/State/2021.xlsx", skip=3) %>% mutate(across(Grade, as.character))
ps.st.2022 = readxl::read_xlsx("PSSA/State/2022.xlsx", skip=3)

# Join 2017 data into one set
ps.st.2017 = bind_rows(
  ps.st.2017[5:10,] %>% mutate(Subject="Math"),
  ps.st.2017[16:21,] %>% mutate(Subject="English Language Arts"),
  ps.st.2017[c(28, 32),] %>% mutate(Subject="Science")
)

# Organize columns
ps.st.2016 = ps.st.2016 %>% select(Subject, Grade, "Number scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", Group)           %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2017 = ps.st.2017 %>% select(Subject, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic")
ps.st.2018 = ps.st.2018 %>% select(Subject, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                                   %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2019 = ps.st.2019 %>% select(Subject, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                                   %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2021 = ps.st.2021 %>% select(Subject, Grade, "Number scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                                   %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2022 = ps.st.2022 %>% select(Subject, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", "Student Group") %>% filter(ps.st.2022$"Student Group"=="All Students") %>% select(-"Student Group")

# Column names
ps.st.cols = c("Subject", "Grade", "Scored", "Advanced", "Proficient", "Basic", "BelowBasic")
colnames(ps.st.2016) = ps.st.cols
colnames(ps.st.2017) = ps.st.cols
colnames(ps.st.2018) = ps.st.cols
colnames(ps.st.2019) = ps.st.cols
colnames(ps.st.2021) = ps.st.cols
colnames(ps.st.2022) = ps.st.cols
rm(ps.st.cols)

# recreate 2021 totals
ps.st.2021 = ps.st.2021 %>% mutate(across(Subject, str_replace, "English Language Arts", "English"))
ps.st.2021.total = ps.st.2021 %>% 
  filter(Subject!="Science") %>%
  group_by(Subject) %>%
  mutate(
    Grade="Total",
    Scored=sum(Scored),
    Advanced=mean(Advanced),
    Proficient=mean(Proficient),
    Basic=mean(Basic),
    BelowBasic=mean(BelowBasic)
) %>% distinct()
ps.st.2021 = bind_rows(ps.st.2021, ps.st.2021.total)
rm(ps.st.2021.total)

# Create PSSA state level tibble
ps.st = bind_rows(
  ps.st.2016 %>% mutate(Year="2016"),
  ps.st.2017 %>% mutate(Year="2017"),
  ps.st.2018 %>% mutate(Year="2018"),
  ps.st.2019 %>% mutate(Year="2019"),
  ps.st.2021 %>% mutate(Year="2021"),
  ps.st.2022 %>% mutate(Year="2022")
)

# Clean up PSSA state data
rm(ps.st.2016)
rm(ps.st.2017)
rm(ps.st.2018)
rm(ps.st.2019)
rm(ps.st.2021)
rm(ps.st.2022)


# Merge PSSA data
ps.st = ps.st %>% mutate(District="", School="", School="", County="State")
ps = bind_rows(ps.st, ps.sc) %>% arrange(Year)
rm(ps.sc)
rm(ps.st)
ps = ps %>% mutate(across(Subject, str_replace, "English Language Arts", "English"))
ps = ps %>% mutate(across(Grade, str_replace, "State Total", "Total"))
ps = ps %>% mutate(across(Grade, str_replace, "School Total", "Total"))
ps = ps %>% mutate(across(Grade, str_replace, "03", "3"))
ps = ps %>% mutate(across(Grade, str_replace, "04", "4"))
ps = ps %>% mutate(across(Grade, str_replace, "05", "5"))
ps = ps %>% mutate(across(Grade, str_replace, "06", "6"))
ps = ps %>% mutate(across(Grade, str_replace, "07", "7"))
ps = ps %>% mutate(across(Grade, str_replace, "08", "8"))

# Create Top column (Proficient + Advanced)
ps = ps %>% mutate(Top=Proficient+Advanced)

# Create Category and score columns
ps = bind_rows(
  ps %>% mutate(Category="Top",        Score=Top),
  ps %>% mutate(Category="Advanced",   Score=Advanced),
  ps %>% mutate(Category="Proficient", Score=Proficient),
  ps %>% mutate(Category="Basic",      Score=Basic),
  ps %>% mutate(Category="BelowBasic", Score=BelowBasic)
) %>% arrange(Year) %>% select(-Top, -Advanced, -Proficient, -Basic, -BelowBasic)

# Create Students column
ps = ps %>% mutate(Students=ceiling(Score /100 * Scored))

# Create 2 PSSA data sets with and without Grades
ps2 = ps
ps = ps %>% filter(Grade=="Total") %>% select(-Grade)

# Organize columns for PSSA
ps = ps %>% select(Year, County, District, School, Subject, Scored, Category, Score, Students)

# Drop NA's in Score
ps = ps %>% filter(!is.na(Score))

# Export PSSA data to CSV for R and XLSX for tableau
write_csv(ps, "PSSA/pssa.csv")


# Cohorts
cohort.1 = bind_rows(
  ps2 %>% filter(Year==2016 & Grade==8),
  ks %>% filter(Year==2019) %>% mutate(Grade="11", SchoolNum="")
) %>% mutate(Cohort=1)

cohort.2 = bind_rows(
  ps2 %>% filter(Year==2016 & Grade==6),
  ps2 %>% filter(Year==2017 & Grade==7),
  ps2 %>% filter(Year==2018 & Grade==8),
  ks %>% filter(Year==2021) %>% mutate(Grade="11", SchoolNum="")
) %>% mutate(Cohort=2)

cohort.3 = bind_rows(
  ps2 %>% filter(Year==2016 & Grade==5),
  ps2 %>% filter(Year==2017 & Grade==6),
  ps2 %>% filter(Year==2018 & Grade==7),
  ps2 %>% filter(Year==2019 & Grade==8),
  ks %>% filter(Year==2022) %>% mutate(Grade="11", SchoolNum="")
) %>% mutate(Cohort=3)
rm(ps2)

# Merge cohorts
cohorts = bind_rows(
  cohort.1,
  cohort.2,
  cohort.3
)
rm(cohort.1)
rm(cohort.2)
rm(cohort.3)

# Organize Cohorts columns
cohorts = cohorts %>% select(Cohort, Year, County, District, School, Grade, Subject, Scored, Category, Score, Students)

# Export Cohorts set to CSV for R
write_csv(cohorts, "Cohorts/cohorts.csv")

# End Suppress Warnings
options(warn=0)
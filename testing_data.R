# @author:  Ronny Toribio
# @project: State Testing Analysis
# @file:    testing_data
# @desc:    Loads and organizes the testing data

library(tidyverse)

# Begin Suppress Warnings
options(warn=-1)

# Keystone School Level Data
ks.sc.2015 = readxl::read_xlsx("Keystone/School/2015.xlsx", skip=7)
ks.sc.2016 = readxl::read_xlsx("Keystone/School/2016.xlsx", skip=4)
ks.sc.2017 = readxl::read_xlsx("Keystone/School/2017.xlsx", skip=4)
ks.sc.2018 = readxl::read_xlsx("Keystone/School/2018.xlsx", skip=4)
ks.sc.2019 = readxl::read_xlsx("Keystone/School/2019.xlsx", skip=4)
# no 2020 data
ks.sc.2021 = readxl::read_xlsx("Keystone/School/2021.xlsx", skip=4)
ks.sc.2022 = readxl::read_xlsx("Keystone/School/2022.xlsx", skip=3)

# Organize columns
ks.sc.2015 = ks.sc.2015 %>% select("District Name", "School Name", Subject, Student_Group_Name, "N Scored", "Pct. Advanced", "Pct. Proficient", "Pct. Basic", "Pct. Below Basic", Grade)
ks.sc.2016 = ks.sc.2016 %>% select(District, School, Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ks.sc.2017 = ks.sc.2017 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", County)
ks.sc.2018 = ks.sc.2018 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ks.sc.2019 = ks.sc.2019 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ks.sc.2021 = ks.sc.2021 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ks.sc.2022 = ks.sc.2022 %>% select("District Name", "School Name", Subject, Group, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)

# Drop redundant rows
ks.sc.2015 = ks.sc.2015 %>% filter(Grade == "Total") %>% select(-Grade)

# Column names
ks.sc.cols = c("District", "School","Subject", "Group", "Scored", "Advanced", "Proficient", "Basic", "BelowBasic", "County")
colnames(ks.sc.2015) = c("District", "School", "Subject", "Group", "Scored", "Advanced", "Proficient", "Basic", "BelowBasic")
colnames(ks.sc.2016) = ks.sc.cols
colnames(ks.sc.2017) = ks.sc.cols
colnames(ks.sc.2018) = ks.sc.cols
colnames(ks.sc.2019) = ks.sc.cols
colnames(ks.sc.2021) = ks.sc.cols
colnames(ks.sc.2022) = ks.sc.cols

# Create keystone school level tibble
ks.sc = bind_rows(
  ks.sc.2016 %>% mutate(Year="2016"),
  ks.sc.2017 %>% mutate(Year="2017"),
  ks.sc.2018 %>% mutate(Year="2018"),
  ks.sc.2019 %>% mutate(Year="2019"),
  ks.sc.2021 %>% mutate(Year="2021"),
  ks.sc.2022 %>% mutate(Year="2022")
)

# Cast keystone school 2015 columns from character to double
ks.sc.2015 = ks.sc.2015 %>% filter(!(Advanced %in% c("IS", "NA", ""))) %>% mutate(
  across(Advanced,   as.double),
  across(Proficient, as.double),
  across(Basic,      as.double),
  across(BelowBasic, as.double)
)

# Add County column to 2015 data set from other years district
ks.sc.columbia.districts = ks.sc %>% filter(tolower(County) == "columbia") %>% select(District) %>% distinct()
ks.sc.montour.districts  = ks.sc %>% filter(tolower(County) == "montour")  %>% select(District) %>% distinct()
ks.sc.2015 = bind_rows(
  ks.sc.2015 %>% filter(District %in% ks.sc.columbia.districts$District) %>% mutate(County="columbia"),
  ks.sc.2015 %>% filter(District %in% ks.sc.montour.districts$District)  %>% mutate(County="montour")
) %>% mutate(Year="2015")

# Add 2015 data set to keystone school data set
ks.sc = bind_rows(ks.sc.2015, ks.sc)

# County to common case
ks.sc$County = str_to_sentence(ks.sc$County)

# Select Columbia and Montour counties
ks.sc = ks.sc %>% filter(County %in% c("Columbia", "Montour")) %>% drop_na()

# Create baseline and score columns
ks.sc = bind_rows(
  ks.sc %>% mutate(Baseline="Advanced",   Score=Advanced) ,
  ks.sc %>% mutate(Baseline="Proficient", Score=Proficient),
  ks.sc %>% mutate(Baseline="Basic",      Score=Basic),
  ks.sc %>% mutate(Baseline="BelowBasic", Score=BelowBasic)
) %>% arrange(Year) %>% select(-Advanced, -Proficient, -Basic, -BelowBasic)

# Remove historically underperforming rows and group column
ks.sc = ks.sc %>% filter(Group=="All Students") %>% select(-Group)

# Rename Columbia-Montour AVTS
ks.sc = ks.sc %>% mutate(across(School, str_replace, "COLUMBIA - MONTOUR AVTS", "COLUMBIA-MONTOUR AVTS"))
ks.sc = ks.sc %>% mutate(across(District, str_replace, "COLUMBIA - MONTOUR AVTS", "COLUMBIA-MONTOUR AVTS"))

# Clean up of Keystone School data
rm(ks.sc.2015)
rm(ks.sc.columbia.districts)
rm(ks.sc.montour.districts)
rm(ks.sc.2016)
rm(ks.sc.2017)
rm(ks.sc.2018)
rm(ks.sc.2019)
rm(ks.sc.2021)
rm(ks.sc.2022)
rm(ks.sc.cols)

# Keystone State Level Data
ks.st.2015 = readxl::read_xlsx("Keystone/State/2015.xlsx", skip=4)
ks.st.2016 = readxl::read_xlsx("Keystone/State/2016.xlsx", skip=4)
ks.st.2017 = readxl::read_xlsx("Keystone/State/2017.xlsx", skip=3)
ks.st.2018 = readxl::read_xlsx("Keystone/State/2018.xlsx", skip=3)
ks.st.2019 = readxl::read_xlsx("Keystone/State/2019.xlsx", skip=3)
# no 2020 data
ks.st.2021 = readxl::read_xlsx("Keystone/State/2021.xlsx", skip=4)
ks.st.2022 = readxl::read_xlsx("Keystone/State/2022.xlsx", skip=2)

# Organize columns
ks.st.2015 = ks.st.2015 %>% select(Subject, "N Scored", "Pct. Advanced", "Pct. Proficient", "Pct. Basic", "Pct. Below Basic", "Student Group")        %>% filter(ks.st.2015$"Student Group"=="All Students") %>% select(-"Student Group")
ks.st.2016 = ks.st.2016 %>% select(Subject, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", Group) %>% filter(Group=="All Students") %>% select(-Group)
ks.st.2017 = ks.st.2017 %>% select(Subject, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic")
ks.st.2018 = ks.st.2018 %>% select(Subject, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                         %>% filter(Group=="All Students") %>% select(-Group)
ks.st.2019 = ks.st.2019 %>% select(Subject, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                         %>% filter(Group=="All Students") %>% select(-Group)
ks.st.2021 = ks.st.2021 %>% select(Subject, "Number scored 2021", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                    %>% filter(Group=="All Students") %>% select(-Group)
ks.st.2022 = ks.st.2022 %>% select(Subject, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic")

# Column names
ks.st.cols = c("Subject", "Scored", "Advanced", "Proficient", "Basic",  "BelowBasic")
colnames(ks.st.2015) = ks.st.cols
colnames(ks.st.2016) = ks.st.cols
colnames(ks.st.2017) = ks.st.cols
colnames(ks.st.2018) = ks.st.cols
colnames(ks.st.2019) = ks.st.cols
colnames(ks.st.2021) = ks.st.cols
colnames(ks.st.2022) = ks.st.cols

# Create keystone state level tibble
ks.st = bind_rows(
  ks.st.2015 %>% mutate(Year="2015"),
  ks.st.2016 %>% mutate(Year="2016"),
  ks.st.2017 %>% mutate(Year="2017"),
  ks.st.2018 %>% mutate(Year="2018"),
  ks.st.2019 %>% mutate(Year="2019"),
  ks.st.2021 %>% mutate(Year="2021"),
  ks.st.2022 %>% mutate(Year="2022")
)
ks.st = ks.st %>% drop_na()

# Create baseline and score columns
ks.st = bind_rows(
  ks.st %>% mutate(Baseline="Advanced",   Score=Advanced) ,
  ks.st %>% mutate(Baseline="Proficient", Score=Proficient),
  ks.st %>% mutate(Baseline="Basic",      Score=Basic),
  ks.st %>% mutate(Baseline="BelowBasic", Score=BelowBasic)
) %>% arrange(Year) %>% select(-Advanced, -Proficient, -Basic, -BelowBasic)

# Clean up of Keystone state data
rm(ks.st.2015)
rm(ks.st.2016)
rm(ks.st.2017)
rm(ks.st.2018)
rm(ks.st.2019)
rm(ks.st.2021)
rm(ks.st.2022)
rm(ks.st.cols)

# Merge Keystone data
ks.st = ks.st %>% mutate(District="", School="", County="State")
ks = bind_rows(ks.st, ks.sc) %>% arrange(Year)
ks = ks %>% mutate(across(County, str_replace, "State", "0"))
ks = ks %>% mutate(across(County, str_replace, "Columbia", "1"))
ks = ks %>% mutate(across(County, str_replace, "Montour", "2"))
ks = ks %>% mutate(across(Subject, str_replace, "E", "English"))
ks = ks %>% mutate(across(Subject, str_replace, "M", "Math"))
ks = ks %>% mutate(across(Subject, str_replace, "S", "Science"))
ks = ks %>% mutate(across(Subject, str_replace, "Literature", "English"))
ks = ks %>% mutate(across(Subject, str_replace, "Algebra I", "Math"))
ks = ks %>% mutate(across(Subject, str_replace, "Biology", "Science"))
write_csv(ks, "Keystone/keystone.csv")
rm(ks.sc)
rm(ks.st)



# PSSA school level data
ps.sc.2015 = readxl::read_xlsx("PSSA/School/2015.xlsx", skip=6)
ps.sc.2016 = readxl::read_xlsx("PSSA/School/2016.xlsx", skip=4)
ps.sc.2017 = readxl::read_xlsx("PSSA/School/2017.xlsx", skip=4)
ps.sc.2018 = readxl::read_xlsx("PSSA/School/2018.xlsx", skip=4)
ps.sc.2019 = readxl::read_xlsx("PSSA/School/2019.xlsx", skip=4)
# no 2020 data
ps.sc.2021 = readxl::read_xlsx("PSSA/School/2021.xlsx", skip=6)[, 1:15]
ps.sc.2022 = readxl::read_xlsx("PSSA/School/2022.xlsx", skip=3)

# Organize columns
ps.sc.2015 = ps.sc.2015 %>% select("School Number", District, School, Subject, Group, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic")
ps.sc.2016 = ps.sc.2016 %>% select("School Number", District, School, Subject, Group, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", County)
ps.sc.2017 = ps.sc.2017 %>% select("School Number", "District Name", "School Name", Subject, Group, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", County)
ps.sc.2018 = ps.sc.2018 %>% select("School Number", "District Name", "School Name", Subject, Group, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ps.sc.2019 = ps.sc.2019 %>% select("School Number", "District Name", "School Name", Subject, Group, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ps.sc.2021 = ps.sc.2021 %>% select("School Number", "District Name", "School Name", Subject, Group, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)
ps.sc.2022 = ps.sc.2022 %>% select("School Number", "District Name", "School Name", Subject, "Student Group", Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", County)

# Column names
ps.sc.cols = c("SchoolNum", "District", "School", "Subject", "Group", "Grade", "Scored", "Advanced", "Proficient", "Basic", "BelowBasic", "County")
colnames(ps.sc.2015) = c("SchoolNum", "District", "School", "Subject", "Group", "Grade", "Scored", "Advanced", "Proficient", "Basic", "BelowBasic")
colnames(ps.sc.2016) = ps.sc.cols
colnames(ps.sc.2017) = ps.sc.cols
colnames(ps.sc.2018) = ps.sc.cols
colnames(ps.sc.2019) = ps.sc.cols
colnames(ps.sc.2021) = ps.sc.cols
colnames(ps.sc.2022) = ps.sc.cols

# Create PSSA school level tibble
ps.sc = bind_rows(
  ps.sc.2016 %>% mutate(Year="2016"),
  ps.sc.2017 %>% mutate(Year="2017"),
  ps.sc.2018 %>% mutate(Year="2018"),
  ps.sc.2019 %>% mutate(Year="2019"),
  ps.sc.2021 %>% mutate(Year="2021"),
  ps.sc.2022 %>% mutate(Year="2022")
)

# Add County column to 2015 data set from other years district
ps.sc.columbia.districts = ps.sc %>% filter(tolower(County) == "columbia") %>% select(District) %>% distinct()
ps.sc.montour.districts  = ps.sc %>% filter(tolower(County) == "montour")  %>% select(District) %>% distinct()
ps.sc.2015 = bind_rows(
  ps.sc.2015 %>% filter(District %in% ps.sc.columbia.districts) %>% mutate(County="Columbia"),
  ps.sc.2015 %>% filter(District %in% ps.sc.montour.districts)  %>% mutate(County="Montour")
) %>% mutate(Year="2015")

# Add 2015 data set to PSSA school data set
ps.sc = bind_rows(ps.sc.2015, ps.sc)

# County to common case
ps.sc$County = str_to_sentence(ps.sc$County)

# Select Columbia and Montour counties
ps.sc = ps.sc %>% filter(County %in% c("Columbia", "Montour")) %>% drop_na()

# Create baseline and score columns
ps.sc = bind_rows(
  ps.sc %>% mutate(Baseline="Advanced",   Score=Advanced) ,
  ps.sc %>% mutate(Baseline="Proficient", Score=Proficient),
  ps.sc %>% mutate(Baseline="Basic",      Score=Basic),
  ps.sc %>% mutate(Baseline="BelowBasic", Score=BelowBasic)
) %>% arrange(Year) %>% select(-Advanced, -Proficient, -Basic, -BelowBasic)

# Remove historically underperforming rows and group column
ps.sc = ps.sc %>% filter(Group=="All Students") %>% select(-Group)

# Clean up of PSSA school data
rm(ps.sc.2015)
rm(ps.sc.2016)
rm(ps.sc.2017)
rm(ps.sc.2018)
rm(ps.sc.2019)
rm(ps.sc.2021)
rm(ps.sc.2022)
rm(ps.sc.columbia.districts)
rm(ps.sc.montour.districts)
rm(ps.sc.cols)

# PSSA state level data
ps.st.2015 = readxl::read_xlsx("PSSA/State/2015.xlsx", skip=4)
ps.st.2016 = readxl::read_xlsx("PSSA/State/2016.xlsx", skip=4)
ps.st.2017 = readxl::read_xlsx("PSSA/State/2017.xlsx", skip=3)
ps.st.2018 = readxl::read_xlsx("PSSA/State/2018.xlsx", skip=4)
ps.st.2019 = readxl::read_xlsx("PSSA/State/2019.xlsx", skip=3)
# no 2020 data
ps.st.2021 = readxl::read_xlsx("PSSA/State/2021.xlsx", skip=3)
ps.st.2022 = readxl::read_xlsx("PSSA/State/2022.xlsx", skip=3)

# Join 2017 data into one set
ps.st.2017 = bind_rows(
  ps.st.2017[5:10,] %>% mutate(Subject="Math"),
  ps.st.2017[16:21,] %>% mutate(Subject="English Language Arts"),
  ps.st.2017[c(28, 32),] %>% mutate(Subject="Science")
)

# Organize columns
ps.st.2015 = ps.st.2015 %>% select(Subject, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                                   %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2016 = ps.st.2016 %>% select(Subject, Grade, "Number scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", Group)           %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2017 = ps.st.2017 %>% select(Subject, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic")
ps.st.2018 = ps.st.2018 %>% select(Subject, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                                   %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2019 = ps.st.2019 %>% select(Subject, Grade, "Number Scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                                   %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2021 = ps.st.2021 %>% select(Subject, Grade, "Number scored", "% Advanced", "% Proficient", "% Basic", "% Below Basic", Group)                                   %>% filter(Group=="All Students") %>% select(-Group)
ps.st.2022 = ps.st.2022 %>% select(Subject, Grade, "Number Scored", "Percent Advanced", "Percent Proficient", "Percent Basic", "Percent Below Basic", "Student Group") %>% filter(ps.st.2022$"Student Group"=="All Students") %>% select(-"Student Group")

# Column names
ps.st.cols = c("Subject", "Grade", "Scored", "Advanced", "Proficient", "Basic", "BelowBasic")
colnames(ps.st.2015) = ps.st.cols
colnames(ps.st.2016) = ps.st.cols
colnames(ps.st.2017) = ps.st.cols
colnames(ps.st.2018) = ps.st.cols
colnames(ps.st.2019) = ps.st.cols
colnames(ps.st.2021) = ps.st.cols
colnames(ps.st.2022) = ps.st.cols

# Create PSSA state level tibble
ps.st = bind_rows(
  ps.st.2015 %>% mutate(Year="2015"),
  ps.st.2016 %>% mutate(Year="2016"),
  ps.st.2017 %>% mutate(Year="2017"),
  ps.st.2018 %>% mutate(Year="2018"),
  ps.st.2019 %>% mutate(Year="2019"),
  ps.st.2021 %>% mutate(Year="2021", across(Grade, as.character)),
  ps.st.2022 %>% mutate(Year="2022")
)
ps.st = ps.st

# Create baseline and score columns
ps.st = bind_rows(
  ps.st %>% mutate(Baseline="Advanced",   Score=Advanced) ,
  ps.st %>% mutate(Baseline="Proficient", Score=Proficient),
  ps.st %>% mutate(Baseline="Basic",      Score=Basic),
  ps.st %>% mutate(Baseline="BelowBasic", Score=BelowBasic)
) %>% arrange(Year) %>% select(-Advanced, -Proficient, -Basic, -BelowBasic) %>% 
  mutate(across(Grade, str_replace, "State Total", "Total"))

# Clean up PSSA state data
rm(ps.st.2015)
rm(ps.st.2016)
rm(ps.st.2017)
rm(ps.st.2018)
rm(ps.st.2019)
rm(ps.st.2021)
rm(ps.st.2022)
rm(ps.st.cols)

# Merge PSSA data
ps.st = ps.st %>% mutate(District="", School="", School="", County="State")
ps = bind_rows(ps.st, ps.sc) %>% arrange(Year)
ps = ps %>% mutate(across(County, str_replace, "State", "0"))
ps = ps %>% mutate(across(County, str_replace, "Columbia", "1"))
ps = ps %>% mutate(across(County, str_replace, "Montour", "2"))
ps = ps %>% mutate(across(Subject, str_replace, "English Language Arts", "English"))
write_csv(ps, "PSSA/pssa.csv")
rm(ps.sc)
rm(ps.st)

# Cohorts
cohort.1 = bind_rows(
  ps %>% filter(Year==2015 & Grade==4 & County!=0),
  ps %>% filter(Year==2016 & Grade==5 & County!=0),
  ps %>% filter(Year==2017 & Grade==6 & County!=0),
  ps %>% filter(Year==2018 & Grade==7 & County!=0),
  ps %>% filter(Year==2019 & Grade==8 & County!=0),
  ks %>% filter(Year==2022 & County!=0) %>% mutate(Grade="11", SchoolNum="")
) %>% mutate(Cohort=1)

cohort.2 = bind_rows(
  ps %>% filter(Year==2015 & Grade==5 & County!=0),
  ps %>% filter(Year==2016 & Grade==6 & County!=0),
  ps %>% filter(Year==2017 & Grade==7 & County!=0),
  ps %>% filter(Year==2018 & Grade==8 & County!=0),
  ks %>% filter(Year==2021 & County!=0) %>% mutate(Grade="11", SchoolNum="")
) %>% mutate(Cohort=2)

cohort.3 = bind_rows(
  ps %>% filter(Year==2015 & Grade==7 & County!=0),
  ps %>% filter(Year==2016 & Grade==8 & County!=0),
  ks %>% filter(Year==2019 & County!=0) %>% mutate(Grade="11", SchoolNum="")
) %>% mutate(Cohort=3)

cohort.4 = bind_rows(
  ps %>% filter(Year==2015 & Grade==8 & County!=0),
  ks %>% filter(Year==2018 & County!=0) %>% mutate(Grade="11", SchoolNum="")
) %>% mutate(Cohort=4)

cohorts = bind_rows(
  cohort.1,
  cohort.2,
  cohort.3,
  cohort.4
)

write_csv(cohorts, "Cohorts/cohorts.csv")
rm(cohort.1)
rm(cohort.2)
rm(cohort.3)
rm(cohort.4)

# Recreate PSSA data with aggregations where possible



# End Suppress Warnings
options(warn=0)
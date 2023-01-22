# State Testing Analysis

![Fletcher](/Resources/fletcher.jpg)

# Introduction
The aim of this project is to understand the performance of public school students in Columbia and Montour counties in Pennsylvania.
It was requested by Jeffrey Emanuel, the director of the Foundation of the Columbia Montour Chamber of Commerce.
Our professor Dr. Calhoun, of the Bloomsburg University of Pennsylvania, advises and coordinates with us on this project.
Our team consists of senior data science students [Kadir Altunel](https://github.com/KadirOrcunAltunel), [Anna Schlecht](https://github.com/atschlecht) and myself [Ronny Toribio](https://github.com/ronny-phoenix).

##### There are three major tasks in this project:
- [Data Wrangling](#data-wrangling) - Worked on by me
    - [data_wrangling.R](/data_wrangling.R)
- [Project Objectives](#project-objectives) - Worked on by our team
    - [objectives.R](/objectives.R)
    - [api.R](/api.R)
- [Dashboard](#r-shiny-dashboard) - Worked on by me
    - [app.R](/app.R)
    - [ui.R](/ui.R)
    - [server.R](/server.R)

# Abstract
In our first objective where we view the trends of Columbia and Montour counties we notice the percent of top scores decline from before the pandemic 7.57 percent points in Columbia county and 9.19 in Montour county. For the Keystone tests Columbia county saw a dip of 3.57 points over the 2020 gap. While Montour improved in 2021 by 10 points rebounded back down 10 points. In our second objective we compared the local counties with the state in general. In Pennsylvania as a whole PSSA scores declined 9.85 points after the pandemic. That's 2.28 points worse than Columbia county and roughly the same as Montour county. For the Keystone, Pennsylvania as a whole dipped 2.69 points. Columbia county did slightly worse at 3.57 points. Montour county actually improved by 10.75 points.

In our third objective we compared the trends of Columbia and Montour counties, and state in general in terms of subjects English, Math and Science to evaluate whether COVID-19 caused any significant impact on top scores overall. While PSSA scores dipped slightly for all subjects in 2021, Science scores in Keystone had a sharp decline in 2022 in all levels demonstrating a possible COVID-19 impact.

In our fourth objective, we compared average of top yearly test scores organized by subject. For the PSSA, we have very different results in comparison to the Keystone analysis. The first thing we noticed was a drastic change in scores compared to the other years for 2017. Both english and science scores significantly suffered. In 2017, math scores were also higher than usual. From 2021 to 2022, we saw math and english scores slightly declined from before the pandemic, while science scores remained within the same range as before the pandemic. This is interesting considering it is the highest science score average across all years.
When analyzing the data for Keystone Score averages by subject, the averages of cumulative scores between english, math, and science. Interestingly, english and science seem to have flucuated within 2021 to 2022. Both of these results demonstrate the possibility for a change in performance on both of these tests due to the COVID-19 pandemic.

In our fifth objective, we were comparing cumulative averages of top yearly scores by district. When comparing both PSSA and Keystone test averages, we could see no noticable correlation between districts and test scores. Because of this, we could not comclude anything related to the impact of COVID-19.

In our sixth objective we compared the cohorts of students passing from one grade to the next during certain years. By taking the PSSA scores for grades 5-8 and Keystone scores for grade 11. The first Cohort ranges from 2016 to 2019. The second goes from 2016 to 2021. The third cohort goes from 2016 to 2022. For Pennsylvania cohort two improves by 14.5 points. While cohort 3 slightly improves 1.87 points. This suggests a slight lag in the effects of COVID from 2021 to 2022. In Columbia county cohort two also improves this time by 16.93 points while cohort three is slightly decline across all grades. Montour counties cohorts don't seem to be affected at all by the pandemic. Cohort two increases by 31.1 points and cohort three increases by 16.57 points. They end up at 95.51 and 82.46 percent top scores for their cohorts respectively. Showing a slight decrease from one to the next.


In doing statistical tests and graphing different views of the top scores arranged by different we generally came to the conclusion that COVID 19 had an effect on test scores after 2020 especially on Science.

# Data Wrangling
The data sets used in this project are the results from the [PSSA](https://www.education.pa.gov/DataAndReporting/Assessments/Pages/PSSA-Results.aspx) and [Keystone](https://www.education.pa.gov/DataAndReporting/Assessments/Pages/Keystone-Exams-Results.aspx) state tests.
These sets contain aggregate data at the state level for both the PSSA and Keystone.
They contain more granular data at the school level including counties, districts and schools.

To wrangle this data and prepare it for analysis I created a script in R [data_wrangling.R](/data_wrangling.R) that loads the raw XLSX files and generates 3 CSV files.
The XLSX files are organized by year (2015 - 2022) and level (state, local).

##### The files generated are:
- [pssa.csv](/PSSA/pssa.csv) - A data set containing the PSSA data at the state and local levels for use in R.
- [keystone.csv](/Keystone/keystone.csv) - A data set containing the Keystone data at the state and local levels.
- [cohorts.csv](/Cohorts/cohorts.csv) - A data set containing both PSSA and Keystone data at the state and local levels that follows cohorts.

### Data Conventions

##### Score categories:
- Top (Created by adding Advanced and Proficient)
- Advanced
- Proficient
- Basic
- Below Basic

##### The convention used for subjects is the following:
- English - is used for English, English Language Arts and Literature
- Math - is used for Math and Algebra I
- Science - is used for Science and Biology

##### The convention for cohorts is:
- 1 - Cohort 1: Grade 8 (2016), Grade 11 (2019)
- 2 - Cohort 2: Grade 6 (2016), Grade 7 (2017), Grade 8 (2018), Grade 11 (2021)
- 3 - Cohort 3: Grade 5 (2016), Grade 6 (2017), Grade 7 (2018), Grade 8 (2019), Grade 11 (2022)
Grades 5-8 were extracted from the PSSA set.
Grade 11 was extracted from the Keystone set.

### Issues, mitigations, design choices
- The PSSA and Keystone local level data set for 2015 doesn't have a County column.
   - **Mitigation**: I used the school districts from Columbia and Montour counties from the following years to select them in 2015.
- Columbia county data is mostly missing for 2015.
   - **Mitigation**: I removed 2015 data and the cohort which was in Grade 8 in 2015
- For the Keystone sets all Grades are 11
   - **Mitigation**: I selected Grade == "Total" and dropped the Grade Column to avoid duplicate entries.
- There was a group column in PSSA and Keystone whose values were "All students" or "Historically Underperforming" that was not available for all years.
   - **Mitigation**: I selected Group == "All Students" and dropped the group column.
- The original data sets contained the columns Advanced, Proficient, Basic, BelowBasic but Kadir needed them as a type column and percent column for ANOVA testing.
   - **Mitigation**: I used the names of the columns as a type (Category) and their values as the percentage (Score).
- Dr. Calhoun suggested creating a Top type by summing Advanced and Proficient.
- Dr. Calhoun noticed that in some of our analysis we were taking averages of percentages that had different sizes and suggested weighted averages.
   - **Mitigation**: I created a column named Students by multiplying Scores by the amount of students Scored.
- The PSSA state level data for 2017 and 2022 don't include a "Total".
   - **Mitigation**: For English and Math I used the other grades to recreate a "Total" row.
   - **No mitigation**: Science doesn't have the individual Grades to recreate a "Total" from.
- The PSSA for 2021 doesn't include score percentages for all subjects.
   - **No mitigation**


# Project Objectives
1. [How our local districts in Columbia and Montour Counties are trending since 2016?](#objective-1-how-our-local-districts-in-columbia-and-montour-counties-are-trending-since-2016) (Anna)
2. [How they compare to the state trend since 2016?](#objective-2-how-they-compare-to-the-state-trend-since-2016) (Kadir)
3. [Is there any COVID impact we might be able to deduce?](#objective-3-is-there-any-covid-impact-we-might-be-able-to-deduce) (Kadir)
4. [Visualizing the averages of scores from each year grouped by subject.](#objective-4-visualizing-the-averages-of-scores-from-each-year-grouped-by-subject) (Anna)
5. [Compare scores between districts.](#objective-5-compare-scores-between-districts) (Anna)
6. [Study cohorts as they progress from PSSA to Keystone](#objective-6-cohort-analysis) (Ronny)


# Objective 1: How our local districts in Columbia and Montour Counties are trending since 2016?

##### PSSA

![Obj1PS](/Graphs/Obj1PS.png)



We see from taking the averages of top PSSA scores from Columbia and Montour counties, Montour county has the highest average overall of people scoring with top scores in comparision to Columbia county from 2016 to 2022. Montour county score averages also stayed pretty regular before and after the pandemic, ranging with the 60 percent region, with only a minor spike leading towards the beginning of the pandemic. Meanwhile with Columbia county scores, before the pandemic they were averaging within the lower 60 percent range and declined the following years after the pandemic to the lower end of 50 percent scores. This could be a result of the pandemic along with the option of opting out of testing provided to students after the pandemic. 


##### Keystone

![Obj1KS](/Graphs/Obj1KS.png)


We see from taking the averages of top Keystone scores from Columbia and Montour counties, Montour county has the highest average overall of people scoring with top scores in comparision to Columbia county from 2016 to 2022. Montour county score averages also stayed pretty regular before and after the pandemic, ranging with the 80 and 90 percent. Meanwhile with Columbia county scores, before the pandemic they were averaging within the 70 percent range and declined the following years after the pandemic to around 60 and 50 percent. This could be a result of the pandemic along with the option of opting out of testing provided to students after the pandemic. 


# Objective 2: How they compare to the state trend since 2016?




##### PSSA

Pennsylvania | Columbia County | Montour County
:----:|:---------------:|:--------------:
![obj2_ps_st](/Graphs/Obj2statePS.png) | ![obj2_ps_col](/Graphs/Obj2columbiaPS.png) | ![obj2_ps_mon](/Graphs/Obj2montourPS.png)

PSSA data also shows similar observations all levels for the top category.

For state level, average score percentage dipped in 2017 and went back to 2016 levels in 2018 and 2019. There was a decline in 2021 and a slight increase in 2022

In Columbia County, average score percentage stayed steady from 2016 to 2019. There was a decline in percentage in 2021 which showed some recovery in 2022.

In Montour County, average score percentage rose all time high in 2019 in observed years (2016-2022). There was a sharp decline in 2021 and some recovery in 2022. 

##### Keystone

Pennsylvania | Columbia County | Montour County
:----:|:---------------:|:--------------:
![obj2_ks_st](/Graphs/Obj2stateKS.png) | ![obj2_ks_col](/Graphs/Obj2columbiaKS.png) | ![obj2_ks_mon](/Graphs/Obj2montourKS.png)


When we look at the graphs, we see that top category, which combines advanced and proficient categories, fluctuates for every levels (State, Montour County, and Columbia County).

For state level, average score percentage for top category is trending lower than its high in 2016. We see that average score percentage declined in 2017 and rose in 2018 and then started declining again for the rest of the years.

In Columbia County, average score for the top category is also trending lower than its high in 2016. We see that average score percentage declined in 2017 and rose in 2018 and stayed steady for 2019. However, it started to dip in 2021 and 2022

In Montour County, average score for the top category shows fluctuations for the years observed. The average score percentage dipped in 2017 only to rise and dip again in 2018 and 2019 respectively. The same pattern of rise and dip was also observed in 2021 and 2022.


# Objective 3: Is there any COVID impact we might be able to deduce?

##### PSSA English

Pennsylvania | Columbia County | Montour County
:----:|:---------------:|:--------------:
| ![obj3_ps_eng_st](/Graphs/Obj3stateEngPS.png) | ![obj2_ps_eng_col](/Graphs/Obj3columbiaEngPS.png) | ![obj2_ps_eng_mon](/Graphs/Obj3montourEngPS.png) |

##### PSSA Math

Pennsylvania | Columbia County | Montour County
:----:|:---------------:|:--------------:
| ![obj3_ps_math_st](/Graphs/Obj3stateMathPS.png) | ![obj2_ps_math_col](/Graphs/Obj3columbiaMathPS.png) | ![obj2_ps_math_mon](/Graphs/Obj3montourMathPS.png) |

##### PSSA Science

Pennsylvania | Columbia County | Montour County
:----:|:---------------:|:--------------:
| ![obj3_ps_sci_st](/Graphs/Obj3stateSciPS.png) | ![obj2_ps_sci_col](/Graphs/Obj3columbiaSciPS.png) | ![obj2_ps_sci_mon](/Graphs/Obj3montourSciPS.png) |

##### Keystone English

Pennsylvania | Columbia County | Montour County
:----:|:---------------:|:--------------:
| ![obj3_ks_eng_st](/Graphs/Obj3stateEngKS.png) | ![obj2_ks_eng_col](/Graphs/Obj3columbiaEngKS.png) | ![obj2_ks_eng_mon](/Graphs/Obj3montourEngKS.png) |

##### Keystone Math

Pennsylvania | Columbia County | Montour County
:----:|:---------------:|:--------------:
| ![obj3_ks_math_st](/Graphs/Obj3stateMathKS.png) | ![obj2_ks_math_col](/Graphs/Obj3columbiaMathKS.png) | ![obj2_ks_math_mon](/Graphs/Obj3montourMathKS.png) |

##### Keystone Science

Pennsylvania | Columbia County | Montour County
:----:|:---------------:|:--------------:
| ![obj3_ks_sci_st](/Graphs/Obj3stateSciKS.png) | ![obj2_ks_sci_col](/Graphs/Obj3columbiaSciKS.png) | ![obj2_ks_sci_mon](/Graphs/Obj3montourSciKS.png) |

##### PSSA ANOVA Summary

```
                      Df Sum Sq Mean Sq F value   Pr(>F)    
Year                   1    374     374   2.800  0.09447 .  
as_factor(County)      1     33      33   0.250  0.61746    
as_factor(District)    5   1664     333   2.490  0.02952 *  
as_factor(School)     18   5222     290   2.171  0.00303 ** 
as_factor(Subject)     2   8434    4217  31.558 3.61e-14 ***
Scored                 1    363     363   2.717  0.09951 .  
as_factor(Category)    4 533718  133429 998.497  < 2e-16 ***
Students               1  38800   38800 290.353  < 2e-16 ***
Residuals           1601 213942     134                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

##### Keystone ANOVA Summary

```
                     Df Sum Sq Mean Sq F value   Pr(>F)    
Year                  1    531     531   4.913  0.02698 *  
as_factor(County)     1    810     810   7.491  0.00636 ** 
as_factor(District)   7   5450     779   7.202 2.41e-08 ***
as_factor(School)     1      0       0   0.002  0.96902    
as_factor(Subject)    2    281     141   1.301  0.27285    
Scored                1    199     199   1.837  0.17577    
as_factor(Category)   4 389399   97350 900.500  < 2e-16 ***
Students              1  87868   87868 812.788  < 2e-16 ***
Residuals           706  76323     108                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

When we look at both Keystone and PSSA data, we can clearly see that, COVID-19 has impacted top score average percentages. Especially in 2021, we see a sharp decline in all levels (State, Columbia County and Montour County). However, starting 2022, we see some recovery in percentages in those levels. 

However, there's no linearity between years and average score percentages so as to say, we don't see an upward or downward trend every year. The ANOVA table also indicates the absence of linearity in trend without any significant impact between top score average percentages and year.


# Objective 4: Visualizing the averages of scores from each year grouped by subject.

##### PSSA

![Obj4PSA](/Graphs/Obj4PS.png) 

For the PSSA Top Yearly Testing Averages by Subject, we have very different results in comparison to the Keystone analysis. The first thing we noticed was a drastic change in scores compared to the other years for 2017. Both english and science scores significantly suffered at 42.76% and 25.58% respectively. This is interesting since english scores for PSSAs usually averaged around 50 to 60 percent and science averaged around 60 and 70 percent. In 2017, math scores were also higher than usual at 61.1%, when the averages for the other years ranged from 30 to 40 percent. From 2021 to 2022, we can see math and english scores slightly declined from before the pandemic, while science scores remained within the same range as before the pandemic, and even in the case of 2021, were better than before the pandemic at 72.02%. This is interesting considering it is the highest science score average across all years. These scores seem to correlate with the timing of the pandemic and could be the cause of these scores.

##### Keystone

![Obj4KSA](/Graphs/Obj4KS.png) 

We see when analyzing the data for Keystone Score averages by subject, the averages of cumulative scores between english, math, and science. Interestingly, english and science seem to have flucuated within 2021 to 2022. On average before these years, english scores lie around 60 and 70 percent. After 2020, these english scores average between 40 and 50 percent. As for science, scores ranged within 50 to 60 percent all the way up to 2021, however, there was a drastic decline in scores in 2022 with the cumulative average scores for science being on 36.14%. With this information, some subject scores definetely could have been impacted by the most recent pandemic.

# Objective 5: Compare scores between districts.

##### PSSA

![Obj5PS](/Graphs/Obj5PS.png)

When comparing PSSA average scores between districts, there seems to be no correlation between districts and has no conclusive evidence towards an affect due to the pandemic.


##### Keystone

![Obj5KS](/Graphs/Obj5KS.png)

When comparing Keystone average scores between districts, there seems to be no correlation between districts and has no conclusive evidence towards an affect due to the pandemic.


# Objective 6: Cohort analysis

##### Cohort timeline

![obj6a_timeline](/Graphs/Obj6_timeline.png)
```
            |<------PSSA----->|
                              |<---Keystone--->|
         2016, 2017, 2018, 2019, 2020, 2021, 2022
Cohort 1    8                11
Cohort 2    6     7     8                11
Cohort 3    5     6     7     8                11
```

##### Cohorts State

![obj6a](/Graphs/Obj6_state.png)

In cohort 1 we see an increase of 16.94 percentage points from grade 8 to grade 11. In cohort 2 we see the grades stay stable between grades 7 and 8 then rising 14.53 percentage points at grade 11. In cohort 3 we see a dip between grades 5 and 6 of 12.55 percent points. Followed by a rebound to almost the grade 5 level in grade 7. For the rest of the grades their percentages stay stable with no real bump between grades 8 and 11 like in previous cohorts suggesting that they may have affected by the pandemic.

##### Cohorts Columbia

![obj6b_columbia](/Graphs/Obj6_columbia.png)

In cohort 1 Columbia county outperforms the state of pennsylvania. In cohort 2 we're missing grades 5 and 6. Grade 7 begins one point below the state average then overtakes it by a few points in grade 8. In grade 11 Columbia county outperforms the state by around 6 percentage points. Cohort 3 breaks with the state pattern and the grades gradually worsen by up to 4 percentage points in some years. Even so the grades in cohort 3 stay above the state percentages. 

##### Cohorts Montour

![obj6b_montour](/Graphs/Obj6_montour.png)

In cohort 1 Montour county outperforms both the state and Columbia county gaining 24.64 percentage points between grades 8 and 11. In cohort 2 the percentages stay stable above the state from grades 6 to 8. In grade 11 there is a 31.10 point jump in their percentages. Cohort 3 is also higher than both the state and columbia county. There is a 7 point dip from grade 5 to 6. Then it slightly ascends from 61.56 in grade 6 to 65.9 in grade 8. Finally, it jumps 16.57 percent points landing at 82.46 outperforming both the state and columbia county.

# R Shiny Dashboard

![Dashboard](/Resources/dashboard.png)

I've decided to create a dashboard in R Shiny that could be used to explore every objective and interactively change their values. The dashboard can be launched in R Studio and viewed in your web browser. It allows you to create custom views not shown in this README.

##### Setup
The dashboard works with rstudio and uses the following libraries
- tidyverse
- shiny

To install these libraries in rstudio use the function
```r
install.packages("tidyverse", "shiny")
```

##### Running the dashboard
Once you have the necessary libraries installed you can run the following
```r
library(shiny)

runGitHub("StateTestingAnalysis", "ronny-phoenix")

```

# Authors
- [Ronny Toribio](https://github.com/ronny-phoenix) - Project lead, Data Wrangling, Statistical Analysis
- [Anna Schlecht](https://github.com/atschlecht) - Statistical Analysis
- [Kadir Altunel](https://github.com/KadirOrcunAltunel) - Statistical Analysis
- [Fletcher](/Resources/fletcher.jpg) - Kadir's Pet Cat

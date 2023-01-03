# State Testing Analysis

![Fletcher](/Resources/fletcher.jpg)

### Objectives
1. How our local districts in Columbia and Montour Counties are trending since 2015?
2. How they compare to the state trend since 2015?
3. Is there any COVID impact we might be able to deduce?
4. Visualizing the averages of scores from each year.
   - As a whole
   - Grouped by subject
   - Grouped by district
5. Compare scores between districts.
6. Study cohorts as they progress from PSSA to Keystone
7. Any other information that data might tell us?

### Objective 2: How they compare to the state trend since 2015?

##### Keystone

![obj2a](/Resources/Obj2a.png)

We see that in general, Montour and Colombia county fared better than State 
since 2015 in terms of baseline levels. Basic level showed a sharp increase in Montour
and Colombia counties in 2022. Proficient level also showed a sharp
increase especially in 2022 for Montour county

##### PSSA

![obj2b](/Resources/Obj2b.png)

**Top** baseline showed a slight decline between 2019 - 2021 in State and Colombia County.
Top baseline remained steady in Montour throughout the time frame. 

**Advanced** baseline showed a sharp decline in Colombia County and State from 2019
to 2021. Montour County baseline were pretty much stable.

**Proficient** baseline showed an increase in Colombia County in 2021 and then
it swung back to its previous levels in 2022. State and Montour County fluctuated
slightly throughout the time frame without any significant observation.

**Basic** baseline  dropped slightly in Colombia county from 2018 to 2019. It remained
steady in State from 2017 to 2019. Montour County showed a slight decline
in 2019. Basic baseline increased in both counties and state in 2021, only to
drop slightly in Montour County and State in 2022. Colombia County showed
a moderate decline in Basic baseline. 

**BelowBasic** baseline remained stable for Montour County until 2019. There was a
sharp increase between 2016 and 2017 in Colombia County and State. Both
counties and state showed a decline in BelowBasic baseline in 2019. There was
a significant increase in all places in the baseline from 2019 to 2021,
especially in Colombia. From 2021 to 2022, baseline remained stable in State 
and dropped moderately in both counties

### Objective 3: Is there any COVID impact we might be able to deduce?

##### Keystone

![obj3a](/Resources/Obj3a.png)

Checking baseline averages throughout the years for counties and subjects, it
is interesting to see that COVID didn't impact Math and English for baselines
dramatically for Colombia, Montour and State. In fact, there was a significant
improvement in the scores in 2022 compared to 2019 for math top, advanced
and proficient baseline in Colombia county.
However, there was a steep decline in Science for baselines between 2021
and 2022 throughout the state which may be an indication of a COVID impact.

##### PSSA

![obj3b](/Resources/Obj3b.png)

From 2019 to 2022, baseline levels seemed stable for the counties and the state
There were only slight fluctuations which were inconclusive if COVID affected
baseline levels or not.

### Contents
- /Cohorts/       (Generated Cohorts Data)
- /Keystone/      (Keystone Exams Data)
- /PSSA/          (PSSA Exams Data)
- analysis.R      (Analysis of the data)
- cohort.R        (Cohort study)
- testing_data.py (Processes and Generates data sets)

### Authors
- [Ronny Toribio](https://github.com/ronny-phoenix) - Project lead, Data Wrangling
- [Anna T. Schlecht](https://github.com/atschlecht) - Graphs 
- [Kadir O. Altunel](https://github.com/KadirOrcunAltunel-zz) - Statistical Analysis
- [John Seibert](https://github.com/johnseibert19) - Cohort Analysis

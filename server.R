# @author:  Ronny Toribio
# @project: State Testing Analysis
# @file:    server.R
# @desc:    Server component for dashboard

source("api.R")
library("jpeg")
library("grid")

years_range = function(years){
  seq(from=years[1], to=years[2], by=1)
}

get_county_colors = function(counties){
  colors = c()
  for(i in counties){
    colors = c(colors, county_color_list[i])
  }
  colors
}

gen_empty_image = function(){
  j = readJPEG(
    "Resources/fletcher.jpg",
    native = TRUE
  )
  j = rasterGrob(j, interpolate = TRUE)
  qplot() + 
    labs(title = "Empty Dataset") +
    annotation_custom(
      j, 
      xmin = -Inf, 
      xmax = Inf,
      ymin = -Inf,
      ymax = Inf
    )
}

server = function(input, output){
  years = reactive(input$years)
  objective = reactive(input$objectives)
  datasets = reactive(input$datasets)
  counties = reactive(input$counties)
  counties_local = reactive(input$counties_local)
  counties_radio = reactive(input$counties_radio)
  subjects = reactive(input$subjects)
  subjects_radio = reactive(input$subjects_radio)
  categories = reactive(input$categories)
  grades = reactive(input$grades)
  
  # Graphs
  output$graph = renderPlot({
    obj_var = objective()
    
    if(obj_var < 6){
      # Select dataset
      ds_var = datasets()
      ds = tibble()
      if(ds_var == 1){
        ds = ps
      }
      else{
        ds = ks
      }
      
      # Filter dataset
      ds = ds %>%
        filter(Year %in% years_range(years())) %>%
        filter(Category %in% categories())
      if(obj_var == 1 || obj_var == 5){
        ds = ds %>% filter(County %in% counties_local())
      }
      else if(obj_var == 2 || obj_var == 3){
        ds = ds %>% filter(County %in% counties_radio())
      }
      else{
        ds = ds %>% filter(County %in% counties())
      }
      if(obj_var == 3){
        ds = ds %>% filter(Subject %in% subjects_radio())
      }
      else{
        ds = ds %>% filter(Subject %in% subjects())
      }
      
      # Graph
      if(length(ds$Score) == 0){
        gen_empty_image()
      }
      else if(obj_var == 1){
        gen_trends1(ds, get_county_colors(counties_local()), "Objective 1")
      }
      else if(obj_var == 2){
        gen_trends2(ds, get_county_colors(counties_radio()), "Objective 2")
      }
      else if(obj_var == 3){
        gen_trends3(ds, get_county_colors(counties_radio()), "Objective 3")
      }
      else if(obj_var == 4){
        gen_trends4(ds, "Objective 4")
      }
      else if(obj_var == 5){
        gen_trends5(ds, "Objective 5")
      }
    }
    else if(obj_var > 5){
      ds = cohorts %>%
        filter(Year %in% years_range(years())) %>%
        filter(County %in% counties_radio()) %>%
        filter(Subject %in% subjects()) %>%
        filter(Category %in% categories()) %>%
        filter(Grade %in% grades())
      if(length(ds$Score) == 0){
        gen_empty_image()
      }
      else if(obj_var == 6){
        gen_trends6(ds, "Objective 6")
      }
      else if(obj_var == 7){
        gen_cohorts_timeline(ds)
      }
    }
  })
  

  # Interpretations
  output$interpretation = renderUI({
    obj_var = objective()
    if(obj_var == 1){
      if(datasets() == 1){
        p("We see from taking the averages of top PSSA scores from Columbia and Montour counties, Montour county has the highest average overall of people scoring with top scores in comparision to Columbia county from 2016 to 2022. Montour county score averages also stayed pretty regular before and after the pandemic, ranging with the 60 percent region, with only a minor spike leading towards the beginning of the pandemic. Meanwhile with Columbia county scores, before the pandemic they were averaging within the lower 60 percent range and declined the following years after the pandemic to the lower end of 50 percent scores. This could be a result of the pandemic along with the option of opting out of testing provided to students after the pandemic.", style = "width:14in")
      }
      else{
        p("We see from taking the averages of top Keystone scores from Columbia and Montour counties, Montour county has the highest average overall of people scoring with top scores in comparision to Columbia county from 2016 to 2022. Montour county score averages also stayed pretty regular before and after the pandemic, ranging with the 80 and 90 percent. Meanwhile with Columbia county scores, before the pandemic they were averaging within the 70 percent range and declined the following years after the pandemic to around 60 and 50 percent. This could be a result of the pandemic along with the option of opting out of testing provided to students after the pandemic.", style = "width:14in")
      }
    }
    else if(obj_var == 2){
      if(datasets() == 1){
        p("PSSA data also shows similar observations all levels for the top category.

For state level, average score percentage dipped in 2017 and went back to 2016 levels in 2018 and 2019. There was a decline in 2021 and a slight increase in 2022

In Columbia County, average score percentage stayed steady from 2016 to 2019. There was a decline in percentage in 2021 which showed some recovery in 2022.

In Montour County, average score percentage rose all time high in 2019 in observed years (2016-2022). There was a sharp decline in 2021 and some recovery in 2022.", style = "width:14in")
      }
      else{
        p("When we look at the graphs, we see that top category, which combines advanced and proficient categories, fluctuates for every levels (State, Montour County, and Columbia County).

For state level, average score percentage for top category is trending lower than its high in 2016. We see that average score percentage declined in 2017 and rose in 2018 and then started declining again for the rest of the years.

In Columbia County, average score for the top category is also trending lower than its high in 2016. We see that average score percentage declined in 2017 and rose in 2018 and stayed steady for 2019. However, it started to dip in 2021 and 2022

In Montour County, average score for the top category shows fluctuations for the years observed. The average score percentage dipped in 2017 only to rise and dip again in 2018 and 2019 respectively. The same pattern of rise and dip was also observed in 2021 and 2022.", style = "width:14in")
      }
    }
    else if(obj_var == 3){
      p("When we look at both Keystone and PSSA data, we can clearly see that, COVID-19 has impacted top score average percentages. Especially in 2021, we see a sharp decline in all levels (State, Columbia County and Montour County). However, starting 2022, we see some recovery in percentages in those levels.

However, there's no linearity between years and average score percentages so as to say, we don't see an upward or downward trend every year. The ANOVA table also indicates the absence of linearity in trend without any significant impact between top score average percentages and year.", style = "width:14in")
    }
    else if(obj_var == 4){
      if(datasets() == 1){
        p("For the PSSA Top Yearly Testing Averages by Subject, we have very different results in comparison to the Keystone analysis. The first thing we noticed was a drastic change in scores compared to the other years for 2017. Both english and science scores significantly suffered at 42.76% and 25.58% respectively. This is interesting since english scores for PSSAs usually averaged around 50 to 60 percent and science averaged around 60 and 70 percent. In 2017, math scores were also higher than usual at 61.1%, when the averages for the other years ranged from 30 to 40 percent. From 2021 to 2022, we can see math and english scores slightly declined from before the pandemic, while science scores remained within the same range as before the pandemic, and even in the case of 2021, were better than before the pandemic at 72.02%. This is interesting considering it is the highest science score average across all years. These scores seem to correlate with the timing of the pandemic and could be the cause of these scores.", style = "width:14in")
      }
      else{
        p("We see when analyzing the data for Keystone Score averages by subject, the averages of cumulative scores between english, math, and science. Interestingly, english and science seem to have flucuated within 2021 to 2022. On average before these years, english scores lie around 60 and 70 percent. After 2020, these english scores average between 40 and 50 percent. As for science, scores ranged within 50 to 60 percent all the way up to 2021, however, there was a drastic decline in scores in 2022 with the cumulative average scores for science being on 36.14%. With this information, some subject scores definetely could have been impacted by the most recent pandemic.", style = "width:14in")
      }
    }
    else if(obj_var == 5){
      if(datasets() == 1){
        p("When comparing PSSA average scores between districts, there seems to be no correlation between districts and has no conclusive evidence towards an affect due to the pandemic.", style = "width:14in")
      }
      else{
        p("When comparing Keystone average scores between districts, there seems to be no correlation between districts and has no conclusive evidence towards an affect due to the pandemic.", style = "width:14in")
      }
    }
    else if(obj_var == 6){
      if(counties_radio() == "State"){
        p("In cohort 1 we see an increase of 16.94 percentage points from grade 8 to grade 11. In cohort 2 we see the grades stay stable between grades 7 and 8 then rising 14.53 percentage points at grade 11. In cohort 3 we see a dip between grades 5 and 6 of 12.55 percent points. Followed by a rebound to almost the grade 5 level in grade 7. For the rest of the grades their percentages stay stable with no real bump between grades 8 and 11 like in previous cohorts suggesting that they may have affected by the pandemic.", style = "width:14in")
      }
      else if(counties_radio() == "Columbia"){
        p("In cohort 1 Columbia county outperforms the state of pennsylvania. In cohort 2 we're missing grades 5 and 6. Grade 7 begins one point below the state average then overtakes it by a few points in grade 8. In grade 11 Columbia county outperforms the state by around 6 percentage points. Cohort 3 breaks with the state pattern and the grades gradually worsen by up to 4 percentage points in some years. Even so the grades in cohort 3 stay above the state percentages.", style = "width:14in")
      }
      else if(counties_radio() == "Montour"){
        p("In cohort 1 Montour county outperforms both the state and Columbia county gaining 24.64 percentage points between grades 8 and 11. In cohort 2 the percentages stay stable above the state from grades 6 to 8. In grade 11 there is a 31.10 point jump in their percentages. Cohort 3 is also higher than both the state and columbia county. There is a 7 point dip from grade 5 to 6. Then it slightly ascends from 61.56 in grade 6 to 65.9 in grade 8. Finally, it jumps 16.57 percent points landing at 82.46 outperforming both the state and columbia county.", style = "width:14in")
      }
    }
    else if(obj_var == 7){
      pre("            |<------PSSA----->|
                              |<---Keystone--->|
         2016, 2017, 2018, 2019, 2020, 2021, 2022
Cohort 1    8                11
Cohort 2    6     7     8                11
Cohort 3    5     6     7     8                11", style = "width:14in")
    }
  })
}

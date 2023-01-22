# @authors: Ronny Toribio, Anna Schlecht, Kadir Altunel
# @project: State Testing Analysis
# @file:    api.R
# @desc:    Objective plotting functions and utilities

library(tidyverse)

# Global constants
plot_width = 14
plot_height = 8
plot_units = "in"
change_trend_height = -2
geom_col_width1 = 0.4
geom_col_width2 = 1
position_dodge_width = 0.9
position_dodge_width2 = 1
county_color_tuple = c("Steelblue", "Magenta")
county_color_list = list(
  "State" = "Red",
  "Columbia" = "Steelblue",
  "Montour" = "Magenta"
)

# Main theme
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


# Change Trends utility functions
add_changes_trend = function(t){
  t$AvgScoreChangePos = t$AvgScoreChange
  t$AvgScoreChangePos[t$AvgScoreChangePos < 0] = NA
  t$AvgScoreChangeNeg = t$AvgScoreChange
  t$AvgScoreChangeNeg[t$AvgScoreChangeNeg > 0] = NA
  t
}

calc_changes_trend_by_county = function(t){
  column = (t %>% ungroup() %>% select(County) %>% distinct())$County
  result = tibble()
  for(i in column){
    selection = t %>% filter(County == i)
    selection$AvgScoreChange = round(selection$AvgScore - lag(selection$AvgScore), 2)
    result = bind_rows(result, selection)
  }
  add_changes_trend(result)
}

calc_changes_trend_by_subject = function(t){
  column = (t %>% ungroup() %>% select(Subject) %>% distinct())$Subject
  result = tibble()
  for(i in column){
    selection = t %>% filter(Subject == i)
    selection$AvgScoreChange = round(selection$AvgScore - lag(selection$AvgScore), 2)
    result = bind_rows(result, selection)
  }
  add_changes_trend(result)
}

calc_changes_trend_by_cohort = function(t){
  column = (t %>% ungroup() %>% select(Cohort) %>% distinct())$Cohort
  result = tibble()
  for(i in column){
    selection = t %>% filter(Cohort == i)
    selection$AvgScoreChange = round(selection$AvgScore - lag(selection$AvgScore), 2)
    result = bind_rows(result, selection)
  }
  add_changes_trend(result)
}

# plotting functions
plot_trends1 = function(ds, title, filename){
  t = ds %>%
    filter(County != "State" & Category == "Top") %>%
    select(Year, County, Category, Students, Scored) %>%
    group_by(Year, County) %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore=Students / Scored * 100, AvgScoreLabel=round(AvgScore, 2))
  t = calc_changes_trend_by_county(t)
  pt = t %>%
    ggplot(aes(x = Year, y = AvgScore, fill = County)) +
    scale_fill_manual(values=county_color_tuple) +
    geom_col(position = position_dodge2(0.9)) +
    geom_label(aes(x = Year, y = AvgScore-1.5, label = AvgScoreLabel), position = position_dodge2(position_dodge_width), color="white") +
    geom_label(aes(x = Year, y=change_trend_height , label = AvgScoreChangePos), position = position_dodge2(position_dodge_width), color="green", fill="darkblue") +
    geom_label(aes(x = Year, y=change_trend_height , label = AvgScoreChangeNeg), position = position_dodge2(position_dodge_width), color="red", fill="darkblue") +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  plot(pt)
  ggsave(filename, pt, width=plot_width, height=plot_height, units=plot_units)
}

plot_trends2 = function(ds, county, title, filename){
  t = ds %>%
    select(Year, County, Category, Scored, Students) %>%
    group_by(Year, County) %>%
    filter(Category == "Top") %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore = Students / Scored * 100, AvgScoreLabel = round(AvgScore, 2))
  t = calc_changes_trend_by_county(t)
  pt = t %>%
    filter(County == county) %>% 
    ggplot(aes(x = Year, y = AvgScore)) +
    geom_col(position="dodge", fill = county_color_list[county], width=geom_col_width1) +
    geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill=county_color_list[county], color="white") +
    geom_label(aes(x = Year, y=change_trend_height , label = AvgScoreChangePos), color="green", fill="darkblue") +
    geom_label(aes(x = Year, y=change_trend_height , label = AvgScoreChangeNeg), color="red", fill="darkblue") +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  plot(pt)
  ggsave(filename, pt, width=plot_width, height=plot_height, units=plot_units)
}

plot_trends3 = function(ds, parameters){
  t = ds %>%
    select(Year, County, Category, Scored, Students, Subject) %>%
    group_by(Year, County, Subject) %>%
    filter(Category == "Top") %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore = Students / Scored * 100, AvgScoreLabel = round(AvgScore, 2))
  for(i in 1:length(parameters)){
    param = parameters[[i]]
    s = t %>% filter(County == param$county)
    s = calc_changes_trend_by_subject(s)
    s = s %>% filter(Subject == param$subject)
    pt = s %>%
      ggplot(aes(x = Year, y = AvgScore)) +
      geom_col(position="dodge", fill = county_color_list[param$county], width=geom_col_width1) +
      geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill=county_color_list[param$county], color="white") +
      geom_label(aes(x = Year, y=change_trend_height, label = AvgScoreChangePos), color="green", fill="darkblue") +
      geom_label(aes(x = Year, y=change_trend_height, label = AvgScoreChangeNeg), color="red", fill="darkblue") +
      ggtitle(param$title) +
      xlab("Years") + 
      ylab("Cumulative Average Score (%)")
    plot(pt)
    ggsave(param$filename, pt, width = plot_width, height = plot_height, units=plot_units)
  }
}

plot_trends4 = function(ds, title, filename){
  t = ds %>%
    filter(Category == "Top") %>%
    group_by(Year, Subject) %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore = Students / Scored * 100, AvgScoreLabel = round(AvgScore, 2))
  t = calc_changes_trend_by_subject(t)
  pt = t %>%
    ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
    geom_col(position = position_dodge(position_dodge_width), width=geom_col_width2) +
    geom_label(aes(x = Year, y = AvgScore-1.5, label = AvgScoreLabel), position = position_dodge(position_dodge_width2), color="white") +
    geom_label(aes(x = Year, y=change_trend_height, label = AvgScoreChangePos), position = position_dodge2(position_dodge_width2), color="green", fill="darkblue") +
    geom_label(aes(x = Year, y=change_trend_height, label = AvgScoreChangeNeg), position = position_dodge2(position_dodge_width2), color="red", fill="darkblue") +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  plot(pt)
  ggsave(filename, pt, width = plot_width, units = plot_units)
}

plot_trends5 = function(ds, title, filename){
  pt = ds %>%
    filter(District != "State" & Category == "Top") %>%
    group_by(Year, District) %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore = Students / Scored *100, AvgScoreLabel = round(AvgScore, 0)) %>%
    ggplot(aes(x = Year, y = AvgScore, fill = District)) +
    geom_col(position = position_dodge(position_dodge_width)) +
    geom_text(aes(x = Year, y = AvgScore + .5, label = AvgScoreLabel), angle = 45, color = "white", position = position_dodge(position_dodge_width)) +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  plot(pt)
  ggsave(filename, pt, width = plot_width, units = plot_units)
}

plot_trends6 = function(ds, county, title, filename){
  t = ds %>%
    filter(Category == "Top" & County == county) %>%
    select(Cohort, Grade, Students, Scored) %>%
    group_by(Cohort, Grade) %>%
    summarise(across(c(Students, Scored), sum)) %>%
    mutate(AvgScore = Students / Scored * 100, AvgScoreLabel = round(AvgScore, 2))
  t = calc_changes_trend_by_cohort(t)
  pt = t %>%
    ggplot(aes(x = Grade, y = AvgScore, fill = Grade)) +
    geom_col(position="dodge") +
    geom_label(aes(x = Grade, y = AvgScore-1.5 , label = AvgScoreLabel), color = "white") +
    geom_label(aes(x = Grade, y = change_trend_height , label = AvgScoreChangePos), color = "green", fill = "darkblue") +
    geom_label(aes(x = Grade, y = change_trend_height , label = AvgScoreChangeNeg), color = "red", fill = "darkblue") +
    facet_wrap(~Cohort, labeller=labeller(Cohort = c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
    labs(title=title) +
    xlab("Grades") + 
    ylab("Cumulative Average Score (%)")
  plot(pt)
  ggsave(filename, pt, width=plot_width, height=plot_height, units=plot_units)
}

plot_cohorts_timeline = function(ds, filename){
  pt = ds %>% 
    ggplot() + 
    geom_rect(aes(xmin = Year, xmax = Year + 1, ymin = Cohort-0.5, ymax = Cohort, fill = Grade)) +
    geom_text(aes(x = Year, y = Cohort, label = "")) +
    theme(axis.text.y = element_text(vjust=2)) +
    labs(title = "Cohorts Timeline")
  plot(pt)
  ggsave(filename, pt)
}


# generative functions
gen_trends1 = function(ds, colors, title){
  t = ds %>%
    select(Year, County, Category, Students, Scored) %>%
    group_by(Year, County) %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore=Students / Scored * 100, AvgScoreLabel=round(AvgScore, 2))
  t = calc_changes_trend_by_county(t)
  pt = t %>%
    ggplot(aes(x = Year, y = AvgScore, fill = County)) +
    scale_fill_manual(values = colors) +
    geom_col(position = "dodge", width = geom_col_width1) +
    geom_label(aes(x = Year, y = AvgScore-1, label = AvgScoreLabel), position = position_dodge2(geom_col_width1), color="white") +
    geom_label(aes(x = Year, y=change_trend_height , label = AvgScoreChangePos), position = position_dodge2(geom_col_width1), color="green", fill="darkblue") +
    geom_label(aes(x = Year, y=change_trend_height , label = AvgScoreChangeNeg), position = position_dodge2(geom_col_width1), color="red", fill="darkblue") +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  pt
}

gen_trends2 = function(ds, colors, title){
  t = ds %>%
    select(Year, County, Category, Scored, Students) %>%
    group_by(Year, County) %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore = Students / Scored * 100, AvgScoreLabel = round(AvgScore, 2))
  t = calc_changes_trend_by_county(t)
  pt = t %>%
    ggplot(aes(x = Year, y = AvgScore)) +
    geom_col(position="dodge", width = geom_col_width1, fill=colors) +
    geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), color="white", fill=colors) +
    geom_label(aes(x = Year, y = change_trend_height , label = AvgScoreChangePos), color="green", fill="darkblue") +
    geom_label(aes(x = Year, y = change_trend_height , label = AvgScoreChangeNeg), color="red", fill="darkblue") +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  pt
}

gen_trends3 = function(ds, colors, title){
  t = ds %>%
    select(Year, County, Category, Scored, Students, Subject) %>%
    group_by(Year, County, Subject) %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore = Students / Scored * 100, AvgScoreLabel = round(AvgScore, 2))
  t = calc_changes_trend_by_subject(t)
  pt = t %>%
    ggplot(aes(x = Year, y = AvgScore)) +
    geom_col(position="dodge", fill = colors[1], width=geom_col_width1) +
    geom_label(aes(x = Year, y = AvgScore-1.5 , label = AvgScoreLabel), fill=colors[1], color="white") +
    geom_label(aes(x = Year, y=change_trend_height, label = AvgScoreChangePos), color="green", fill="darkblue") +
    geom_label(aes(x = Year, y=change_trend_height, label = AvgScoreChangeNeg), color="red", fill="darkblue") +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  pt
  
}

gen_trends4 = function(ds, title){
  t = ds %>%
    group_by(Year, Subject) %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore = Students / Scored * 100, AvgScoreLabel = round(AvgScore, 2))
  t = calc_changes_trend_by_subject(t)
  pt = t %>%
    ggplot(aes(x = Year, y = AvgScore, fill = Subject)) +
    geom_col(position = position_dodge(position_dodge_width), width = geom_col_width2) +
    geom_label(aes(x = Year, y = AvgScore-1.5, label = AvgScoreLabel), position = position_dodge(position_dodge_width2), color="white") +
    geom_label(aes(x = Year, y=change_trend_height, label = AvgScoreChangePos), position = position_dodge2(position_dodge_width2), color="green", fill="darkblue") +
    geom_label(aes(x = Year, y=change_trend_height, label = AvgScoreChangeNeg), position = position_dodge2(position_dodge_width2), color="red", fill="darkblue") +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  pt
}

gen_trends5 = function(ds, title){
  pt = ds %>%
    group_by(Year, District) %>%
    summarise(across(c(Scored, Students), sum)) %>%
    mutate(AvgScore = Students / Scored *100, AvgScoreLabel = round(AvgScore, 0)) %>%
    ggplot(aes(x = Year, y = AvgScore, fill = District)) +
    geom_col(position = position_dodge(position_dodge_width)) +
    geom_text(aes(x = Year, y = AvgScore + .5, label = AvgScoreLabel), angle = 45, color = "white", position = position_dodge(position_dodge_width)) +
    labs(title = title) +
    xlab("Years") + 
    ylab("Cumulative Average Score (%)")
  pt
}

gen_trends6 = function(ds, title){
  t = ds %>%
    select(Cohort, Grade, Students, Scored) %>%
    group_by(Cohort, Grade) %>%
    summarise(across(c(Students, Scored), sum)) %>%
    mutate(AvgScore = Students / Scored * 100, AvgScoreLabel = round(AvgScore, 2))
  t = calc_changes_trend_by_cohort(t)
  pt = t %>%
    ggplot(aes(x = Grade, y = AvgScore, fill = Grade)) +
    geom_col(position="dodge", width = geom_col_width1) +
    geom_label(aes(x = Grade, y = AvgScore-1.5 , label = AvgScoreLabel), color = "white") +
    geom_label(aes(x = Grade, y = change_trend_height , label = AvgScoreChangePos), color = "green", fill = "darkblue") +
    geom_label(aes(x = Grade, y = change_trend_height , label = AvgScoreChangeNeg), color = "red", fill = "darkblue") +
    facet_wrap(~Cohort, labeller=labeller(Cohort = c("1" = "Cohort 1", "2" = "Cohort 2", "3" = "Cohort 3"))) +
    labs(title=title) +
    xlab("Grades") + 
    ylab("Cumulative Average Score (%)")
  pt
}

gen_cohorts_timeline = function(ds){
  pt = ds %>% 
    ggplot() + 
    geom_rect(aes(xmin = Year, xmax = Year + 1, ymin = Cohort - 0.5, ymax = Cohort, fill = Grade)) +
    geom_text(aes(x = Year, y = Cohort, label = "")) +
    theme(axis.text.y = element_text(vjust = 2)) +
    labs(title = "Cohorts Timeline")
  pt
}


# PSSA and Keystone datasets
ps = read_csv("PSSA/pssa.csv")
ks = read_csv("Keystone/keystone.csv")
ps$County = as_factor(ps$County)
ks$County = as_factor(ks$County)
ps$Category = as_factor(ps$Category)
ks$Category = as_factor(ks$Category)

# Cohorts dataset
cohorts = read_csv("Cohorts/cohorts.csv")
cohorts$County = as_factor(cohorts$County)
cohorts$Category = as_factor(cohorts$Category)
cohorts$Grade = as_factor(cohorts$Grade)
cohorts$Cohort = as.integer(cohorts$Cohort)
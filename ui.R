# @author:  Ronny Toribio
# @project: State Testing Analysis
# @file:    ui.R
# @desc:    User interface for dashboard

ui = fixedPage(
  titlePanel("State Testing Analysis Dashboard"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "years", 
        label = "Years", 
        min = 2016, 
        max = 2022, 
        step = 1, 
        sep = "", 
        value = c(2016, 2022),
        width = "2in"
      ),
      radioButtons(
        inputId = "objectives",
        label = "Project Objectives",
        choices = list(
         "Objective 1 Local counties" = 1,
         "Objective 2 All counties" = 2,
         "Objective 3 Counties by subjects" = 3,
         "Objective 4 All by subjects" = 4,
         "Objective 5 All by districts" = 5,
         "Objective 6 Cohorts by counties" = 6,
         "Cohorts Timeline" = 7
        ),
        selected = 1
      ),
      conditionalPanel(
        condition = "input.objectives < 6",
        radioButtons(
          inputId = "datasets", 
          label = "Dataset",
          choices = list("PSSA" = 1, "Keystone" = 2)
        ),
        selected = 1
      ),
      conditionalPanel(
        condition = "input.objectives > 5",
        radioButtons(
          inputId = "datasets_obj6", 
          label = "Dataset",
          choices = list("Cohorts")
        )
      ),
      conditionalPanel(
        condition = "input.objectives == 1 || input.objectives == 5",
        checkboxGroupInput(
          inputId = "counties_local",
          label = "Counties",
          choices = list("Columbia", "Montour"),
          selected = c("Columbia", "Montour")
        )
      ),
      conditionalPanel(
        condition = "input.objectives == 4",
        checkboxGroupInput(
          inputId = "counties",
          label="Counties",
          choices = list("State", "Columbia", "Montour"),
          selected = c("State", "Columbia", "Montour")
        )
      ),
      conditionalPanel(
        condition = "input.objectives == 2 || input.objectives == 3 || input.objectives == 6",
        radioButtons(
          inputId = "counties_radio",
          label = "Counties",
          choices = list("State", "Columbia", "Montour"),
          selected = "State"
        )
      ),
      conditionalPanel(
        condition = "input.objectives != 3",
        checkboxGroupInput(
          inputId = "subjects",
          label = "Subjects",
          choices = list("English", "Math", "Science"),
          selected = c("English", "Math", "Science")
        )
      ),
      conditionalPanel(
        condition = "input.objectives == 3",
        radioButtons(
          inputId = "subjects_radio",
          label = "Subjects",
          choices = list("English", "Math", "Science"),
          selected = "English"
        )
      ),
      checkboxGroupInput(
        inputId = "categories",
        label="Categories",
        choices = list(
          "Top" = "Top",
          "Advanced" = "Advanced",
          "Proficient" = "Proficient",
          "Basic" = "Basic",
          "Below Basic" = "BelowBasic"
        ),
        selected = "Top"
      ),
      conditionalPanel(
        condition = "input.objectives > 5",
        checkboxGroupInput(
          inputId = "grades",
          label="Grades",
          choices = list(
            "Grade 5" = 5,
            "Grade 6" = 6,
            "Grade 7" = 7,
            "Grade 8" = 8,
            "Grade 11" = 11
          ),
          selected = c(5, 6, 7, 8, 11)
        )
      )
    ),
    mainPanel(
      h1("Graph"),
      plotOutput(outputId = "graph", width = "14in", height = "7in"),
      h1("Interpretation"),
      htmlOutput(outputId = "interpretation")
    )
  )
)

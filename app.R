# @author:  Ronny Toribio
# @project: State Testing Analysis
# @file:    app.R
# @desc:    A shiny dashboard for visualizing the testing data


library(shiny)
source("ui.R")
source("server.R")
shinyApp(ui = ui, server = server)

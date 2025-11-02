library(ggplot2)
library(plotly)
library(rAmCharts)
library(shiny)
library(shinydashboard)
source("pre_analyses.R")

dashboardPage(
  dashboardHeader(title = "L'audiovisuel en France"),
  dashboardSidebar(
    conditionalPanel(condition="input.tabselected==2",
                     selectInput(inputId = "media_id",
                                 label = "choisissez le média",
                                 choices = choix_media),
    )
  ),
  dashboardBody(
    tabsetPanel(
      tabPanel("Les thématiques"),
      tabPanel("Le temps de parole des femmes", value = 2,
               uiOutput("plot_rep", click = "plot_click"),
               uiOutput("chaine_id"),
               uiOutput("plot_rep_chaine")
              ),
      id = "tabselected"
    )
  )
)

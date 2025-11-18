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
                                 label = "Choisissez le média",
                                 choices = choix_media),
    ),
    conditionalPanel(condition="input.tabselected==1",
                     selectInput("chaine_theme_id", "Choisissez la chaîne", choices = liste_chaines),
                     selectInput("theme_id", "Choisissez le thème", choices = liste_themes)
    )
  ),
  dashboardBody(
    tabsetPanel(
      tabPanel("Les thématiques à la télévision", value = 1, plotlyOutput("plot_theme")),
      tabPanel("Le temps de parole des femmes", value = 2,
               uiOutput("plot_rep", click = "plot_click"),
               uiOutput("chaine_id"),
               uiOutput("plot_rep_chaine")
              ),
      id = "tabselected"
    )
  )
)

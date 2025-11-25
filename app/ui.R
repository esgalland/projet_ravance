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
                                 choices = choix_media)
    ),
  conditionalPanel(
    condition = "input.tabselected==3",
    selectInput("age_info_id",
                "Choisissez une tranche d'âge :",
                choices = choix_age_info,
                selected = choix_age_info[1]),
    selectInput("genre_info_id",
                "Choisissez un genre :",
                choices = choix_genre_info,
                selected = choix_genre_info[1])
  )
  ),
  
  dashboardBody(
    tabsetPanel(
      tabPanel("Les thématiques des JT", value = 1,
               fluidRow(
                 column(6,
                        selectInput("chaine_theme_id", "Choisissez la chaîne", choices = liste_chaines)
                 ),
                 column(6,
                        selectInput("theme_id", "Choisissez le thème", choices = liste_themes)
                 )
               ),
               
               br(),
               
               # Graphique principal
               plotlyOutput("plot_theme"),
               br(), hr(),
               
               h3("Proximité entre chaînes selon les thèmes"),
               plotlyOutput("plot_proximite_rf"),
               br(), hr(),
               
               h3("Importance des thèmes pour différencier les chaînes"),
               plotlyOutput("plot_importance_themes")
      )
      ,
      tabPanel("Le temps de parole des femmes", value = 2,
               uiOutput("plot_rep", click = "plot_click"),
               uiOutput("chaine_id"),
               uiOutput("plot_rep_chaine")
              ),
      tabPanel(" Rapport à l'information", value = 3,
               
               h3("Évolution du rapport des Français à l'information"),
               plotlyOutput("plot_media_info"),
               plotlyOutput("plot_confiance_info")
      ),
      id = "tabselected"
    )
  )
)

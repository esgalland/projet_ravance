library(ggplot2)
library(plotly)
library(rAmCharts)
library(shiny)
library(shinydashboard)
source("pre_analyses.R")

dashboardPage(
  dashboardHeader(title = "L'audiovisuel en France", titleWidth = 290),
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
    # Code CSS pour faire que le side bar bouge quand on scrolle dans les deux sens sur la page
    tags$head(
      tags$style(HTML("
        .main-sidebar {
          position: fixed;
          top: 0;
          height: 100%;
          overflow-y: auto;
        }

        .content-wrapper, .right-side {
          margin-left: 230px !important;
        }
      "))
    ),
    tabsetPanel(
      tabPanel("Les thématiques des JT", value = 1,
               uiOutput("comment_theme_intro"),
               fluidRow(
                 column(6,
                        selectInput("chaine_theme_id", "Choisissez la chaîne", choices = liste_chaines)
                 ),
                 column(6,
                        selectInput("theme_id", "Choisissez le thème", choices = liste_themes)
                 )
               ),
               
               br(),
               
               # graphique principal
               plotlyOutput("plot_theme"),
               br(), hr(),
               
               h3("Proximité entre chaînes selon les thèmes"),
               plotlyOutput("plot_proximite_rf"),
               uiOutput("comment_proximite"),
               br(), hr(),
               
               h3("Importance des thèmes pour différencier les chaînes"),
               uiOutput("comment_importance"),
               plotlyOutput("plot_importance_themes"),
              
               
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
               htmlOutput("insight_media"),
               br(), hr(), br(),
               
               plotlyOutput("plot_confiance_info"),
               htmlOutput("insight_confiance"),
               br(), hr(),
               
               h3("Lien entre média principal et confiance dans l'information"),
               plotlyOutput("heatmap_media_confiance"),
               htmlOutput("insight_heatmap"),
               br(), hr(),
               h3("Confiance moyenne selon l'âge"),
               plotlyOutput("plot_confiance_age"),
               br(), hr()
               
      ),
      id = "tabselected"
    )
  )
)

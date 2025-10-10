library(ggplot2)
library(rAmCharts)
library(shiny)
library(shinydashboard)
library(dplyr)


###Données

choix_chaine <- unique(data_rep_tv$chaine)[-(1:3)]
choix_media <- c("télévision","radio")
choix_frequence <- unique(data_rep_radio$chaine)[-(1:3)]

####UI
ui <- dashboardPage(
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
        ),id = "tabselected"
    )
  )
)

###Server
server <- function(input, output) {
  
  output$plot_rep <- renderUI(
    if(input$media_id == "télévision"){
      renderPlotly(ggplotly(ggplot(data_mediane, aes(x = Year, ymin = 0, y = representation, group = chaine, colour = chaine))+
          geom_line()+
          geom_point()+
          theme_minimal()+
          ggtitle("Médianes du taux de représentation des femmes à la télé en fonction du temps"))
        )
    }else{
      renderPlotly(ggplotly(ggplot(data_mediane_radio, aes(x = Year, ymin = 0, y = representation, group = chaine, colour = chaine))+
                   geom_line()+
                   geom_point()+
                   theme_minimal()+
                   ggtitle("Médianes du taux de représentation des femmes à la radio en fonction du temps")))
    }
  )
  
  output$chaine_id <- renderUI(
      if(input$media_id == "télévision"){
        selectInput(inputId = "chaine_tv_id",
                    label = "choisissez la chaine de télé",
                    choices = choix_chaine)
      }else{
        selectInput(inputId = "chaine_radio_id",
                    label = "choisissez la fréquence",
                    choices = choix_frequence)
      }
  )
  
  output$plot_rep_chaine<- renderUI({
    if(input$media_id == "télévision"){
        renderPlotly(ggplotly(ggplot(data <- data_rep_tv %>% filter(chaine == as.character(input$chaine_tv_id)), aes(x = Year, ymin = 0, y = representation))+
          geom_line()+
          geom_point()+
          theme_minimal()+
          ggtitle(paste0("Médianes du taux de représentation des femmes sur la chaine ",as.character(input$chaine_tv_id), " en fonction de l'année"))
        ))  
    }else{
      renderPlotly(ggplotly(ggplot(data <- data_rep_radio %>% filter(chaine == as.character(input$chaine_radio_id)), aes(x = Year, ymin = 0, y = representation))+
                   geom_line()+
                   geom_point()+
                   theme_minimal()+
                   ggtitle(paste0("Médianes du taux de représentation des femmes sur la chaine ",as.character(input$chaine_radio_id), " en fonction de l'année"))))
      
    }
  })
}

###RUN
shinyApp(ui = ui, server = server)
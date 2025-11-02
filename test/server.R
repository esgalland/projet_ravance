library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

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
  
  output$plot_rep_chaine <- renderUI({
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

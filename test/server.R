library(shiny)

server <- function(input, output, session) {

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
  filtered_themes <- reactive({
    df <- themes_par_annees
    df <- df[df$chaine == input$chaine_theme_id,]
    df <- df[df$theme == input$theme_id,]
    df
  })
  
  output$plot_theme <- renderPlotly({
    df <- filtered_themes()
    plot_ly(df, x = ~year, y = ~nb_sujets, color = ~theme, type = 'scatter', mode = 'lines+markers') %>%
      layout(title = paste0("Représentation du thème \"", as.character(input$theme_id), "\" sur la chaine ", as.character(input$chaine_theme_id)),
             xaxis = list(title = "Année"),
             yaxis = list(title = "Nombre de sujets"))
  })
  # ---------------------------------------------------
  # AXE 3 : Rapport à l'information
  # ---------------------------------------------------
  
  filtered_axe3 <- reactive({
    req(input$age_info_id)
    req(input$genre_info_id)
    
    donnees_axe3 %>%
      filter(
        age == input$age_info_id,
        genre == input$genre_info_id
      )
  })
  
  # Graphique : Médias utilisés
  output$plot_media_info <- renderPlotly({
    df <- filtered_axe3()
    
    gg <- ggplot(df, aes(x = media_principal)) +
      geom_bar(fill = "#3182bd") +
      labs(
        title = "Quels médias sont utilisés pour s'informer ?",
        x = "Média principal",
        y = "Nombre de répondants"
      ) +
      theme_minimal()
    
    ggplotly(gg)
  })
  
  # Graphique : Niveau de confiance
  output$plot_confiance_info <- renderPlotly({
    df <- filtered_axe3()
    
    gg <- ggplot(df, aes(x = confiance_info)) +
      geom_bar(fill = "#e6550d") +
      labs(
        title = "Confiance dans l'information",
        x = "Niveau de confiance",
        y = "Nombre de répondants"
      ) +
      theme_minimal()
    
    ggplotly(gg)
  })
  
  output$plot_proximite_rf <- renderPlotly({
    gg <- ggplot(mds_df, aes(x = Dim1, y = Dim2, label = chaine)) +
      geom_point(size = 4, color = "#2c7fb8") +
      geom_text(vjust = -1) +
      theme_minimal() +
      labs(
        title = "Proximité entre chaînes selon les thèmes (Random Forest)",
        x = "Dimension 1",
        y = "Dimension 2"
      )
    
    ggplotly(gg)
  })
  
  output$plot_importance_themes <- renderPlotly({
    gg <- ggplot(importance_df, aes(x = reorder(theme, importance), y = importance)) +
      geom_col(fill = "#e6550d") +
      coord_flip() +
      theme_minimal() +
      labs(
        title = "Importance des thèmes pour différencier les chaînes",
        x = "Thème",
        y = "Importance (Random Forest)"
      )
    
    ggplotly(gg)
  })
}


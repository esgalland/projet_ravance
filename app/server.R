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
                              ggtitle("Taux de représentation moyen des femmes à la radio en fonction du temps")))
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
                              ggtitle(paste0("Taux de représentation moyen des femmes sur la chaine ",as.character(input$chaine_radio_id), " en fonction de l'année"))))
      

    }
    })

  filtered_themes <- reactive({ # filtre interactifchoiw
    df <- themes_par_annees
    df <- df[df$chaine == input$chaine_theme_id,]
    df <- df[df$theme == input$theme_id,]
    df
  })
  # graphique principal thèmes
  output$plot_theme <- renderPlotly({
    df <- filtered_themes()
    plot_ly(df, x = ~year, y = ~nb_sujets, color = ~theme, type = 'scatter', mode = 'lines+markers') %>%
      layout(title = paste0("Représentation du thème \"", as.character(input$theme_id), "\" sur la chaine ", as.character(input$chaine_theme_id)),
             xaxis = list(title = "Année"),
             yaxis = list(title = "Nombre de sujets"))
  })
  output$comment_theme_intro <- renderUI({
    HTML("
      <p style='font-size:16px;'>
      Sur le graphique ci-dessous, on remarque plusieurs choses marquantes :<br>
      • explosion des sujets santé en 2020 sur toutes les chaînes, ce qui correspond clairement au covid,<br>
      • une hausse progressive des sujets économiques au fil des années,<br>
      • un déclin des sujets liés au sport,<br>
      • et une augmentation des sujets “histoire / hommages” depuis 2000.<br>
      Ces tendances sont visibles quand on change de chaîne ou de thème.
      </p>
    ")
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
        genre == input$genre_info_id,
        !is.na(media_principal),
        !is.na(confiance_info)
      )
  })
  
  # Graphique : Médias utilisés
  output$plot_media_info <- renderPlotly({
    df <- filtered_axe3()
    
    gg <- ggplot(df, aes(x = media_principal)) +
      geom_bar(fill = "#3182bd") +
      scale_x_discrete(drop =FALSE) +
      labs(
        title = "Quels médias sont utilisés pour s'informer ?",
        x = "Média principal",
        y = "Nombre de répondants"
      ) +
      theme_minimal()
    
    ggplotly(gg)
  })
  output$insight_media <- renderText({   
    "La radio est le média principal le plus utilisé, tandis que les réseaux sociaux sont quasi absents."
  })
  
  # Graphique : Niveau de confiance
  output$plot_confiance_info <- renderPlotly({
    df <- filtered_axe3()
    
    gg <- ggplot(df, aes(x = confiance_info)) +
      geom_bar(fill = "#e6550d") +
      scale_x_discrete(drop =FALSE) +
      labs(
        title = "Confiance dans l'information",
        x = "Niveau de confiance",
        y = "Nombre de répondants"
      ) +
      theme_minimal()
    
    ggplotly(gg)
  })
  
  output$insight_confiance <- renderText({   
    "La confiance dans l'information est majoritairement modérée ('Plutôt d'accord')."
  })
  
  # ---------------------------------------------------
  # AXE 3 : Heatmap Média × Confiance
  # ---------------------------------------------------
  output$heatmap_media_confiance <- renderPlotly({
    
    df <- filtered_axe3() %>% 
      filter(!is.na(media_principal),
             !is.na(confiance_info))
    
    tab <- table(df$media_principal, df$confiance_info)
    df_long <- as.data.frame(tab)
    colnames(df_long) <- c("media_principal", "confiance_info", "n")
    
    p <- ggplot(df_long, aes(x = media_principal, y = confiance_info, fill = n)) +
      geom_tile() +
      scale_fill_gradient(low = "#deebf7", high = "#3182bd") +
      labs(
        title = "Relation entre média utilisé et confiance dans l'information",
        x = "Média principal",
        y = "Niveau de confiance",
        fill = "Nombre"
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p)
  })
  output$insight_heatmap <- renderText({   
    "La radio est associée à une confiance plus élevée, contrairement aux plateformes vidéo et podcasts."
  })

# Axe 3-  Confiance moyenne dans l'information selon l'âge
  
  output$plot_confiance_age <- renderPlotly({
    
    df <- donnees_axe3 %>%
      filter(!is.na(confiance_score), !is.na(age)) %>%
      group_by(age) %>%
      summarise(confiance_moy = mean(confiance_score), .groups = "drop")
    
    gg <- ggplot(df, aes(x = age, y = confiance_moy)) +
      geom_col(fill = "#3182bd") +
      theme_minimal() +
      labs(
        title = "Confiance moyenne selon l'âge",
        x = "Tranche d'âge",
        y = "Score moyen (1 = forte confiance ; 4 = faible confiance)"
      )
    
    ggplotly(gg)
  })
  
  
## Random forest 
  
  output$plot_proximite_rf <- renderPlotly({
    gg <- ggplot(mds_df, aes(x = Dim1, y = Dim2, label = chaine)) +
      geom_point(size = 4, color = "#66b2ff") +
      geom_text(vjust = -1) +
      theme_minimal() +
      labs(
        title = "Proximité entre chaînes selon les thèmes (Random Forest)",
        x = "Dimension 1",
        y = "Dimension 2"
      )
    
    ggplotly(gg)
  })
  output$comment_proximite <- renderUI({
    HTML("
      <p style='font-size:16px;'>
      Ce graphique montre quelles chaînes se ressemblent le plus dans leur manière de traiter les thèmes des JT.<br>
      Le calcul vient d’une méthode MDS appliquée à une matrice de distances entre chaînes.<br>
      Deux chaînes proches sur le graphique ont des répartitions de thèmes très similaires.
      </p>
    ")
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
  output$comment_importance <- renderUI({
    HTML("
      <p style='font-size:16px;'>
      L’importance ici correspond simplement au volume total de sujets par thème sur l’ensemble des chaînes.<br>
      </p>
    ")
  })
}


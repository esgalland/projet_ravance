# Projet R Shiny – Audiovisuel en France

[![R](https://img.shields.io/badge/R-4.5.1-blue.svg)](https://www.r-project.org/) 
[![Shiny](https://img.shields.io/badge/Shiny-app-success.svg)](https://shiny.rstudio.com/)

Projet R Shiny pour l'UE R Avancé, répondant au défi ["Les Françaises et Français face à l'information"](https://defis.data.gouv.fr/defis/les-francaises-et-francais-face-a-linformation).

---

## Aperçu de l’application

### 1. Thématiques à la télévision
- Visualisation des sujets par thème et par chaîne au fil des années.
- Analyse de la proximité entre chaînes via Random Forest.
- Graphique interactif de l’importance des thèmes.

### 2. Représentation des femmes
- Taux de représentation à la télévision et à la radio.
- Graphiques interactifs selon média et chaîne/fréquence.

### 3. Rapport des Français à l’information
- Médias utilisés et confiance dans l’information selon tranche d’âge et genre.
- Filtres dynamiques pour explorer les données.

## Structure du projet
- `ui.R` : interface utilisateur
- `server.R` : logique serveur et graphiques
- `pre_analyses.R` : nettoyage et pré-traitement des données
- `data/` : fichiers CSV et Excel sources

## Lancer l’application

1. Cloner le projet ou télécharger les fichiers.
2. Installer les packages nécessaires, par exemple :
```r
install.packages(c("shiny","shinydashboard","ggplot2","plotly","tidyverse","randomForest","readxl","rAmCharts","lubridate"))
```
3. lancer l'app
```r
shiny::runApp("chemin/vers/le/projet")
```

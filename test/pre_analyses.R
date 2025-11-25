# Packages et chargement des données

require(ggplot2)
require(scales)
require(stringr)
require(tidyverse)
require(dplyr)
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(plotly)


data_rep <- read.csv2("../data/hourstatall.csv", sep=",")
data_rep_tv <- read.csv2("../data/tv-years.csv", sep = ",")
data_rep_radio <- read.csv2("../data/radio-years.csv", sep = ",")
data_themes_tv <- read.csv2("../data/ina-barometre-jt-tv-donnees-quotidiennes-2000-2020-nbre-sujets-durees-202410.csv", 
                            sep=";", header=FALSE, col.names = c("date", "chaine", "vide", "theme", "nb_sujets", "duree"))

choix_chaine <- unique(data_rep_tv$chaine)[-(1:3)]
choix_media <- c("télévision","radio")
choix_frequence <- unique(data_rep_radio$chaine)[-(1:3)]

# Visualisation représentation des femmes à la télé

colnames(data_rep_tv) <- colnames(data_rep_tv) %>% 
  str_to_title()%>%
  str_replace_all(pattern = "[éëè]", replacement = "e") %>%
  str_replace_all(pattern = "\\.", replacement = "_") 

data_rep_tv <- pivot_longer(data_rep_tv, cols = - Year, values_to = "representation", names_to = "chaine")
data_rep_tv$representation <- data_rep_tv$representation %>% 
  str_replace_all(pattern = " ", replacement = "NA") 

data_rep_tv$representation <- as.numeric(data_rep_tv$representation)

data_mediane <- data_rep_tv %>%
  filter(chaine == "Mediane" | chaine == "Mediane_prive" | chaine == "Mediane_public")

data_mediane$representation <- as.numeric(data_mediane$representation)

# données radio

colnames(data_rep_radio) <- colnames(data_rep_radio) %>% 
  str_to_title()%>%
  str_replace_all(pattern = "[éëè]", replacement = "e") %>%
  str_replace_all(pattern = "\\.", replacement = "_") 

data_rep_radio <- pivot_longer(data_rep_radio, cols = - Year, values_to = "representation", names_to = "chaine")
data_rep_radio$representation <- data_rep_radio$representation %>% 
  str_replace_all(pattern = " ", replacement = "NA") 

data_rep_radio$representation <- as.numeric(data_rep_radio$representation)

data_mediane_radio <- data_rep_radio %>%
  filter(chaine == "Mediane" | chaine == "Mediane_prive" | chaine == "Mediane_public")

choix_chaine <- unique(data_rep_tv$chaine)[-(1:3)] %>%
  str_to_title()%>%
  str_replace_all(pattern = "[éëè]", replacement = "e") %>%
  str_replace_all(pattern = "\\.", replacement = "_") 

choix_media <- c("télévision","radio")
choix_frequence <- unique(data_rep_radio$chaine)[-(1:3)]

## Evolution des thèmes représentés à la télévision

data_themes_tv <- data_themes_tv %>%
  mutate(
    date = dmy(date),
    year = year(date),
    chaine = str_trim(chaine),
    theme = str_to_title(theme) %>% str_replace_all("�","e"),
    nb_sujets = as.numeric(nb_sujets),
    duree = as.numeric(duree)
  ) %>%
  select(-vide)

themes_par_annees <- data_themes_tv %>%
  group_by(year, chaine, theme) %>%
  summarise(nb_sujets = sum(nb_sujets, na.rm = TRUE), .groups="drop")

liste_chaines <- sort(unique(data_themes_tv$chaine))
liste_themes <- sort(unique(data_themes_tv$theme))

#### ---------------------------------------------------------
#### AJOUT AXE 3 — Rapport des Français à l'information 
#### ---------------------------------------------------------



base_raw <- read_excel("../data/base_arcom.xlsx")

donnees_axe3 <- base_raw %>%
  select(
    genre = RS1_R,
    age = RS2C_RECODE_AG_R,
    media_principal = NEWS1BIS_R,
    confiance_info = CONF1_R
  )

donnees_axe3$genre <- factor(
  donnees_axe3$genre,
  levels = c(1, 2),
  labels = c("Homme", "Femme")
)

donnees_axe3$age <- factor(
  donnees_axe3$age,
  levels = c(1,2,3,4,5,6,7),
  labels = c("15-17", "18-24", "25-34",
             "35-44", "45-59", "60-69", "70+")
)

donnees_axe3$media_principal <- factor(
  donnees_axe3$media_principal,
  levels = c(1,2,3,4,5,6,7),
  labels = c("Télévision", "Radio", "Presse écrite",
             "Réseaux sociaux", "Moteurs de recherche",
             "Plateformes vidéo", "Podcasts")
)

donnees_axe3$confiance_info <- factor(
  donnees_axe3$confiance_info,
  levels = c(1,2,3,4),
  labels = c("Tout à fait d'accord",
             "Plutôt d'accord",
             "Plutôt pas d'accord",
             "Pas du tout d'accord")
)

#### Choix pour les menus Shiny 

choix_age_info <- levels(donnees_axe3$age)
choix_genre_info <- levels(donnees_axe3$genre)
choix_media_info <- levels(donnees_axe3$media_principal)
choix_confiance_info <- levels(donnees_axe3$confiance_info)


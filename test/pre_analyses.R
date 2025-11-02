# Packages et chargement des données

require(ggplot2)
require(scales)
require(stringr)
require(tidyverse)
require(dplyr)

data_rep <- read.csv2("../data/hourstatall.csv", sep=",")
data_rep_tv <- read.csv2("../data/tv-years.csv", sep = ",")
data_rep_radio <- read.csv2("../data/radio-years.csv", sep = ",")

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
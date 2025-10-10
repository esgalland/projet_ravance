# Packages et chargement des données

require(ggplot2)
require(scales)
require(stringr)
require(tidyverse)
require(dplyr)

data_rep <- read.csv2("data/hourstatall.csv", sep=",")
data_rep_tv <- read.csv2("data/tv-years.csv", sep = ",")
data_rep_radio <- read.csv2("data/radio-years.csv", sep = ",")

# Visualisation représentation des femmes à la télé


colnames(data_rep_tv) <- colnames(data_rep_tv) %>% 
  str_to_title()%>%
  str_replace_all(pattern = "[éëè]", replacement = "e") %>%
  str_replace_all(pattern = "\\.", replacement = "_") 

data_rep_tv <- pivot_longer(data_rep_tv, cols = - Year, values_to = "representation", names_to = "chaine")
data_rep_tv$representation <- data_rep_tv$representation %>% 
  str_replace_all(pattern = " ", replacement = "NA") 

data_rep_tv$representation <- as.numeric(data_rep_tv$representation)

ggplot(data_rep_tv, aes(x = Year, y = representation, group = chaine, colour = chaine))+
  geom_line()+
  geom_point()

data_mediane <- data_rep_tv %>%
  filter(chaine == "Mediane" | chaine == "Mediane_prive" | chaine == "Mediane_public")

data_mediane$representation <- as.numeric(data_mediane$representation)

ggplot(data_mediane, aes(x = Year, ymin = 0, y = representation, group = chaine, colour = chaine))+
  geom_line()+
  geom_point()+
  theme_minimal()+
  ggtitle("Médianes du taux de représentation des femmes à la télé en fonction du temps")

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

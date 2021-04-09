# install.packages('XML')
# install.packages('stringr')
# install.packages('httr')

library(XML)
library(stringr)
library(httr)

###
# Test
###

# On choisit l'URL à extraire
url <- "https://www.parti-socialiste.fr/les_socialistes_proposent"

# On extrait la page
page <- GET(url)

# On converti la page en html (structure)
page_html <- htmlParse(page,encoding = "UTF-8")

# On navigue dans la page structurée
liste_actu <- getNodeSet(page_html,"//div[contains(@class,'card')]")

# Extraire la node de l'article
actu <- liste_actu[[1]]

# Extraire les données : le titre
titre <- xmlValue(getNodeSet(actu,".//h4")[[1]])
titre

# Extraire les données : l'url
url_texte <- xmlAttrs(getNodeSet(actu,".//h4/a")[[1]])[['href']]
url_texte <- paste("https://www.parti-socialiste.fr",url_texte,sep="")
url_texte

# Page Article
page_texte <- htmlParse(GET(url_texte),encoding = "UTF-8")

# Extraire les données : le résumé
resume <- xmlValue(getNodeSet(page_texte,"//div[@class='content']")[[1]])
resume

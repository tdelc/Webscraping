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
url <- "https://nouveaupartianticapitaliste.org/communiques"

# On extrait la page
page <- GET(url)

# On converti la page en html (structure)
page_html <- htmlParse(page,encoding = "UTF-8")

# On navigue dans la page structurée
liste_actu <- getNodeSet(page_html,"//div[@class='views-row']")

# Extraire la node de l'article
actu <- liste_actu[[1]]

# Extraire les données : le titre
titre <- xmlValue(getNodeSet(actu,".//span[@class='field-content']")[[1]])
titre

# Extraire les données : l'url
url_texte <- xmlAttrs(getNodeSet(actu,".//span[@class='field-content']/a")[[1]])[['href']]
url_texte
url_texte <- paste("https://nouveaupartianticapitaliste.org",url_texte,sep="")
url_texte

# Extraire les données : le résumé
resume <- xmlValue(getNodeSet(actu,".//div[@class='views-field views-field-body']")[[1]])
resume

# Extraire les données : la catégorie
categorie <- getNodeSet(actu,".//div[contains(@class,'vocabulary')]")

xmlValue(categorie[[1]])
xmlValue(categorie[[2]])
xmlValue(categorie)

categorie <- paste(xmlValue(categorie),collapse = " ; ")
categorie

date <- xmlValue(getNodeSet(actu,"./preceding-sibling::h3[1]"))
date

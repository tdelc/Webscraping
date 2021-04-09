install.packages('XML')
install.packages('stringr')
install.packages('httr')

library(XML)
library(stringr)
library(httr)

###
# Test
###

# On choisit l'URL à extraire
url <- "https://www.ptb.be/actualites"

# On extrait la page
page <- GET(url)

# On converti la page en html (structure)
page_html <- htmlParse(page,encoding = "UTF-8")

# On navigue dans la page structurée
liste_actu <- getNodeSet(page_html,"//div[@class='page-excerpt padbottom']")

# Première actu
actu <- liste_actu[[1]]

titre <- getNodeSet(actu,".//h3[@class='headline']")
xmlValue(titre[[1]])

debut_texte <- getNodeSet(actu,".//div[@class='excerpt excerpt-text']")
xmlValue(debut_texte[[1]])

categorie <- getNodeSet(actu,".//span[@class='page-tag']")
xmlValue(categorie[[1]])

date <- getNodeSet(actu,".//div[@class='byline']")
xmlValue(date[[1]])

url1 <- getNodeSet(actu,".//h3[@class='headline']/a")
xmlAttrs(url1[[1]])

url1 <- xmlAttrs(url1[[1]])[["href"]]

paste("https://www.ptb.be",url1,sep="")
paste0("https://www.ptb.be",url1)

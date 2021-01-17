###
# Packages nécessaires
###

# Installation des packages (une seule fois)

install.packages('XML')
install.packages('RCurl')
install.packages('stringr')
install.packages('httr')

# Chargement des packages

library(XML)
library(RCurl)
library(stringr)
library(httr)

###
# Paramètres à choisir
###

# Nombre de pages à extraire
nb_pages <- 30

###
# Récupération automatique
###

# Déclarer le tableau pour pouvoir collecter les données
tableau_articles <- data.frame(titre=NA,url_texte=NA,texte=NA,categorie=NA,date=NA,tps_lecture=NA)[0,]

# Lister les url à parcourir
list_url <- paste("https://lafranceinsoumise.fr/actualites/mouvement/",c(1:nb_pages),"/",sep="")

# Correction spéciale pour la page 1
list_url[1] <- "https://lafranceinsoumise.fr/actualites/mouvement/"

# Boucle sur chaque url
for (url in list_url){
  
  # Donner le % d'extraction
  print(paste("url n°",which(url == list_url)," sur ",length(list_url), sep=""))
  
  # Extraire la page web des actualités (pour obtenir les articles)
  page_html <- try(htmlParse(GET(url),encoding = "UTF-8"),silent=TRUE)
  
  # Vérifier si l'extraction s'est déroulé convenablement
  if(class(page)[1] != "try-error"){
    
    # Lister les articles
    liste_actu <- getNodeSet(page_html,"//div[@class='elementor-post__card']")
    
    # Boucle sur chaque article
    for (id_actu in 1:length(liste_actu)){
      
      # Extraire la node de l'article
      actu <- liste_actu[[id_actu]]
      
      # Extraire les données
      titre <- xmlValue(getNodeSet(actu,".//h3[@class='elementor-post__title']")[[1]])
      # Nettoyer l'info
      titre <- str_remove_all(titre,"\n|\t")
      url_texte <- xmlAttrs(getNodeSet(actu,".//h3[@class='elementor-post__title']/a")[[1]])[['href']]
      resume <- xmlValue(getNodeSet(actu,".//div[@class='elementor-post__excerpt']")[[1]])
      
      # Attention : il n'y a parfois pas de categorie
      categorie <- try(xmlValue(getNodeSet(actu,".//div[@class='elementor-post__badge']")[[1]]),silent=TRUE)
      if(class(categorie) == "try-error") categorie <- NA
      
      date <- xmlValue(getNodeSet(actu,".//span[@class='elementor-post-date']")[[1]])
      date <- str_remove_all(date,"\n|\t")
      
      # Extraire la page web de l'article (pour obtenir le texte)
      page_texte <- try(htmlParse(GET(url_texte),encoding = "UTF-8"),silent=TRUE)
      
      # Vérifier si l'extraction s'est déroulé convenablement
      if(class(page_texte)[1] != "try-error"){
        
        # Extraire les données
        texte <- xmlValue(getNodeSet(page_texte,"//div[@class='entry-content']//p")[[1]])
        
        tps_lecture <- try(xmlAttrs(getNodeSet(page_texte,"//span[@class ='bsf-rt-display-time']")[[1]])[['reading_time']],silent=TRUE)
        if(class(tps_lecture) == "try-error") tps_lecture <- NA
        
        # Insérer une nouvelle ligne dans le tableau
        tableau_articles[nrow(tableau_articles)+1,] <-  list(titre,url_texte,texte,categorie,date,tps_lecture)
      } else {
        print(paste("Erreur sur l'article n°",id_actu," de la page ",which(url == list_url),sep=""))
      }
      # Attendre, pour éviter tout blocage
      Sys.sleep(2)
    }
  } else {
    print(paste("Erreur sur la page ",which(url == list_url),sep=""))
  }
}

###
# Sauvegarde des résultats (indiquez votre répertoire de travail)
###

# En format R
save(tableau_articles,file = 'FOLDER/tableau_articles_FI')

# En format CSV
write.csv2(tableau_articles,file = 'FOLDER/tableau_articles_FI.csv')

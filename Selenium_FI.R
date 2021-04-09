install.packages("RSelenium")

library(RSelenium)

remDr <- rsDriver(browser = "firefox")$client

# Si problème de port déjà utilisé
# remDr <- rsDriver(port=4568L, browser = "firefox")$client

# Ouvrir ou fermer le navigateur
# remDr$open()
# remDr$close()

url <- "https://lafranceinsoumise.fr/actualites/mouvement/"

# Ouvrir une page web
remDr$navigate(url)

# Récupération des actualités

# remDr$findElements -> Liste (de 0 à N)
# remDr$findElement -> objet (uniquement le premier de la liste, et erreur si 0)

# remDr$findElements("xpath","chemin")
# remDr$findElement("xpath","chemin")

liste_actu <- remDr$findElements("xpath", "//div[@class='elementor-post__card']")

# Focus sur la première actualité
actu <- liste_actu[[1]]

# Récupération du titre

# actu$findChildElements -> Pour extraire à partir d'un élément d'une page, et non à partir de la page complète

# Egalement : différence entre extraction de liste et d'objet :
# actu$findChildElement
# actu$findChildElements

# Ici, on s'attend à avoir un seul titre :
titre <- actu$findChildElement("xpath", ".//h3[@class='elementor-post__title']")

# Extraction du contenu ou du texte de la balise
# getElementText : récupérer le texte
# getElementAttribute : récupérer un attribut

titre$getElementText()

# Attention, getElementText renvoit une liste
titre$getElementText()[[1]]

titre <- actu$findChildElement("xpath", ".//h3[@class='elementor-post__title']")$getElementText()[[1]]

# URL
url_texte <- actu$findChildElement("xpath", ".//h3[@class='elementor-post__title']/a")$getElementAttribute("href")[[1]]

# Résumé
resume <- actu$findChildElement("xpath", ".//div[@class='elementor-post__excerpt']")$getElementText()[[1]]

# Mot clef
# Ici, test si mot-clef absent : findChildElements
mot_cle <- actu$findChildElements("xpath", ".//div[@class='elementor-post__badge']")

if (length(mot_cle) > 0){
  mot_cle <- mot_cle[[1]]$getElementText()[[1]]
}else{
  mot_cle <- NA
}

###
# Gestion des onglets
###

# Il est nécessaire d'ouvrir à l'avance le nombre d'onglets souhaités

# Liste des onglets actuels
liste_tab <- remDr$getWindowHandles()

# ID de l'onglet actuel
# remDr$getCurrentWindowHandle()

# Changer d'onglet
remDr$switchToWindow(liste_tab[[1]])
remDr$switchToWindow(liste_tab[[2]])

# Page de l'article
remDr$navigate(url_texte)

# Extraire le texte
texte <- remDr$findElement("xpath", "//div[@class='entry-content']")$getElementText()[[1]]

# Temps de lecture
tps_lecture <- remDr$findElement("xpath","//span[@class ='bsf-rt-display-time']")$getElementAttribute('reading_time')[[1]]

###
# Quelques commandes supplémentaires
###

# Aller vers le haut ou le bas de la page (scroll automatique)
webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))
webElem$sendKeysToElement(list(key = "home"))

# Petits mouvements haut ou bas
webElem$sendKeysToElement(list(key = "down_arrow"))
webElem$sendKeysToElement(list(key = "up_arrow"))

# Liste des commandes possibles
names(selKeys)

# Cliquer sur un élément
remDr$switchToWindow(liste_tab[[1]])
liste_actu <- remDr$findElements("xpath", "//div[@class='elementor-post__card']")
actu <- liste_actu[[1]]

titre <- actu$findChildElement("xpath", ".//h3[@class='elementor-post__title']")

titre$clickElement()

# Retour arrière / avant
remDr$goBack()
remDr$goForward()

# Faire un screenshot de la page
name_file <- paste('test',id_boucle,'.png',sep="")
remDr$screenshot(file = name_file)

# Se loguer sur un site web (NE MARCHE PAS ICI)
mail <- remDr$findElement("xpath", "//input[@name='name']")
password <- remDr$findElement("xpath", "//input[@id='pass']")

mail$sendKeysToElement(list("votre_mail"))
password$sendKeysToElement(list("votre_password"))
password$sendKeysToElement(list(key = "enter"))
Sys.sleep(2)


# Exemple de récupération selon le texte

"//balise[contains(text(),'texte du bouton')]"

"//balise[contains(@class,'texte de attribut)]"
"OU //balise[contains(class,'texte de attribut)]"


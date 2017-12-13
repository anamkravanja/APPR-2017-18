# 2. faza: Uvoz podatkov, tidy data Ana Marija Kravanja
library(knitr)
library(dplyr)
library(readr)
library(rvest)
library(gsubfn)
library(ggplot2)
library(reshape2)
library(shiny)
library(tidyr)
sl <- locale(encoding = "Windows-1250", decimal_mark = ",", grouping_mark = ".")

#uvoz prve tabele: povprečne plače po dejavnostih
sl <- locale(encoding = "Windows-1250", decimal_mark = ",", grouping_mark = ".")
povprecne_place_po_dejavnostih <- read_csv2("podatki/povprecne_place_po_dejavnostih.csv", 
                                            locale = sl, trim_ws = TRUE, skip = 3,
                                            na = c("-", ""), n_max = 24)
stolpci <- data.frame(spol = povprecne_place_po_dejavnostih[2, ] %>% unlist(),
                      leto = colnames(povprecne_place_po_dejavnostih) %>%
                      { gsub("X.*", NA, .) } %>% parse_number(),
                      izobrazba = povprecne_place_po_dejavnostih[1, ] %>% unlist()) %>%
  fill(1:3) %>% apply(1, paste, collapse = "")
stolpci[1] <- "dejavnost"
colnames(povprecne_place_po_dejavnostih) <- stolpci
povp.place.dejavnost <- melt(povprecne_place_po_dejavnostih[-c(1, 2), ], value.name = "povp.placa",
                             id.vars = "dejavnost", variable.name = "stolpec") %>%
  mutate(stolpec = parse_character(stolpec)) %>%
  transmute(leto = stolpec %>% strapplyc("([0-9]+)") %>% unlist() %>% parse_number(),
            spol = stolpec %>% strapplyc("^([^0-9]+)") %>% unlist() %>% factor(), dejavnost,
            izobrazba = stolpec %>% strapplyc("([^0-9]+)$") %>% unlist() %>% factor(), povp.placa)

View(povp.place.dejavnost)
View(povprecne_place_po_dejavnostih)

#uvoz druge tabele: povprecne place po statisticnih regijah
povprecne_place_po_statisticnih_regijah <- read_csv2("podatki/povprecne_place_po_statisticnih_regijah.csv", 
                                                     locale = sl, trim_ws = TRUE, skip = 3,
                                                     na=c("-","","z"),n_max=118)
stolpci1 <- data.frame(spol = povprecne_place_po_statisticnih_regijah[1,] %>% unlist(),
                      leto = colnames(povprecne_place_po_statisticnih_regijah) %>%
                      { gsub("X.*", NA, .) } %>% parse_number()) %>% 
    fill(1:2) %>% apply(1, paste, collapse = "")
stolpci1[1] <- "statisticna regija"
stolpci1[2] <- "starost"
colnames(povprecne_place_po_statisticnih_regijah) <-stolpci1
povprecne_place_po_statisticnih_regijah <- fill(povprecne_place_po_statisticnih_regijah,"statisticna regija")[-c(2,11,20,29,38,47,56,65,74,83,92,110), ]
View(povprecne_place_po_statisticnih_regijah)



#uvoz tretje tabele: povprecne place glede na izobrazbo
povprecne_place_glede_na_izobrazbo <- read_csv2("podatki/povprecne_place_glede_na_izobrazbo.csv", 
                                            locale = sl, trim_ws = TRUE, skip = 3,
                                            na=c("-","","z"), n_max = 21)
View(povprecne_place_glede_na_izobrazbo)
stolpci2 <- data.frame(spol = povprecne_place_glede_na_izobrazbo[1,] %>% unlist(),
                       leto = colnames(povprecne_place_glede_na_izobrazbo) %>%
                       { gsub("X.*", NA, .) } %>% parse_number()) %>% 
  fill(1:2) %>% apply(1, paste, collapse = "")
stolpci1[1] <- "sektor"
stolpci1[2] <- "spol"
colnames(povprecne_place_glede_na_izobrazbo) <-stolpci1
povprecne_place_glede_na_izobrazbo <- fill(povprecne_place_glede_na_izobrazbo,"sektor")[-c(2,6,10,14,18), ]
View(povprecne_place_glede_na_izobrazbo)

#uvoz četrte tabele: minimalne_place_v_Evropi
library(gsubfn)
library(readr)
library(dplyr)
library(XML)
library(reshape2)

minimalne_place_v_evropi <- readHTMLTable("podatki/minimalne_place_v_Evropi.html",
                                      which = 1)
colnames(minimalne_place_v_evropi) <- c("DRŽAVA", 1999:2017)

for (col in colnames(minimalne_place_v_evropi)) {
 minimalne_place_v_evropi[minimalne_place_v_evropi[[col]] == ":(z)", col] <- NA}

problems(minimalne_place_v_evropi)
View(minimalne_place_v_evropi)



#uvoz podatkov html izdatki za potovanje


izdatki_za_potovanja <- readHTMLTable("podatki/izdatki_za_potovanje.html",
                          which = 1)
colnames(izdatki_za_potovanja) <- c("DRŽAVA", 2012:2016)

for (col in colnames(izdatki_za_potovanja)) {
  izdatki_za_potovanja[izdatki_za_potovanja[[col]] == ":", col] <- NA}
izdatki_za_potovanja <- gather(izdatki_za_potovanja, `2012`, `2013`, `2014`, `2015`, `2016`,key = "leta", value = "izdatki v €")
problems(izdatki_za_potovanja)
View(izdatki_za_potovanja)

#združevanje tabel 4. in 5.



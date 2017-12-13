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
                                            


#uvoz tretje tabele: povprecne place glede na izobrazbo
povprecne_place_glede_na_izobrazbo <- read_csv2("podatki/povprecne_place_glede_na_izobrazbo.csv", 
                                            locale = sl, trim_ws = TRUE, skip = 3,
                                            na = c("-", ""), n_max = 22)

View(povprecne_place_glede_na_izobrazbo)

#uvoz četrte tabele: minimalne place v Evropi
minimalne_place_v_evropi <- read_csv("podatki/minimalne_place_v_evropi.csv",
                                     col_names = c("leto", "drzava", "enota", "vrednost", "izbrisi" ), 
                                     na = ":",
                                     skip =1,
                                     locale = locale(encoding = "Windows-1250", decimal_mark = "."))
minimalne_place_v_evropi <- minimalne_place_v_evropi[!(is.na(minimalne_place_v_evropi$vrednost)),]
minimalne_place_v_evropi <- minimalne_place_v_evropi[c("drzava","leto", "enota", "vrednost", "izbrisi" )]
minimalne_place_v_evropi[5]<-NULL
minimalne_place_v_evropi[3]<-NULL
minimalne_place_v_evropi <- spread(minimalne_place_v_evropi,leto,vrednost)
names(minimalne_place_v_evropi) <- c("LETO","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017")
View(minimalne_place_v_evropi)


#uvoz podatkov iz html
library(gsubfn)
library(readr)
library(dplyr)
library(XML)
library(reshape2)

izdatki_za_potovanja <- readHTMLTable("podatki/izdatki_za_potovanje.html",
                          which = 1)
colnames(izdatki_za_potovanja) <- c("DRŽAVA", 2012:2016)

for (col in colnames(izdatki_za_potovanja)) {
  izdatki_za_potovanja[izdatki_za_potovanja[[col]] == ":", col] <- NA}

problems(izdatki_za_potovanja)
View(izdatki_za_potovanja)

#združevanje tabel 4. in 5.



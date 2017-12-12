# 2. faza: Uvoz podatkov Ana Marija Kravanja

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")
library(rvest)
library(gsubfn)
library(readr)
library(dplyr)

#uvoz prve tabele: povprečne plače po dejavnostih
povprecne_place_po_dejavnostih <- read_csv("podatki/povprecne_place_po_dejavnostih.csv", 
                                             ";", escape_double = FALSE, 
                                             locale = locale(encoding = "ISO-8859-2"), 
                                             na = "empty", trim_ws = TRUE)
View(povprecne_place_po_dejavnostih)

#uvoz druge tabele: povprecne place po statisticnih regijah
povprecne_place_po_statisticnih_regijah <- read_delim("podatki/povprecne_place_po_statisticnih_regijah.csv", 
                                                      ";", escape_double = FALSE, locale = locale(encoding = "ISO-8859-2"), 
                                                      na = "NA", trim_ws = TRUE)
View(povprecne_place_po_statisticnih_regijah)

#uvoz tretje tabele: povprecne place glede na izobrazbo
povprecne_place_glede_na_izobrazbo <- read_delim("podatki/povprecne_place_glede_na_izobrazbo.csv", 
                                                 ";", escape_double = FALSE, locale = locale(encoding = "ISO-8859-2"), 
                                                 na = "NA", trim_ws = TRUE)
View(povprecne_place_glede_na_izobrazbo)

#uvoz četrte tabele: minimalne place v Evropi
minimalne_place_v_evropi <- read_csv("podatki/minimalne_place_v_evropi.csv")

View(minimalne_place_v_evropi)

#uvoz pete tabele: rast BDP po dejavnostih
rast_BDP_po_dejavnostih <- read_delim("podatki/rast_BDP_po_dejavnostih.csv", 
                                      ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                                      trim_ws = TRUE, skip = 2)
View(rast_BDP_po_dejavnostih)

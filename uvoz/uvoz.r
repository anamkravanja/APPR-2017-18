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



# 2. faza: Uvoz podatkov Ana Marija Kravanja


sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")


#uvoz prve tabele: povprečne plače po dejavnostih
#stolpci1 <-c("DEJAVNOST","DOSEŽENA IZOBRAZBA","SPOL","LETO","STEVILO")
povprecne_place_po_dejavnostih <- read_delim("podatki/povprecne_place_po_dejavnostih.csv", 
                                              ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                                              trim_ws = TRUE, skip = 3,
                                              #col_names = stolpci1,
                                              n_max=23)
podatki <- povprecne_place_po_dejavnostih %>% fill(1:5) %>% drop_na(LETO)
#View(povprecne_place_po_dejavnostih)


#uvoz druge tabele: povprecne place po statisticnih regijah
povprecne_place_po_statisticnih_regijah <- read_delim("podatki/povprecne_place_po_statisticnih_regijah.csv", 
                                                      ";", escape_double = FALSE, locale = locale(encoding = "ISO-8859-2"), 
                                                      na = "NA", trim_ws = TRUE)
#View(povprecne_place_po_statisticnih_regijah)

#uvoz tretje tabele: povprecne place glede na izobrazbo
povprecne_place_glede_na_izobrazbo <- read_delim("podatki/povprecne_place_glede_na_izobrazbo.csv", 
                                                 ";", escape_double = FALSE, locale = locale(encoding = "ISO-8859-2"), 
                                                 na = "NA", trim_ws = TRUE)
#View(povprecne_place_glede_na_izobrazbo)

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

#uvoz pete tabele: rast BDP po dejavnostih
rast_BDP_po_dejavnostih <- read_delim("podatki/rast_BDP_po_dejavnostih.csv", 
                                      ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                                      trim_ws = TRUE, skip = 2)[-c(30:39), ] 
#View(rast_BDP_po_dejavnostih)


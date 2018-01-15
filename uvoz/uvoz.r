# 2. faza: Uvoz podatkov, tidy data Ana Marija Kravanja

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
            izobrazba = stolpec %>% strapplyc("([^0-9]+)$") %>% unlist() %>% factor(), povp.placa =parse_number(povp.placa))
povp.place.dejavnost <- povp.place.dejavnost%>% filter(izobrazba == "Izobrazba - SKUPAJ",
                                                        spol == "Spol - SKUPAJ",
                                                         dejavnost != "SKD DEJAVNOST - SKUPAJ") %>%group_by(dejavnost) %>% summarise(povprecje = mean(povp.placa))
povp.place.dejavnost<- povp.place.dejavnost[-c(20,21), ]

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
povprecne_place_po_statisticnih_regijah <- unite(povprecne_place_po_statisticnih_regijah,"statisticna regija","starost",
                                                 col = "starost", sep = ",")
povpr.place.stat.reg. <- melt(povprecne_place_po_statisticnih_regijah[-c(1), ], value.name = "povpr.placa",
                              id.vars = "starost", variable.name = "stolpec")%>%
  mutate(stolpec = parse_character(stolpec)) %>%
  transmute(leto = stolpec %>% strapplyc("([0-9]+)") %>% unlist() %>% parse_number(),
            spol = stolpec %>% strapplyc("^([^0-9]+)") %>% unlist() %>% factor(), starost,povpr.placa = parse_number(povpr.placa))
povpr.place.stat.reg. <- separate(povpr.place.stat.reg., starost,
                                  into = c("regija", "starost"),sep=",")
povpr.place.stat.reg. <- povpr.place.stat.reg.%>% filter(spol == "Spol - SKUPAJ",
                                starost == "Starost - SKUPAJ",
                                regija != "SLOVENIJA") %>%group_by(regija) %>% summarise(povprecje = mean(povpr.placa))


#uvoz tretje tabele: povprecne place glede na izobrazbo
povprecne_place_glede_na_izobrazbo <- read_csv2("podatki/povprecne_place_glede_na_izobrazbo.csv", 
                                            locale = sl, trim_ws = TRUE, skip = 3,
                                            na=c("-","","z"), n_max = 21)
stolpci2 <- data.frame(spol = povprecne_place_glede_na_izobrazbo[1,] %>% unlist(),
                       leto = colnames(povprecne_place_glede_na_izobrazbo) %>%
                       { gsub("X.*", NA, .) } %>% parse_number()) %>% 
  fill(1:2) %>% apply(1, paste, collapse = "")
stolpci2[1] <- "sektor"
stolpci2[2] <- "spol"
colnames(povprecne_place_glede_na_izobrazbo) <-stolpci2
povprecne_place_glede_na_izobrazbo <- fill(povprecne_place_glede_na_izobrazbo,"sektor")[-c(2,6,10,14,18), ]
povprecne_place_glede_na_izobrazbo<- unite(povprecne_place_glede_na_izobrazbo,"sektor","spol",
                                                 col = "sektor", sep = ",")

povpr.place.izobr <- melt(povprecne_place_glede_na_izobrazbo[-c(1), ], value.name = "povpr.placa",
                              id.vars = "sektor", variable.name = "stolpec")%>%
  mutate(stolpec = parse_character(stolpec)) %>%
  transmute(leto = stolpec %>% strapplyc("([0-9]+)") %>% unlist() %>% parse_number(),
            izobrazba = stolpec %>% strapplyc("^([^0-9]+)") %>% unlist() %>% factor(),sektor,
            povpr.placa = parse_number(povpr.placa))
povpr.place.izobr <- separate(povpr.place.izobr, sektor,
                                  into = c("sektor", "spol"),sep=",")


#uvoz četrte tabele: minimalne_place_v_Evropi
minimalne_place_v_evropi <- readHTMLTable("podatki/minimalne_place_v_Evropi.html",
                                      which = 1)
colnames(minimalne_place_v_evropi) <- c("DRZAVA", 1999:2017)

minimalne_place_v_evropi <- melt(minimalne_place_v_evropi, id.vars = "DRZAVA", variable.name = "leto",
                                 value.name = "place") %>% mutate(place = parse_number(place, na = c(":", ":(z)"))) %>%
  drop_na("place")
minimalne_place_v_evropi<- minimalne_place_v_evropi[c("leto","DRZAVA","place")]

#uvoz podatkov html izdatki za potovanje
izdatki_za_potovanja <- readHTMLTable("podatki/izdatki_za_potovanje.html",
                          which = 1)
colnames(izdatki_za_potovanja) <- c("DRZAVA", 2012:2016)

izdatki_za_potovanja <- melt(izdatki_za_potovanja, id.vars = "DRZAVA", variable.name = "leto",
                             value.name = "izdatki") %>% mutate(izdatki= parse_number(izdatki, na = c(":", ":(z)"))) %>%
  drop_na("izdatki")
izdatki_za_potovanja <-izdatki_za_potovanja[c("leto","DRZAVA","izdatki")]


#združevanje tabel 4. in 5.: samo podatki, ki so v obeh tabelah
primerjava_tabel <- inner_join(minimalne_place_v_evropi,izdatki_za_potovanja)
primerjava_tabel[87,2] <- "Germany"
primerjava_tabel[66,2] <- "Germany"




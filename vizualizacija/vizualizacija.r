# 3. faza: Vizualizacija podatkov

library(ggplot2)
library(dplyr)

#graf, ki primerja minimalne plače v Evropi in izdatke za potovanja v istih evropskih državah
g <- ggplot(primerjava_tabel) + aes(x = DRZAVA, y = place,color=leto,size = izdatki) + geom_point() +ggtitle("Minimalne plače in izdatki za potovanja v EU")


#graf, ki prikazuje povprečne plače glede na izbrazbo v določenem sektorju
povpr.place.izobr<-povpr.place.izobr[!(povpr.place.izobr$izobrazba=="Izobrazba - Skupaj"),]
povpr.place.izobr <- povpr.place.izobr[- grep("SKUPAJ", povpr.place.izobr$sektor),]
povpr.place.izobr<-povpr.place.izobr[!(povpr.place.izobr$spol=="Spol - SKUPAJ"),]


h <- ggplot(povpr.place.izobr) + aes(x = leto, y = povpr.placa ,color=izobrazba, shape = spol) + geom_point()+ ggtitle("povprečne plače glede na izobrazbo")


#izračun povprečja v regijah za tabelo



zemljevid <- uvozi.zemljevid("http://www.stat.si/doc/Geo/Statisticne_regije_NUTS3.zip",
    "statisticne_regije", encoding = "Windows-1250")%>%
    pretvori.zemljevid()
ggplot() + geom_polygon(data = zemljevid, aes(x = long, y = lat,
                                           group = group, fill = id)) +
  guides(fill = FALSE)

ggplot() + geom_polygon(data = left_join(regija, povpr.placa,
                                         by = c("IME" = "regija")),
                        aes(x = long, y = lat, group = group, fill = povpr.placa))


# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
zemljevid <- pretvori.zemljevid(zemljevid)

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))


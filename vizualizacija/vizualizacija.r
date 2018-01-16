# 3. faza: Vizualizacija podatkov
library(ggplot2)
library(dplyr)

#graf, ki primerja minimalne plače v Evropi in izdatke za potovanja v istih evropskih državah
EU.min. <- ggplot(primerjava_tabel) + aes(x = DRZAVA, y = place,color=leto,size = izdatki) + 
    geom_point() +ggtitle("Minimalne plače in izdatki za potovanja v EU")



#graf, ki prikazuje povprečne plače glede na izbrazbo v določenem sektorju
sektor <- povpr.place.izobr%>% filter(spol == "Spol - SKUPAJ",
                                      izobrazba != "Izobrazba - Skupaj",
                                      sektor != "1 Javni in zasebni sektor - SKUPAJ",
                                      sektor != "11 Javni sektor - SKUPAJ")
sekt <- ggplot(sektor,aes(izobrazba,povpr.placa))


izobrazba <- povpr.place.izobr%>% filter(spol != "Spol - SKUPAJ",
                                         izobrazba != "Izobrazba - Skupaj",
                                         sektor != "1 Javni in zasebni sektor - SKUPAJ",
                                         sektor != "11 Javni sektor - SKUPAJ")


#povprečna plača glede na dejavnost

dejavnost <- ggplot(povp.place.dejavnost, aes(dejavnost,povprecje,fill =dejavnost)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  theme_gray() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank())


#povprečna plača v določeni regiji 
zemljevid <- uvozi.zemljevid("http://www.stat.si/doc/Geo/Statisticne_regije_NUTS3.zip",
    "Statisticne_regije", encoding = "Windows-1250")%>%
    pretvori.zemljevid()




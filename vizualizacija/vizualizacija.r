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
sekt + geom_bar(stat = "identity", aes(fill = sektor),position = "dodge") + 
   xlab("Izobrazba") + ylab("Povprečna plača") +
  ggtitle("Povprečna plača glede na izobrazbo in sektor")+
  theme_bw()


izobrazba <- povpr.place.izobr%>% filter(spol != "Spol - SKUPAJ",
                                         izobrazba != "Izobrazba - Skupaj",
                                         sektor != "1 Javni in zasebni sektor - SKUPAJ",
                                         sektor != "11 Javni sektor - SKUPAJ")

izobr<- ggplot(izobrazba) + aes(x = leto, y = povpr.placa ,color=izobrazba, shape = spol) + geom_point()+ ggtitle("Povprečne plače glede na izobrazbo in spol")


#povprečna plača glede na dejavnost

dejavnost <- ggplot(povp.place.dejavnost, aes(dejavnost,povprecje,fill =dejavnost)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  theme_gray() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank())
  
dejavnost +coord_polar() 


#povprečna plača v določeni regiji 

zemljevid <- uvozi.zemljevid("http://www.stat.si/doc/Geo/Statisticne_regije_NUTS3.zip",
    "statisticne_regije", encoding = "Windows-1250")%>%
    pretvori.zemljevid()
ggplot() + geom_polygon(data = zemljevid, aes(x = long, y = lat,
                                           group = group, fill = id)) +
  guides(fill = FALSE)

ggplot() + geom_polygon(data = left_join(zemljevid,povpr.place.stat.reg.,
                                         by = c("IME" = "regija")),
                        aes(x = long, y = lat, group = group, fill = povprecje))


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


# 3. faza: Vizualizacija podatkov
library(ggplot2)
library(dplyr)

#graf, ki primerja minimalne plače v Evropi in izdatke za potovanja v istih evropskih državah
EU.min. <- ggplot(primerjava_tabel) + aes(x = DRZAVA, y = place,color=factor(leto),size = izdatki) + 
    geom_point() +ggtitle("Minimalne plače in izdatki za potovanja v EU")

EUminimum <- EU.min. + theme(axis.text.x = element_text(angle = 90, hjust = 1))
EUminimum <- EUminimum  + guides(color = guide_legend("Leto"))

#graf, ki prikazuje povprečne plače glede na izbrazbo v določenem sektorju
sektor <- povpr.place.izobr%>% filter(spol == "Spol - SKUPAJ",
                                      izobrazba != "Izobrazba - Skupaj",
                                      sektor != "1 Javni in zasebni sektor - SKUPAJ",
                                      sektor != "11 Javni sektor - SKUPAJ")
sekt <- ggplot(sektor,aes(izobrazba,povpr.placa))
sektorji <- sekt + geom_bar(stat = "identity", aes(fill = sektor),position = "dodge") + 
  xlab("Izobrazba") + ylab("Povprečna plača") +
  ggtitle("Povprečna plača glede na izobrazbo in sektor")+
  theme_bw()

izobrazba <- povpr.place.izobr%>% filter(spol != "Spol - SKUPAJ",
                                         izobrazba != "Izobrazba - Skupaj",
                                         sektor != "1 Javni in zasebni sektor - SKUPAJ",
                                         sektor != "11 Javni sektor - SKUPAJ")

izobraz <- ggplot(izobrazba) + aes(x = leto, y = povpr.placa ,color=izobrazba, shape = spol,linetype=sektor) + geom_point()+ geom_line()+ggtitle("Povprečne plače glede na izobrazbo in spol")

#povprečna plača glede na dejavnost
povp.place.dejavnost <- povp.place.dejavnost%>% filter(izobrazba == "Izobrazba - SKUPAJ",
                                                       spol == "Spol - SKUPAJ",
                                                       dejavnost != "SKD DEJAVNOST - SKUPAJ") %>%group_by(dejavnost) %>% summarise(povprecje = mean(povp.placa))
povp.place.dejavnost<- povp.place.dejavnost[-c(20,21), ]

dejavnost <- ggplot(povp.place.dejavnost, aes(dejavnost,povprecje,fill =dejavnost)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  theme_gray() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank(),
        legend.text = element_text(size = 6))

dejavnosti <- dejavnost +coord_polar() + theme(legend.text = element_text(size = 7)) + guides(fill=FALSE)


#povprečna plača v določeni regiji 
povpr.place.stat.reg.n <- povpr.place.stat.reg.%>%
  filter(spol == "Spol - SKUPAJ", starost == "Starost - SKUPAJ", regija != "SLOVENIJA") %>%
  group_by(regija) %>% summarise(povprecje = mean(povpr.placa))


zemljevid <- uvozi.zemljevid("http://www.stat.si/doc/Geo/Statisticne_regije_NUTS3.zip",
    "Statisticne_regije", encoding = "Windows-1250")%>%
    pretvori.zemljevid()





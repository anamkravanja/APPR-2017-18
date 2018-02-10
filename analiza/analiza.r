# 4. faza: Analiza podatkov

#podatki <- obcine %>% transmute(obcina, povrsina, gostota,
 #                               gostota.naselij = naselja/povrsina) %>%
  #left_join(povprecja, by = "obcina")
#row.names(podatki) <- podatki$obcina
#podatki$obcina <- NULL

# Število skupin
#n <- 5
#skupine <- hclust(dist(scale(podatki))) %>% cutree(n)
require(ggplot2)
require(dplyr)

#predvidevanje gibanja 
izo <- izobraz + geom_smooth(method = "loess")
lin <- lm(data = izobrazba,  povpr.placa ~ leto )
predict(lin, data.frame(leto=seq(2016,2025)))
#izris napovedi
nova <- data.frame(leto=seq(2016,2025))
napoved <- nova %>% mutate(povpr.placa=predict(lin,.))

#grupiranje
graf <- ggplot(primerjava_tabel, aes(x=place,y=izdatki)) + geom_point()
fit <- lm(izdatki ~ place, data = primerjava_tabel)
summary(fit)
graf <- graf +geom_smooth(method = lm)
novi_izdatki <- data.frame(primerajava_tabel)
predict(fit,novi_izdatki)
napoved1 <- novi_izdatki %>% mutate(izdatki = predict(fit, .))

koncen_graf <- graf + geom_point(shape = 1) +
  geom_smooth(method = lm)+
  geom_point(data = napoved1,color='purple',size=3)







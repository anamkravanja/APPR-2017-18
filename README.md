# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

# Analiza plač v Sloveniji

V svojem projektu bom analizirala plače v Sloveniji. Zanimali me bodo podatki o višini plače glede na dejavnosti ter višina plače glede na spol in starost. Analizirala bom tudi ali pride do razlik v plači med javnim in zasebnim sektorjem glede na stopnjo izobrazbe osebe. Nato pa bom primerjala minimalno plačo v Sloveniji z minimalnimi po drugih evropskih državah.

Ker je višina minimalne plače odvisna od več dejavnikov in se spreminja, bom dodatno primerjala povprečne mesečne plače z realnim gibanjem gospodarske rasti po posameznih dejavnostih.

Vir podatkov so Eurostat, SURS in FURS. 
Podatki so v obliki CSV in HTML

### Zasnova podatkovnega modela: 
#### Tabele: 
1.	tabela (CSV): **Povprečne mesečne plače in indeks povprečnih mesečnih plač po dejavnostih (v eurih in realno indeks glede na prejšni mesec)**
* stolpci: dejavnost, obdobje (2008-2016),bruto plače,neto plače

2.	tabela (CSV): **Povprečne mesečne bruto plače po statističnih regijah,starosti,letu in spolu**
*	stolpci: statisične regije, starost, leto in spol

3.	tabela (CSV): **Primerjava minimalnih plač med EU(28) državami** 
*	stolpci: države, leta

4. tabela (csv): **Povprečne mesečne bruto plače v javnem in zasebnem sektorju glede na doseženo izobrazbo**
* stolpci: sektor, spol, leto in stonja izobrazbe

#### Viri: 
* http://pxweb.stat.si/pxweb/Database/Dem_soc/07_trg_dela/10_place/03_07113_strukt_statistika/03_07113_strukt_statistika.asp
* http://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=1&pcode=tps00155&language=en
* http://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=0711322S&ti=&path=../Database/Dem_soc/07_trg_dela/10_place/03_07113_strukt_statistika/&lang=2
* http://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=0701011S&ti=&path=../Database/Dem_soc/07_trg_dela/10_place/01_07010_place/&lang=2 
* http://pxweb.stat.si/pxweb/Dialog/varval.asp?ma=0301915S&ti=&path=../Database/Ekonomsko/03_nacionalni_racuni/05_03019_BDP_letni/&lang=2

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

library(shiny)

#shinyUI(fluidPage(
#  
#  titlePanel("Slovenske občine"),
#  
#  tabsetPanel(
#      tabPanel("Velikost družine",
#               DT::dataTableOutput("druzine")),
#      
#      tabPanel("Število naselij",
#               sidebarPanel(
#                  uiOutput("pokrajine")
#                ),
#               mainPanel(plotOutput("naselja")))
#    )
#))

# User interface ----

povpr.place.stat.reg.n <- separate(povpr.place.stat.reg., starost,
                                   into = c("regija", "starost"),sep=",")
povpr.place.stat.reg.n <- povpr.place.stat.reg.n%>% filter(starost == "Starost - SKUPAJ",
                                                           regija != "SLOVENIJA")
zemljevid <- uvozi.zemljevid("http://www.stat.si/doc/Geo/Statisticne_regije_NUTS3.zip",
                             "Statisticne_regije", encoding = "Windows-1250")%>%
  pretvori.zemljevid()
ggplot() + geom_polygon(data = left_join(zemljevid,povpr.place.stat.reg.n,
                                         by = c("IME" = "regija")),
                        aes(x = long, y = lat, group = group, fill = povpr.placa))


ui <- fluidPage(
  titlePanel("povprečne plače po regijah v letih 2008-2016"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Glede na izbrano leto se prikaže graf, opazujemo lahko spremembe"),
      
      selectInput("var", 
                  label = "Izberite leto",
                  choices = c("2008","2009","2010","2011","2012","2013","2014","2015","2016"),
                  selected = "2016"),
      
    
    mainPanel(plotOutput("zemljevid"))
    )
  )
)


server <- function(input, output) {
  output$zemljeivd <- renderPlot({
    percent_map()
  })
}

shinyApp(ui, server)
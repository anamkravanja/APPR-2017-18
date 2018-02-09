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

library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Spreminajnje skozi obdobja in glede na države "),


  tabsetPanel(
    tabPanel("Minimalne plače in izdatki za potovanja",
             titlePanel("Minimalne plače in izdatki za porovanja v EU"),
             sidebarPanel(
               selectInput("drzava",
                           label = "Izberite državo",
                           choices = sort(unique(primerjava_tabel$DRZAVA)),
                           selected = "Slovenia")
             ),
             mainPanel(plotOutput("graf.min"))
    ),
    tabPanel("Povprečne plače po regijah",
             titlePanel("Povprečne plače po regijah v letih 2008-2016"),
             sidebarPanel(
               radioButtons("leto",
                           label = "Izberite leto",
                           choices = 2008:2016,
                           selected = 2016)
             ),
             mainPanel(plotOutput("zemljevid"))
    )
  )
))
library(shiny)

#shinyServer(function(input, output) {
#  output$druzine <- DT::renderDataTable({
#    dcast(druzine, obcina ~ velikost.druzine, value.var = "stevilo.druzin") %>%
#      rename(`Občina` = obcina)
#  })
#  
#  output$pokrajine <- renderUI(
#    selectInput("pokrajina", label="Izberi pokrajino",
#                choices=c("Vse", levels(obcine$pokrajina)))
#  )
#  output$naselja <- renderPlot({
#    main <- "Pogostost števila naselij"
#    if (!is.null(input$pokrajina) && input$pokrajina %in% levels(obcine$pokrajina)) {
#      t <- obcine %>% filter(pokrajina == input$pokrajina)
#      main <- paste(main, "v regiji", input$pokrajina)
#    } else {
#      t <- obcine
#    }
#    ggplot(t, aes(x = naselja)) + geom_histogram() +
#      ggtitle(main) + xlab("Število naselij") + ylab("Število občin")
#  })
# })

library(shiny)

shinyServer(function(input, output) {
  output$zemljevid <- renderPlot({
    ggplot() + geom_polygon(data = povpr.place.stat.reg. %>% filter(spol == "Spol - SKUPAJ",
                                                                    starost == "Starost - SKUPAJ",
                                                                    regija != "SLOVENIJA",
                                                                    leto == input$leto) %>%
                              right_join(zemljevid, by = c("regija" = "IME")),
                            aes(x = long, y = lat, group = group, fill = povpr.placa))
  })
  output$graf.min <- renderPlot({
    ggplot(primerjava_tabel %>% filter(DRZAVA == input$drzava)) +
      aes(x = leto, y = place, size = izdatki) + geom_point() +
      ggtitle("Minimalne plače in izdatki za potovanja")
  })
})


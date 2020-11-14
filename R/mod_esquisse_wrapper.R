#' esquisse_wrapper UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import esquisse
mod_esquisse_wrapper_ui <- function(id , filter = NULL){
  ns <- NS(id)
  tagList(
    fluidPage(

      titlePanel("Visualize Loaded Datasets with Esquisse"),
      fluidRow(
        column(8,
               shinyjs::useShinyjs(),
               wellPanel(
                 x <- uiOutput(ns('radios')),
                 #  actionButton('submit', label = "Submit"),

               )

         ),
        column(4, offset = 4,
               textOutput('text')

        )
      )
    ),
    fluidRow(column(12 ,
                    esquisserUI(
                      id = ns("esquisse"),
                      header = FALSE, # dont display gadget title
                      choose_data = FALSE, # dont display button to change data,
                      container = esquisseContainer(height = "700px")
                    )
                    ))

    )
}


#' esquisse_wrapper Server Functions
#'
#' @noRd
mod_esquisse_wrapper_server <- function(id , master){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    master_values <- reactiveValues(master_df = master)

    output$radios <- renderUI({

      options <- master_values$master_df$names
      # The options are dynamically generated on the server
      radioButtons(ns('radio_select'), 'Select Dataset to visualize', options, selected = character(0) ,
                   inline = TRUE)
    })


    observeEvent(input$radio_select, {
      cli::cli_alert_info("Radio selected ")
      nm <- input$radio_select
      t <- filter(master_values$master_df , names == nm)
      the_t <- unnest(as_tibble(t$dataset) , cols = c(data))
      data_r <- reactiveValues(data = the_t, name = nm)
      cli::cli_alert_info("Befoer Call Module {nm} ")
      callModule(module = esquisserServer, id = "ns(esquisse)", data = data_r)
    })

  })
}


## To be copied in the UI
# mod_esquisse_wrapper_ui("esquisse_wrapper_ui_1")

## To be copied in the server
# mod_esquisse_wrapper_server("esquisse_wrapper_ui_1")



#library(shiny)
#library(reactable)
#library(tidyr)
#library(shinyjs)
#library(cli)
#library(stringr)
#source("spring_util.R")
#library(esquisse)
#library(readr)


#f1 <- read_csv("")

#tb <- tibble::tibble(
#  "srnum" = 1,
#  "names" = "test_table",
#  "filenames" = "C:\\Data\\collections_lawsuits\\CHART1_NJ.csv",
#  "dataset" = nest(ds)
#)

#master_df_preload()

#ui <- fluidPage(
#  mod_esquisse_wrapper_ui("esquisse_wrapper_ui_1")
#)

#server <- function(input, output, session) {
#  mod_esquisse_wrapper_server("esquisse_wrapper_ui_1")
#}

#shinyApp(ui, server)



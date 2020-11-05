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
mod_esquisse_wrapper_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(

      titlePanel("Visualize Loaded Datasets"),
      fluidRow(
        column(4,
          wellPanel(
            radioButtons(
              inputId = ns("data"),
              label = "Data to use:",
              choices = c(ns("iris"), ns("mtcars")),
              inline = TRUE
            )

          )
        ),
        column(4, offset = 4,
               "4 offset 4"
        )
      ),
      fluidRow(
        column(12,
               tabsetPanel(
                 tabPanel(
                   title = "esquisse",
                   esquisse::esquisserUI(
                     id = ns("esquisse"),
                     header = FALSE, # dont display gadget title
                     choose_data = FALSE # dont display button to change data
                   )
                 ),
                 tabPanel(
                   title = "output",
                   verbatimTextOutput(ns("module_out"))
                 )
               )
        )
      )
    ))
}


#' esquisse_wrapper Server Functions
#'
#' @noRd
mod_esquisse_wrapper_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


}

## To be copied in the UI
# mod_esquisse_wrapper_ui("esquisse_wrapper_ui_1")

## To be copied in the server
# mod_esquisse_wrapper_server("esquisse_wrapper_ui_1")

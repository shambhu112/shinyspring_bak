#' data_upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @import shinyjs
#' @import cli
#' @import reactable
#' @import tidyr
#' @importFrom stringr str_split
#' @importFrom snakecase to_any_case
#' @importFrom shiny NS tagList
mod_data_upload_ui <- function(id){
  ns <- NS(id)
  tagList(
    titlePanel("Dataset Uploads"),
    fluidRow(
      column(
        4,
        wellPanel(
          fileInput(
            inputId = ns("MyFiles"),
            label = "Upload files"
          ),
          shinyjs::useShinyjs(),
          textInput(ns("name_id"), label = "Enter Dataset Name"),
          shinyjs::disabled(
            actionButton(ns("add_btn"), label = "Add"),
            actionButton(ns("remove_btn"), label = "Remove"),
            actionButton(ns("preview_btn"), label = "Preview Table")
          )
        )
      ),
      column(
        8,
        mainPanel(
          reactable::reactableOutput(ns("table"))
        )
      )
    ),
    fluidRow(
      column(12 ,
             reactable::reactableOutput(ns("preview_table"))
             )


    )
  )
}

#' data_upload Server Functions
#' @import reactable
#' @noRd
mod_data_upload_server <- function(id , master){
  moduleServer(id, function(input, output, session ){
    ns <- session$ns

    master_values <- reactiveValues(master_df = master)

    fileInfo <- reactive(input$MyFiles)

    observeEvent(input$MyFiles, {
      f <- fileInfo()
      cli::cli_alert_info("  name {f$name}  ")

      #Creating the default name of dataset keeping the extention out
      a <- unlist(str_split(f$name, "\\."))
      l <- length(a) - 1
      nm <- ifelse(l > 0, a[1:l], a)
      nm <- snakecase::to_any_case(nm)
      cli::cli_alert_info("  ds name {nm}  ")
      # Name the Dataset with files name without the extention
      # And enable the add button
      updateTextInput(
        session = session, inputId = "name_id",
        value = nm
      )
      shinyjs::enable("add_btn")
    })

    #reactable selection tracker
    selected <- reactive(reactable::getReactableState("table", "selected"))

    # Call Onclick of add_btn
    onclick("add_btn", {
      f <- fileInfo()

      # TODO - repalce this with debug
      cli_alert_info("  attributes {attributes(f)}  ")
      lapply(f, function(x) {
        cli_alert_info("  item {x}  ")
      })

      # Read uploaded file
      # TODO put some checks at file load time
      # TODO remove warnings
      ds <- readr::read_csv(f$datapath )

      #Create Row : note nested dataset in tibble
      row <- tibble::tibble(
        "srnum" = nrow(master_values$master_df) + 1,
        "names" = input$name_id,
        "filenames" = f$name,
        "dataset" = nest(ds)
      )

      #Update the DataFrame with new row

      master_values$master_df <- rbind(master_values$master_df, row)
      #master_df <- values$df_data
      cli::cli_alert_info(" masterdf row {nrow(master_values$master_df )}")
      master_data <- master_values$master_df
      #Updata UI
      updateTextInput(session = session, inputId = "name_id", value = "")
      shinyjs::disable("add_btn")
      shinyjs::reset("MyFiles")
    })

    # Render Reactable table
    output$table <- reactable::renderReactable({
      dataset_tbl(input, output, session, master_values$master_df)
    })

    # Remove button selection logic
    observe({
      print(selected())
      if(is.numeric(selected())){
        shinyjs::enable("remove_btn")
        shinyjs::enable("preview_btn")
      }else{
        shinyjs::disable("remove_btn")
        shinyjs::disable("preview_btn")
      }
    })

    onclick("remove_btn", {
      index <- selected()
      master_values$master_df <- master_values$master_df[-c(index),]
      cli::cli_alert_info(" remove clicked new rows = {nrow(master_values$master_df )}")
      if(nrow(master_values$master_df > 0))
          master_values$master_df$srnum <- seq(1:nrow(master_values$master_df))

      output$preview_table <- NULL

    #  master_df <- values$df_data
    })

    onclick("preview_btn", {
      index <- selected()
    #  browser()
      ds <- tidyr::unnest(master_values$master_df[index,]$dataset)
      cli::cli_alert_info(" ds for index = {index} with rows = {nrow(ds)}")
      #print(head(ds))
      output$preview_table <- reactable::renderReactable({
              reactable::reactable(head(ds))
       })
    })


    return(
      reactive(master_values$master_data)
    )
})
}


# Function create the reactable table that shows the datasets

dataset_tbl <- function(input, output, session, tbl_df) {
  reactable::reactable(tbl_df,
            selection = "single",
            onClick = "select",
            defaultColDef = colDef(
              align = "center",
              minWidth = 70,
              headerStyle = list(background = "#f7f7f8")
            ),
            columns = list(
              srnum = colDef(name = "Num"),
              names = colDef(name = "Dataset Names"),
              filenames = colDef(name = "Source Filename"),
              dataset = colDef(show = FALSE)
            )
  )
}


## To be copied in the UI
# mod_data_upload_ui("data_upload_ui_1")

## To be copied in the server
# mod_data_upload_server("data_upload_ui_1")


#library(shiny)
#library(reactable)
#library(tidyr)
#library(shinyjs)
#library(cli)
#library(stringr)
#source("spring_util.R")


#ui <- fluidPage(
#  mod_data_upload_ui("data_upload_ui_1")
#)
#server <- function(input, output, session) {
#  mod_data_upload_server("data_upload_ui_1")
#}
#shinyApp(ui, server)


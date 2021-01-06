# load packages
library(dplyr)
library(ggplot2)
library(scales)
library(ggrepel)
library(AmesHousing)
library(shiny)
library(DT)
library(here)
library(tidyverse)
library(shinyjs)
library(reactable)
library(cli)

charts_df_file1 <- here("raw-datasets/CHART5_IN.csv")
charts_df_file2 <- here("raw-datasets/CHART4_NM.csv")

charts_df_1 <- read_csv(charts_df_file1)
charts_df_2 <- read_csv(charts_df_file2)


ds <- list(charts_df_1 , charts_df_2)

files <- list(charts_df_file1 , charts_df_file2)
ds_names <- list("a_test" , "b_test")

master <- tibble( filenames = files ,  dataset_names = ds_names , datasets = ds)

rvalues <- reactiveValues(master = master)

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
                         # srnum = colDef(name = "Num"),
                         dataset_names = colDef(name = "Dataset Names"),
                         filenames = colDef(name = "Source Filename"),
                         datasets = colDef(show = FALSE)
                         # origin_colnames = colDef(show = FALSE),
                         # snake_colnames = colDef(show = FALSE)
                       )
  )
}


fileupload_ui <- function(id){
  ns <- NS(id)
  tagList(
    wellPanel(
      fileInput(
        inputId = ns("MyFiles"),
        label = "Upload files"
      ),
      shinyjs::useShinyjs(),
      textInput(ns("name_id"), label = "Enter Dataset Name"),
      shinyjs::disabled(
        actionButton(ns("add_btn"), label = "Add")
      )
    )
  )
}

filupload_server <- function(id ){
  moduleServer(id, function(input, output, session ){
    ns <- session$ns
    fileInfo <- reactive(input$MyFiles)
    mdf <- reactive({rvalues$master})

    #  cli_alert_info("Master in rows = {nrow(mdf())}")

    observeEvent(input$MyFiles, {
      f <- fileInfo()
      cli::cli_alert_info("  file name {f$name}  ")

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

    # Call Onclick of add_btn
    onclick("add_btn", {
      f <- fileInfo()

      ds <- readr::read_csv(f$datapath)

      #Create Row : note nested dataset in tibble

      #ori_cols <- colnames(ds)
      #snake_cols <- snakecase::to_any_case(ori_cols)
      row <- tibble::tibble(
        #   "srnum" = nrow(master_values$master_df) + 1,
        "dataset_names" = input$name_id,
        "filenames" = f$name,
        "datasets" = nest(ds , data = everything())
        #"origin_colnames" = list(ori_cols) ,
        #"snake_colnames" = list(snake_cols)
      )
      cli_alert_info(" New dataset created = {nrow(ds)} " )
      #Updata UI
      updateTextInput(session = session, inputId = "name_id", value = "")
      shinyjs::disable("add_btn")
      shinyjs::reset("MyFiles")
      new_df <- rbind(mdf() , row)
      cli_alert_info("New DF rows {nrow(new_df)}")
      rvalues$master <- reactive(new_df)
      cli_alert_info(" Master dataset rows {nrow(rvalues$master())} names = {rvalues$master()$dataset_names} " )
      #    master()
    })

  })
}


table_preview_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::DTOutput(ns("preview_table"))
  )
}

table_preview_server <- function(id , rvalues){
  #   stopifnot(is.reactive(row_num))
  moduleServer(id, function(input, output, session ){
    ns <- session$ns
    row_select <- reactive(rvalues$row_select())
    observeEvent(row_select(),{
      cli_alert_info("in observe event row {row_select()}")
      ds <- as.data.frame(head(master[row_select(),]$datasets))
      output$preview_table <-renderDT(head(ds))
    })
  })
}

dataset_view_mod_ui <- function(id){
  ns <- NS(id)
  tagList(
    reactable::reactableOutput(ns("table"))
  )
}

dataset_view_mod_server <- function(id , rvalues){
  #stopifnot(is.reactive(rvalues))

  moduleServer(id, function(input, output, session ){
    ns <- session$ns
    selected <- reactive(reactable::getReactableState("table", "selected"))

    masterdf <- reactive(rvalues$master)
    output$table <- renderReactable( dataset_tbl(input, output, session, masterdf()))
    observeEvent(selected() , {
      print(selected())
    })
    return(reactive(selected()))
  })


}


# user interface
ui <- fluidPage(
  titlePanel("Data Uploader"),
  fileupload_ui("upload_ui"),
  dataset_view_mod_ui("dataset_view_ui"),
  table_preview_ui("table_preview")

)

# server logic
server <- function(input, output, session) {

  filupload_server("upload_ui" )
  #selected  <- dataset_view_mod_server(id = "dataset_view_ui" , rvalues = values)
  #table_preview_server("table_preview" , rvalues = values)

  #observeEvent(x = values$row_select , {
  #    print(selected())
  #})

}



# Run the application
shinyApp(ui = ui, server = server)

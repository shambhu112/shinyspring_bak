library(shiny)
library(reactable)
library(tidyr)
library(shinyjs)
library(cli)



ui <- fluidPage(
  titlePanel("Dataset Uploads"),
  fluidRow(
    column(
      4,
      wellPanel(
        fileInput(
          inputId = "MyFiles",
          label = "Upload files"
        ),
        shinyjs::useShinyjs(),
        textInput("name_id", label = "Enter Dataset Name"),
        shinyjs::disabled(
          actionButton("add_btn", label = "Add"),
          actionButton("remove_btn", label = "Remove")
        )
      )
    ),
    column(
      8,
      mainPanel(
        reactableOutput("table"),
        wellPanel(
          textOutput(outputId = "system_messages")
        )

      )
    )
  )
)

server <- function(input, output, session) {
  values <- reactiveValues(
    df_data = tibble::tibble(
      "srnum" = numeric(),
      "names" = character(),
      "filenames" = character(),
      "dataset" = tibble()
    )
  )

  fileInfo <- reactive(input$MyFiles)

  observeEvent(input$MyFiles, {
    print(" in observer event")
    cli::cli_alert_info("in file inputs observer") #print("in observer Event")

    f <- fileInfo()
   # cli_alert_info("  name {f$name}  ")

    #Creating the default name of dataset keeping the extention out
    a <- unlist(str_split(f$name, "\\."))
    l <- length(a) - 1
    nm <- ifelse(l > 0, a[1:l], a)
    nm <- snakecase::to_any_case(nm)
    # Name the Dataset with files name without the extention
    # And enable the add button
    updateTextInput(
      session = session, inputId = "name_id",
      value = nm
    )
    enable("add_btn")
  })

  #reactable selection tracker
  selected <- reactive(getReactableState("table", "selected"))

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
    row <- tibble(
      "srnum" = nrow(values$df_data) + 1,
      "names" = input$name_id,
      "filenames" = f$name,
      "dataset" = nest(ds)
    )

    #Update the DataFrame with new row
    temp <- rbind(values$df_data, row)
    values$df_data <- temp

    #Updata UI
    updateTextInput(session = session, inputId = "name_id", value = "")
    shinyjs::disable("add_btn")
    shinyjs::reset("MyFiles")
  })

  # Render Reactable table
   output$table <- renderReactable({
    dataset_tbl(input, output, session, values$df_data )
   })

   # Remove button selection logic
   observe({
     print(selected())
     if(is.numeric(selected())){
       shinyjs::enable("remove_btn")
     }else{
       shinyjs::disable("remove_btn")
     }
   })


   onclick("remove_btn", {
     index <- selected()
     temp <- values$df_data[-c(index),]
     values$df_data <- temp
     values$df_data$srnum <- seq(1:nrow(temp))

   })
}


# Function create the reactable table that shows the datasets
dataset_tbl <- function(input, output, session, tbl_df) {
  reactable(tbl_df,
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

shinyApp(ui = ui, server = server)

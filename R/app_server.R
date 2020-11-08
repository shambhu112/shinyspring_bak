#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic

  #print(get_golem_options("time"))
  #r <- reactiveValues()

  mod_esquisse_wrapper_server("esquisse_wrapper_ui_1")
  mod_data_upload_server("data_upload_ui_1")

}

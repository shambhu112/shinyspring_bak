## Basic robservable Shiny app

library(shiny)

library(reactable)
library(tidyr)
library(dplyr)
library(shinyjs)
library(cli)
library(stringr)
library(tibble)
library(esquisse)
source("../R/spring_util.R")

source("../R/mod_esquisse_wrapper.R")
source("../R/mod_data_upload.R")
source("../R/spring_util.R")

charts_df <- read.csv("../raw-datasets/CHART5_IN.csv")
charts_df_2 <- read.csv("../raw-datasets/CHART4_NM.csv")

pre_load_df <- tibble::tibble(
  "srnum" = c(1, 2) ,
  "names" = c("a_test" , "b_test"),
  "filenames" =c("../raw-datasets/CHARTS_IN.csv" , "../raw-datasets/CHART4_NM.csv"),
  "dataset" = c(nest(charts_df) ,nest(charts_df_2))
)


master_data <- pre_load_df

ui <- fluidPage(
  mod_esquisse_wrapper_ui("esquisse_wrapper_ui_1")
  #mod_data_upload_ui("data_upload_ui_1")

)


server <- function(input, output) {

  #cli::cli_alert_success("Master Values {nrow(master_values$master_df)}")
  print(master_data$names)
  mod_esquisse_wrapper_server("esquisse_wrapper_ui_1" , master_data)
  #mod_data_upload_server("data_upload_ui_1")
}

shinyApp(ui = ui, server = server)

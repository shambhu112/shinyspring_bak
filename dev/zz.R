library(dplyr)
library(tidyverse)
library(readr)
library(here)
library(shinyspring)


charts_df_file1 <- here("raw-datasets/CHART5_IN.csv")
charts_df_file2 <- here("raw-datasets/CHART4_NM.csv")

charts_df_1 <- read_csv(charts_df_file1)
#colnames(charts_df_1) <- make.names(snakecase::to_any_case(colnames(charts_df_1)))

charts_df_2 <- read_csv(charts_df_file2)
#colnames(charts_df_2) <- make.names(snakecase::to_any_case(colnames(charts_df_2)))



files <- list(charts_df_file1 , charts_df_file2)
ds_names <- list("a_test" , "b_test")
srnums <- seq(1:length(files))

row1 <- create_row(srnums[1] , files[1] , ds_names[1] , charts_df_1 )


row2 <- create_row(srnums[2] , files[2] , ds_names[2] , charts_df_2 )

mdf <- rbind(tibble(row1), tibble(row2))

master <- app_master$new()

master$preload_master(mdf)

cli::cli_alert_success(" master object created")

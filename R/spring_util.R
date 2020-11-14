

#' @import tibble
master_data <- tibble::tibble(
  "srnum" = numeric(),
  "names" = character(),
  "filenames" = character(),
  "dataset" = tibble()
)

master_df_preload <- function(df){
  master_data <- rbind(master_data ,df)
  cli::cli_alert_info(" Pre Load with  {nrow(master_data)}")
}

#' @import tibble
master_df_addrow <- function(srnum , name , filename ,the_dataset) {
  tb <- tibble::tibble(
    "srnum" = srnum,
    "names" = name,
    "filenames" = filename,
    "dataset" = nest(the_dataset)
  )

  master_data <- rbind(master_data , tb)
  cli::cli_alert_info(" Master DF Add Rows update with rows {nrow(master_data)}")
}


#' CLI option to create a new Shiny Spring Project
#'
#' @param dashboard_template (optional) defaults to "bs4_dash". Options are shiny_dashboard_plus , argon_dash
#' @param app_type (optional) default to "basic". Options are
#' @param config_file (optional)
#' @return TRUE
#' @export

create_new_project <- function(dashboard_template = "bs4_dash" , app_type = "minimal" , config_file = "config.yml"){
  dots <- list(dashboard_template = dashboard_template , app_type = app_type , config_file = config_file)
  create_files(dots)
}

# to be used in RStudio "new project" GUI
new_project <- function(path, ...) {
  # ensure path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  dots <- list(...)
  create_files(dots)

}
#' Create the files based on iputs params
#'
#' @param dots the inputs params as defined in newproject.dcf
#' @importFrom whisker whisker.render
#' @export

create_files <- function(dots){
  yml_template_file <- create_mst_filename(dots , type = "yml" )
  yml_template <- readr::read_file(yml_template_file)

  text <- whisker::whisker.render(yml_template, dots)
  writeLines(text, con = file.path(dots$config_file))
  cli::cli_alert_success("Created config at file : {dots$config_file} ")

  ##cli::cli_verbatim(text)
  user_file_template <- readr::read_file(system.file("rstudio/templates/project/user_script.mst"  , package = "shinyspring"))
  user_script <- whisker::whisker.render(user_file_template , dots)

  writeLines(user_script, con = file.path("user_script.R"))
  cli::cli_alert_success("Created start script : user_script.R ")
  cli::cli_h2("Open user_script.R to start your shiny spring journey")
}

create_mst_filename <- function(dots , type ){
  x <- dots$dashboard_template
  t_name <- dplyr::case_when(
    x == "bs4_dash" ~ "bs4_" ,
    TRUE ~ "plc_"
  )

  a_type <- dplyr::case_when(
    x == "minimal" ~ "minimal" ,
    x == "full" ~ "full" ,
    x == "test_harness" ~ "harness",
    TRUE ~ "minimal"
  )

  dir <- dplyr::case_when(
    x == "bs4_dash" ~ "bs4" ,
    TRUE ~ "plc"
  )

  if(type == "yml"){
    str <- paste(t_name , a_type , "_yml" , ".mst" , sep = "")
  }else{
    str <- paste(t_name , a_type ,  ".mst" , sep = "")
  }

  tem <- paste(dir , "/" , str , sep = "")
  ret <- system.file(tem , package = "shinyspring")
  ret
}

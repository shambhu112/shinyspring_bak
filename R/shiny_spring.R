
#' Create a baseline Module for your shinyapp
#'
#' @param mod_name The Modules Name
#' @export
create_module <- function(mod_name){
  mod_template <- readr::read_file(system.file("rstudio/templates/project/new_module.mst"  , package = "shinyspring"))
  dots <- list(mod_name = mod_name )
  module_text <- whisker::whisker.render(mod_template , dots)
  mod_file <- paste0(mod_name ,  ".R")
  writeLines(module_text, con = file.path(mod_file))
  cli::cli_alert_success("Created module  : {mod_file} ")
}


#' CLI option to create a new Shiny Spring Project based on predefined templates in shinyspring
#'
#' @param dashboard_template (optional) defaults to "bs4_dash". Options are shiny_dashboard_plus , argon_dash
#' @param app_type (optional) default to "basic". Options are
#' @param config_file (optional)
#' @export

create_new_project <- function(dashboard_template = "bs4_dash" , app_type = "minimal" , config_file = "config.yml"){
  dots <- list(dashboard_template = dashboard_template , app_type = app_type , config_file = config_file)
  yml_file <- create_file_txt(dots , type = "yml")
  user_script <- create_file_txt(dots , type = "template")

  writeLines(yml_file, con = file.path(dots$config_file))
  cli::cli_alert_success("Created config at file : {dots$config_file} ")

  writeLines(user_script, con = file.path("user_script.R"))
  cli::cli_alert_success("Created start script : user_script.R ")
  cli::cli_h2("Open user_script.R to start your shiny spring journey")

}


#' Creates the app.R using the templates defined in inst/cheetah/*
#'
#' Based on the configuration defined in config.yml the app.R code is created
#' @param params the params for creating app.R
#' @param target_file (optional) default is app.R , you can change this
#' @param template_file (optiona) this is an override.Function expect that you params$template_file is set in params when template_file is NULL
#' @export

create_shinyapp <- function(params , target_file = "app.R" ,template_file = NULL){
  if(is.null(template_file))
    template_file <- params$template_file

  template <- readr::read_file(file= template_file)

  text <- whisker::whisker.render(template, params)
  app_r <- paste(params$code_gen_location , target_file , sep = "/")


  conn <- file(app_r)
  writeLines(text, conn)
  close(conn)
}


# to be used in RStudio "new project" GUI
new_project <- function(path, ...) {
  # ensure path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  dots <- list(...)

  yml_file <- create_file_txt(dots , type = "yml")
  user_script <- create_file_txt(dots , type = "template")

  writeLines(yml_file, con = file.path(path , dots$config_file))
  cli::cli_alert_success("Created config at file : {dots$config_file} ")

  writeLines(user_script, con = file.path(path , "user_script.R"))
  cli::cli_alert_success("Created start script : user_script.R ")
  cli::cli_h2("Open user_script.R to start your shiny spring journey")

}


create_file_txt <- function(dots , type){
  if(type == "yml"){
    yml_template_file <- create_mst_filename(dots , type = "yml" )
    yml_template <- readr::read_file(yml_template_file)

    text <- whisker::whisker.render(yml_template, dots)
    ret <- text
  }else{
    user_file_template <- readr::read_file(system.file("rstudio/templates/project/user_script.mst"  , package = "shinyspring"))
    user_script <- whisker::whisker.render(user_file_template , dots)
    ret <- user_script
  }
  ret
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

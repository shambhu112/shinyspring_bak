.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)
  reticulate::py_config()
}

#' get parameters from the config.yml file
#'
#' Loads the config.yml file using the config package
#' @param env (optional) defauls to "default". Switch this to production , dev , test as need be
#' @param path (optional) default to config.yml in the root project directory
#' @return parameters
#' @export
get_params <- function(env = "default" , path = "config.yml"){
  params <- config::get(config = env , file = path , use_parent = TRUE)
}

#' Creates the app.R using the templates defined in inst/cheetah/*
#'
#' Based on the configuration defined in config.yml the app.R code is created
#' @param env (optional) defauls to "default". Switch this to production , dev , test as need be
#' @export

create_app_r <- function(env = "default"){
  params <- get_params(env)
  cheetah <- reticulate::import(module = "Cheetah.Template")
  template <- readr::read_file(file= "inst/cheetah/shinydashboardplus_appr.txt")
  the_file <- cheetah$Template(template , searchList = reticulate::dict(params))

  txt <- as.character(the_file)
  app_r <- paste(params$code_gen_location , "app.R")
  conn <- file(app_r)
  writeLines(txt, conn)
  close(conn)
}


#' Creates the dash_components.R using the templates defined in inst/cheetah/*
#'
#' Based on the configuration defined in config.yml the dash_components.R code is created
#' @param env (optional) defauls to "default". Switch this to production , dev , test as need be
#' @export

create_dash_components <- function(env = "default"){
  params <- get_params(env)
  cheetah <- reticulate::import(module = "Cheetah.Template")
  template <- readr::read_file(file= "inst/cheetah/shinydashboardplus_dash.txt")
  the_file <- cheetah$Template(template , searchList = reticulate::dict(params))

  txt <- as.character(the_file)
  r_file <- paste(params$code_gen_location , "dash_components.R")
  conn <- file(r_file)
  writeLines(txt, conn)
  close(conn)
}


#' Load the config.yml template available in inst/cheetah
#'
#' Reads to file inst/cheetah/config.yml returns the file
#' @return the txt file for config.yml
#' @export
load_config_template <- function(){
  yml <- readr::read_file(system.file("cheetah" , "config.yml" , package = "shinyspring"))
  #yml <- readr::read_file(file = "inst/cheetah/config.yml")
  return(yml)
}

apply_project_params_to_template <- function(dots , template){
  t <- template
  for(i in 1:length(dots)){
    key <- names(dots)[[i]]
    val <- dots[[i]]
    t <- stringr::str_replace_all(t , paste("$" , key , sep = "") , val)
  }
 # cli::cli_alert_success("New doc is {t}")
  t
}




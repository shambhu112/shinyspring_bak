debug <- FALSE

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

create_app_r <- function(params , template_file ,  target_file = "app.R"){
  template <- readr::read_file(file= template_file)

  text <- whisker::whisker.render(template, params)
  if(debug) cli::cli_verbatim(text)

  app_r <- paste(params$code_gen_location , target_file , sep = "/") # TODO - provide option for app.R
  conn <- file(here::here(app_r))
  writeLines(text, conn)
  close(conn)
}


#' Load the config.yml template available in inst/cheetah
#'
#' Reads to file inst/cheetah/config.yml returns the file
#' @return the txt file for config.yml
#' @export
load_config_template <- function(template_engine = "mustache" , config_file = "config.yml"){
  yml <- readr::read_file(system.file(template_engine , config_file , package = "shinyspring"))
  return(yml)
}





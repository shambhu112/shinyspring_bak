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
#' @param params the params for creating app.R
#' @param target_file (optional) default is app.R , you can change this
#' @param template_file (optiona) this is an override.Function expect that you params$template_file is set in params when template_file is NULL
#' @export

create_app_r <- function(params , target_file = "app.R" ,template_file = NULL){
  if(is.null(template_file))
        template_file <- params$template_file

  template <- readr::read_file(file= template_file)

  text <- whisker::whisker.render(template, params)
  app_r <- paste(params$code_gen_location , target_file , sep = "/")


  conn <- file(app_r)
  writeLines(text, conn)
  close(conn)
}



load_config_template <- function(template_engine = "mustache" , config_file = "config.yml"){
  yml <- readr::read_file(system.file(template_engine , config_file , package = "shinyspring"))
  return(yml)
}





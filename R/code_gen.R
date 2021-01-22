
.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)
  reticulate::py_config()
}


#

get_params <- function(env = "default" , path = "config.yml"){
  params <- config::get(config = env , file = path , use_parent = TRUE)
}

create_app_r <- function(env = "default"){
  params <- get_params(env)
  cheetah <- reticulate::import(module = "Cheetah.Template")
  template <- readr::read_file(file= "inst/cheetah/shinydashboardplus_app.txt")
  the_file <- cheetah$Template(template , searchList = dict(params))

  txt <- as.character(the_file)
  app_r <- paste(params$code_gen_location , "app.R")
  conn <- file(app_r)
  writeLines(txt, conn)
  close(conn)
}

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
    t <- stringr::str_replace_all(t , paste0("$" , key) , val)
  }
  cli::cli_alert_success("New doc is {t}")
  t
}


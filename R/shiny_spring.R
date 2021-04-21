#' CLI option to create a new Shiny Spring Project
#'
#' @param dashboard_template (optional) defaults to "bs4_dash". Options are shiny_dashboard_plus , argon_dash
#' @param app_type (optional) default to "basic". Options are
#' @param config_file (optional)
#' @return TRUE
#' @export

create_new_project <- function(dashboard_template = "bs4_dash" , app_type = "basic" , config_file = "config.yml"){
  dots <- list(dashboard_template = dashboard_template , app_type = app_type , config_file = config_file)
  yml_template_file <- create_mst_filename(dots)
  yml_template <- readr::read_file(system.file("rstudio/templates/project/" , yml_template_file , package = "shinyspring"))

  text <- whisker.render(yml_template, dots)
  ##cli::cli_verbatim(text)
  user_file_template <- readr::read_file(system.file("rstudio/templates/project/user_script.mst"  , package = "shinyspring"))
  user_script <- whisker.render(user_file_template , dots)

  writeLines(text, con = file.path(config_file))
  writeLines(user_script, con = file.path("user_script.R"))
  TRUE
}

# to be used in RStudio "new project" GUI
new_project <- function(path, ...) {
  # ensure path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  dots <- list(...)
  text <- lapply(seq_along(dots), function(i) {
    key <- names(dots)[[i]]
    val <- dots[[i]]
    paste0(key, ": ", val)
  })

  cli::cli_alert_success(dots)
  print(text)

#  yml_template <- readr::read_file(system.file("rstudio/templates/project/" , "bs4_basic.mst" , package = "shinyspring"))

 # text <- whisker.render(yml_template, dots)

  # write to index file
#  writeLines(contents, con = file.path(path, "config.yml"))
}


create_mst_filename <- function(dots){
  x <- dots$dashboard_template
  t_name <- dplyr::case_when(
    x == "bs4_dash" ~ "bs4_" ,
    TRUE ~ "tbi_"
  )

  a_type <- dplyr::case_when(
    x == "basic" ~ "basic" ,
    TRUE ~ "basic"
  )

  str <- paste(t_name , a_type , ".mst" , sep = "")
  str
}

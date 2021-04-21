

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

  print(text)

#  yml_template <- readr::read_file(system.file("rstudio/templates/project/" , "bs4_basic.mst" , package = "shinyspring"))

 # text <- whisker.render(yml_template, dots)

  # write to index file
#  writeLines(contents, con = file.path(path, "config.yml"))
}

apply_project_params_to_template <- function(dots , template){

  text <- whisker.render(template, dots)
  if(debug) cli::cli_verbatim(text)
}

create_mst_filename <- function(dots){
  x <- dots$dashboard_template
  t_name <- case_when(
    x == "bs4_dash" ~ "bs4_" ,
    TRUE ~ "tbi_"
  )
}

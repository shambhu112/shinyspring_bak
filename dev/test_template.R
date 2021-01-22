library(reticulate)
library(config)
library(readr)


reticulate::py_config()


params <- config::get(file = "inst/cheetah/config.yml" , use_parent = TRUE)

os <- reticulate::import("os")
cli::cli_alert_info("Current working directory {os$getcwd()}")

cheetah <- reticulate::import(module = "Cheetah.Template")

template <- readr::read_file(file= "inst/cheetah/shinydashboardplus_app.txt")

cheetah$Template(template , searchList = dict(params))



name_value_pair <- function(name , value){
   value <- stringr::str_replace(string = value , pattern = "\"" , replacement = "\'")
   paste("'" , name , "': '" , value , "'" , sep = "")
}

keys <- names(params)

pairs <-  sapply(keys, function(x){
  name_value_pair(name =  x , value = params[x[1]])
})


convert_params_to_namespace <- function(params){
  keys <- names(params)
  pairs <-  sapply(keys, function(x){
    name_value_pair(name =  x , value = params[x[1]])
  })
  paste( pairs  ,  collapse = ",")
}


namespace <- paste("{" , convert_params_to_namespace(params) , "}" , sep = "")


dict(params)

  main <- import_main()

  nm <- main$get_namespace(namespace)


  main$cheetah_template(template , zz)


cheetah_template

cheetah_template(template , zz)





zz <- py_run_string("[{'dashboard_style': 'shiny_dashboard_plus','app_name': 'my_ai_app','title': 'my_ai_app','footer_left': 'Built on shinyspring','footer_right': 'my_ai_app','sidebar_expand_onhover': 'FALSE'}]")



class(nm)

names(params)
#nameSpace = {'title': 'Hello World Example', 'contents': 'Hello World!'}

#' R6 class for storing information across the app.
#'
#' app_master
#' @docType class
#' @format A \code{\link{R6Class}} generator object
#' @keywords data
#'
#' @export app_master
#'
#'
#' @examples
#' \dontrun{
#' app_m <- app_master$new()
#' }
app_master <- R6::R6Class(
  "app_master",
  public = list(
    ### Public variables
    # date for pull
    params = NA,
    rvals = NULL,


    ### METHOD initialize
    ### Standard R6 Initialize function

    initialize = function() {
      cli::cli_alert_info("Object app_master initialized")
      options("scipen" = 100, "digits" = 4)
    },
    preload_master = function(master_data){
      self$rvals <- reactiveValues(mdata = master_data)
    },

    row = function(){
      self$rvals$mdata
    },
    dataset_names = function(){
      self$rvals$mdata$dataset_names
    },
    data_by_name = function(dataset_name){
      index <- which(self$rvals$mdata$dataset_names == dataset_name)
      stopifnot(length(index) == 1)
      self$rvals$mdata$datasets$data[[index]]
    },
    data_by_index = function(index){
      self$rvals$mdata$datasets$data[[index]]
    }

  )
)

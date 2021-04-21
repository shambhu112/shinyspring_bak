library(R6)

ymlon <- R6::R6Class("ymlon" , public = list(

  initialize = function(params){
    private$params <- params

  },

  objects = function(){

  },

  print = function(...){
  cat("yml inputs params \n")
    cat("Params : " , sapply(names(params) , function(x){
        paste(x , " : " , params[x]  , "\n" , sep = "" )
    }))
  }
),
  private = list(
    params = NULL
  )
)


name_value <- function(v){
  str <- paste(names(v[1]) , v[[1]] , sep = " : " )
  str
}

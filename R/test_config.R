#library(testthat)

#' Run Config File Check
#'
#' @param params the master params from config
#' @import testthat
run_checks <- function(params){
  testthat::test_that("minimum_checks" , {minimum_checks(params)})
  testthat::test_that("menu_mod_check" , {menu_mod_check(params)})

}

#' Minimum chekcsc
#'
#' @param params the master params from config
#' @import testthat
minimum_checks <- function(params){
  expect_equal("bs4_dash" ,   params$dashboard_template)
  expect_match(params$template_file , "bs4/bs4_standard.mst")
  expect_true(!is.null(params$code_gen_location))
  expect_true(!is.null(params$dummy_test.mod_name))
  expect_true(!is.null(params$dummy_test.weird_param))

  expect_true(!is.null(params$sweetmod_config))
  expect_true(!is.null(params$preload_dataset))
  expect_true(!is.null(params$source_file_onstartup))

  # Test ds
  index <- which(stringr::str_detect(names(params) , pattern = "^ds."))
  expect_gt(length(index) , 1)

  types <- which(stringr::str_detect(names(params)[index] , pattern = ".type$"))
  connections <-  which(stringr::str_detect(names(params)[index] , pattern = ".connection$"))

  expect_gt(length(types) , 0)
  expect_gt(length(connections) , 0)
  expect_equal(length(types) , length(connections))




}


#' Check menus
#'
#' @param params the master params from config
#' @import testthat
menu_mod_check <- function(params){
  menu_count <- length(params$menus)
  menu_mod_names <-sapply(1:menu_count, function(x){
    expect_true(!is.null(params$menus[[x]]$title))
    mod_name <- params$menus[[x]]$name
    mod_name
  })

  registry <- mod_registry$new(params)
  # check if all menu_names have a corresponding mod declared
  res <- sapply(menu_mod_names, function(x){
     expect_true(x %in% registry$mod_names)
  })
  expect_true(sum(res) == length(menu_mod_names))


}

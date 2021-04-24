library(shinyspring)
test_that("template bs4_minimal.mst", {
  dots <- list(dashboard_template = "bs4_dash" , app_type = "minimal" , config_file = "config.yml")

  yml_mst <- create_mst_filename(dots , type = "yml")
  t <-stringr::str_detect(yml_mst , "bs4/bs4_minimal_yml.mst")
  expect_true(t)


  template_mst <- create_mst_filename(dots , type = "template")
  t <-stringr::str_detect(template_mst , "bs4/bs4_minimal.mst")
  expect_true(t)


})


#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinydashboard dashboardBody tabItems
#' @importFrom shinydashboardPlus dashboardPage
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
          shinydashboardPlus::dashboardPage(
          options = list(sidebarExpandOnHover = FALSE),
          header = header_create(),
          sidebar = menu_side_tabs(),
          body = shinydashboard::dashboardBody(
              setShadow(class = "dropdown-menu"),
              setShadow(class = "box"),
              # All tabs
              body_tab_items()
          ),
          controlbar = controlbar_create(),
          title = "Build Fast Shiny Apps "
        )
      )
    )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'shinyspring'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}


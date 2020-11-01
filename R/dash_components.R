

#' The application User-Interface
#'
#' @import shiny
#' @importFrom  shinydashboardPlus dashboardControlbar controlbarMenu controlbarItem
#' @noRd

controlbar_create <- function(){
  shinydashboardPlus::dashboardControlbar(
    skin = "dark",
    shinydashboardPlus::controlbarMenu(
      controlbarItem(
        title = "Theme",
        icon = icon("desktop"),
        active = TRUE,
        sliderInput(
          inputId = "inputsidebar1",
          label = "Number of observations:",
          min = 0,
          max = 1000,
          value = 500
        )
      ),
      controlbarItem(
        icon = icon("paint-brush"),
        title = "Data",
        numericInput(
          inputId = "inputsidebar2",
          label = "Observations:",
          value = 10,
          min = 1,
          max = 100
        )
      )
    )
  )
}


#' The application User-Interface
#'
#' @import shiny
#' @importFrom  shinydashboardPlus dashboardHeader
#' @import shinyWidgets
#' @noRd

header_create <- function(){
  shinydashboardPlus:: dashboardHeader(
    fixed = TRUE,
    title = tagList(
      span(class = "logo", "SpringShiny"),
      img(src = "http://hexb.in/hexagons/mongodb.png"))
)
}

#' The application User-Interface
#'
#' @import shiny
#' @importFrom shinydashboard dashboardSidebar
#' @importFrom shinydashboard menuItem menuSubItem
#' @noRd
menu_side_tabs <-  function(){
  shinydashboardPlus::dashboardSidebar(
    shinydashboard::sidebarMenu(
      shinydashboard::menuItem("Tutorial", tabName = "tutorial", icon = icon("leanpub")),
      shinydashboard::menuItem("Data", tabName = "data", icon = icon("database") ,
               shinydashboard::menuSubItem("Upload" , tabName = "upload_data" , icon = icon("upload")),
               shinydashboard::menuSubItem("Visualize" , tabName = "vis_data" , icon = icon("chart-bar")),
               shinydashboard::menuSubItem("EDA" , tabName = "eda_data" , icon = icon("project-diagram"))
               ),
      shinydashboard::menuItem("Macro Analysis", tabName = "macro_analysis", icon = icon("archway")),
      shinydashboard::menuItem("Micro Analysis", tabName = "micro_analysis", icon = icon("atom")),
      shinydashboard::menuItem("Credits", tabName = "credits", icon = icon("heart"))
    )
  )
}


#' The application User-Interface
#'
#' @import shiny
#' @noRd
menu_body_tabs <- function(){
  tabItems(
    tabItem(
      "tutorial",

      # infoBoxes
      fluidRow(
        hr()
      )
    )
  )
}

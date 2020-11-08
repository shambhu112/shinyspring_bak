

#' The application User-Interface
#'
#' @import shiny
#' @importFrom  shinydashboardPlus dashboardControlbar controlbarMenu controlbarItem skinSelector
#' @noRd

controlbar_create <- function(){
  shinydashboardPlus::dashboardControlbar(
  #  skin = "dark",
    skin = "light",
    width = 180,
    shinydashboardPlus::controlbarMenu(
      id = "control_bar_menu",
      controlbarItem(
        title = "Theme",
        icon = icon("desktop"),
        active = TRUE,
        shinydashboardPlus::skinSelector()
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
    title = tagList(
      span(class = "logo-lg", "SpringShiny"),
      img(src = "https://image.flaticon.com/icons/svg/204/204074.svg")
      )
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
      id = "tabs-menu",
      shinydashboard::menuItem("Tutorial", tabName = "tutorial", icon = icon("leanpub")),
      shinydashboard::menuItem("Data", tabName = "data", icon = icon("database") ,
               shinydashboard::menuSubItem("Upload" , tabName = "upload_data" , icon = icon("upload")),
               shinydashboard::menuSubItem("Visualize" , tabName = "vis_data" , icon = icon("chart-bar")),
               shinydashboard::menuSubItem("EDA" , tabName = "eda_data" , icon = icon("project-diagram"))
               ),
      shinydashboard::menuItem("Macro Analysis", tabName = "macro_analysis", icon = icon("archway")),
      shinydashboard::menuItem("Micro Analysis", tabName = "micro_analysis", icon = icon("atom")),
      shinydashboard::menuItem("Credits", tabName = "credits_tab", icon = icon("heart"))
    )
  )
}


#' The application User-Interface
#'
#' @import shiny
#' @import shinydashboard
#' @noRd
body_tab_items <- function(){
  tabItems(
    tabItem("tutorial" ,tutorial_tab() ) ,
    tabItem("upload_data" , mod_data_upload_ui("data_upload_ui_1") ) ,
    tabItem("credits_tab", credits_tab()),
    tabItem("macro_analysis", "Macro Tab Content"),
    tabItem("micro_analysis", "Micro Tab Content"),
    tabItem("vis_data",  mod_esquisse_wrapper_ui("esquisse_wrapper_ui_1")),
    tabItem("data", "Data Tab Content")
  )
}

#' The application User-Interface
#'
#' @import shiny
#' @import shinydashboard
#' @noRd

tutorial_tab <- function(){
  tabItem("tutorial", "Tutorial Tab Content")
}



credits_tab <- function(){
  fluidRow(
    hr() ,
    h2("CreditsTab")
  )
}

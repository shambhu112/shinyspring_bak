#
# This is a Shiny web application created with shinysppring package. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://www.shinyspring.dev/
#

library(shiny)
library(shinydashboardPlus)
library(shinydashboard)

source("dash_components.R")

# Define UI for application
ui <-   shiny::fluidPage(
    shinydashboardPlus::dashboardPage(
        options = list(sidebarExpandOnHover = FALSE),
        header = header_create(),
        sidebar = menu_side_tabs(),
        body = shinydashboard::dashboardBody(
            # All tabs
            body_tab_items()
        ),
        controlbar = shinydashboardPlus::dashboardControlbar(),
        footer = shinydashboardPlus::dashboardFooter(right = "Shiny Spring" , left = "Build Fast Shiny Apps"),
        title = "Build Fast Shiny Apps "
    )
)
# Define server logic required to draw a histogram
server <- function(input, output) {


}

# Run the application
shinyApp(ui = ui, server = server)

# This Shiny App created with Shinyspring - http://www.shinyspring.dev
# template bs4Dash

library(shiny)
library(bs4Dash)
library(thematic)
library(waiter)
library(sweetmods)

thematic_shiny()

params <- config::get(file = "config.yml") # config.yml
controller <- sweetmods::app_master$new(params)


# Define UI for application that draws a histogram
ui <- bs4Dash::dashboardPage(
  #   preloader = list(
  #       waiter = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
  #       duration = 0
  #   ),

  dark = TRUE,
  help = FALSE,
  fullscreen = TRUE,
  scrollToTop = TRUE,
  header = dashboardHeader(
    title = dashboardBrand(
      title = "Base Shiny App", # Base Shiny App
      color = "primary",
      href = "http://www.shinyspring.dev", # http://www.shinyspring.dev
      image = "https://lh5.googleusercontent.com/1Al9EArT3_oSmP5pvnJpi57qIq3anpIjnrdh5MykFGZKsVqx8OmhGO1pBvaSsc6yHzGy_WQ0-nwL-P626NNr_d8=w16383", # https://lh5.googleusercontent.com/1Al9EArT3_oSmP5pvnJpi57qIq3anpIjnrdh5MykFGZKsVqx8OmhGO1pBvaSsc6yHzGy_WQ0-nwL-P626NNr_d8=w16383
      opacity = 0.8
    ),
    fixed = TRUE, # TRUE
    rightUi = tagList(
      dropdownMenu(
        badgeStatus = "info",
        type = "notifications",
        messageItem(
          inputId = "triggerAction1",
          message = "FDIC issues list of Bank Examined for CRA compliance",
          from = "FDIC",
          image = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Seal_of_the_United_States_Federal_Deposit_Insurance_Corporation.svg/1200px-Seal_of_the_United_States_Federal_Deposit_Insurance_Corporation.svg.png",
          time = "today",
          color = "lime"
        )
      ),
      userOutput("user")
    ),
    leftUi = tagList(
      # Close dropdownMenu
      tags$li(class = "dropdown",
              tags$h3("Base Shiny App") # Base Shiny App
      )
    ) # close left UI
  ),
  sidebar = dashboardSidebar(
    fixed = TRUE,
    skin = "light",
    status = "primary",
    id = "sidebar",
    customArea = fluidRow(
      actionButton(
        inputId = "myAppButton",
        label = NULL,
        icon = icon("users"),
        width = NULL,
        status = "primary",
        style = "margin: auto",
        dashboardBadge(textOutput("btnVal"), color = "danger")
      )
    ),
    sidebarUserPanel(
      image = "https://image.flaticon.com/icons/svg/1149/1149168.svg",
      name = "Welcome"
    ),
    sidebarMenu(
      id = "current_tab",
      flat = FALSE,
      compact = FALSE,
      childIndent = TRUE,
      sidebarHeader("Banks"),
      menuItem(
        "Branch Network",
        tabName = "institutions_tab",
        icon = icon("university")
      ),
      menuItem(
        "Branch Analysis",
        tabName = "branches_tab",
        icon = icon("piggy-bank")
      )

    )
  ), # Close of sidebar
  body = dashboardBody(
    tabItems(
      tabItem(tabName = "learning_tab", "Learning"),
      #         tabItem(tabName = "institutions_tab", branch_network_ui("b_network_ui" , control)),
      tabItem(tabName = "credits_tab", "Credits")

    )
  ) #close of body
)

# Define server logic required to draw a histogram
server <- function(input, output , session) {

}

# Run the application
shinyApp(ui = ui, server = server)

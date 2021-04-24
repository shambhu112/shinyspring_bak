## Start your Shiny Spring Journey here

## Step 1 : Make sure that your properties in config.yml are set as per your needs
file.edit('config.yml')

## Step 2 : Create app.R for your application
params <- config::get(file = "config.yml") # load params
shinyspring::create_app_r(params = params )

## Step 3 : Launch the App
shiny::runApp()


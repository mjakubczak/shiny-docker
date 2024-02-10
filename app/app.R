library(shiny)
library(httr) # only to demonstrate the system dependencies requirements in Dockerfile

logger::log_threshold(logger::TRACE)

source("functions.R")
db_cfg <- get_db_config(config::get())
message("Demonstration purposes only - DO NOT print such things into the console in reality!")
message("Configuration based on env variables:")
print(db_cfg)

# UI --------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    sidebarPanel(
      selectize_with_placeholder(
        inputId = "x_var",
        label = "X variable"
      ),
      selectize_with_placeholder(
        inputId = "y_var",
        label = "Y variable"
      ),
      selectize_with_placeholder(
        inputId = "color_var",
        label = "Color variable"
      )
    ),
    
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Server ----------------------------------------------------------------------
server <- function(input, output, session) {
  token <- session$token
  log_msg <- function(msg){
    # separate session messages in a single R process
    glue::glue("({token}) {msg}")
  }
  
  logger::log_info(log_msg("session started"))
  session$onSessionEnded(function(){
    logger::log_info(log_msg("session ended"))
  })
  
  Input_data <- reactive({
    iris
  })
  
  observe({
    df <- Input_data()
    req(is.data.frame(df))
    
    logger::log_debug(log_msg("plot param init"))
    
    num_vars <- get_col_names(df, is.numeric)
    fc_vars <- get_col_names(df, is.factor)
    
    if (length(num_vars) > 1){
      logger::log_trace(log_msg("num vars init: {toString(num_vars)}"))
      updateSelectInput(
        inputId = "x_var",
        choices = num_vars,
        selected = num_vars[1]
      )
      updateSelectInput(
        inputId = "y_var",
        choices = num_vars,
        selected = num_vars[2]
      )
    }
    
    if (length(fc_vars) > 0){
      logger::log_trace(log_msg("fc var init: {toString(fc_vars)}"))
      updateSelectInput(
        inputId = "color_var",
        choices = fc_vars,
        selected = fc_vars[1]
      )
    }
  })
  
  output$plot <- renderPlot({
    df <- Input_data()
    req(df)
    
    logger::log_debug(log_msg("plot render"))
    
    x_var <- input$x_var
    y_var <- input$y_var
    color_var <- input$color_var
    
    validate(
      need(x_var, "select X var"),
      need(y_var, "select Y var"),
      need(color_var, "select Color var")
    )
    
    logger::log_trace(log_msg("x_var: {x_var}; y_var: {y_var}; color_var: {color_var}"))
    
    generate_plot(
      df = df,
      x_var = x_var,
      y_var = y_var,
      color_var = color_var
    )
  })
}

shinyApp(ui, server)

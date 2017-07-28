library(shinydashboard)
library(dygraphs)

count_xts <- NULL
quality_xts <- NULL

# Data refresh function
renew_data <- function(){
  
  # Load data
  load("../data/dalit_data.RData")
  
  # Generate XTS objects
  dropped_count <- count_data[,2, drop=FALSE]
  names(dropped_count) <- "articles"
  count_xts <<- xts(dropped_count, count_data$date)
  
  
}

# Start off the data
current_date <- Sys.Date()
renew_data()

server <- function(input, output) {
  
  # Check for data being outdated and refresh it if so
  if(Sys.Date() != current_date){
    current_date <<- Sys.Date()
    renew_data()
  }
  
  # Render output
  output$count_graph <- renderDygraph()
  
  output$class_graph <- renderDygraph()
}
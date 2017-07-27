# Load dependencies
source("build_titles.R")
source("ores_data.R")

# Get system date
system_run_date <- Sys.Date()

# Check for and include data. If it's not there,
# define everything cleanly
if(!dir.exists("../data/") | !file.exists("../data/dalit_data.RData")){
  dir.create("../data/", showWarnings = FALSE)
  quality_data <- data.frame()
  count_data <- data.frame()
} else {
  load(file = "../data/dalit_data.RData")
}

main_func <- function(start_date = system_run_date, end_date = NULL){
  if(is.null(end_date)){
    # Grab title data
    titles <- get_titles()
    
    # Calculate count data
    count_data <- rbind(count_data,
                        data.frame(date = system_run_date,
                                   count_data = length(titles)
                        )
    )
    
    # Get ORES scores
    ores_scores <- get_quality(titles)
    
    # Generate an aggregate
    aggregate_scores <- as.data.frame(table(ores_scores$prediction),
                                      stringsAsFactors = FALSE)
    names(aggregate_scores) <- c("quality_class", "count")
    aggregate_scores$date <- system_run_date
    aggregate_scores <- aggregate_scores[,c("date", "quality_class", "count")]
    quality_data <- rbind(quality_data, aggregate_scores)
    
    # Write out files and quit
    save(quality_data, count_data, file = "../data/dalit_data.RData")
  }
}

main_func()
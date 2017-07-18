source("utils.R")

get_last_edit_ <- function(titles){
  
  # Construct query parameters
  query_params <- list(action = "query",
                       prop = "revisions",
                       titles = paste0(titles, collapse = "|"),
                       rvprop = "ids",
                       format = "json")
  
  # Make query and return results
  results <- query_wp(query_params,
                      "Revision IDs could not be retrieved")
  
  return(results$query$pages)
}

get_last_edit <- function(titles){
  
  if(length(titles) > 50){
    titles <- split(titles, ceiling(seq_along(titles)/50))
  } else {
    titles <- list(titles)
  }
  
  results <- unlist(
    lapply(titles, get_last_edit_),
    recursive = FALSE, use.names = FALSE
  )
  
  return(unlist(lapply(results, function(x){
    return(x$revisions[[1]]$revid)
  })))
}

get_quality <- function(titles){
  
  # Grab revIDs
  rev_ids <- get_last_edit(titles)
  
  # Get scores
  scores <- ores::check_quality("enwiki", rev_ids)
}
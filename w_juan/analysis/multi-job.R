suppressMessages(library(tidyverse))
get_output <- function(n = 100){
    items <- 1:n
    item_out <- sample(items,10)
    item_in  <- setdiff(items, item_out) %>% sample(.,20)
    max(item_out) > max(item_in)
}

set.seed(1234)
mean_result <- c()
for (i in 1:1000) {
    result <- c()
    for (i in 1:1000){
        element <- get_output(n = 1000)
        result <- c(result,element)
    }
    mean_element <- mean(result)
    mean_result <- c(mean_element, mean_result)
}
mean_result
mean_result %>% write_rds("mean_result.rds")
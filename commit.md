
``` r
library(tidyverse)

test_df <- data.frame(a = 1:5, b = 1:5)
x <- data.frame(a = c(1:15),
          b = c(1:15))
y <- c(1:15)
```

``` r
for (i in 1:length(x)) {
    x_input <- x[[i]]
    y_input <- y
    fit <- lm(y_input ~ x_input)
    x_input <- data.frame(x_input = test_df[[i]])
    new_name <- test_df %>% names %>% .[[i]] %>% paste0("_score")
    test_df[new_name] <- predict.lm(fit, newdata = x_input)
}
```

``` r
test_df
```

    ##   a b a_score b_score
    ## 1 1 1       1       1
    ## 2 2 2       2       2
    ## 3 3 3       3       3
    ## 4 4 4       4       4
    ## 5 5 5       5       5

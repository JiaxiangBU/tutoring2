
``` r
library(tidyverse)
```

    ## -- Attaching packages --------------------------------------- tidyverse 1.2.1 --

    ## √ ggplot2 3.2.1     √ purrr   0.3.3
    ## √ tibble  2.1.3     √ dplyr   0.8.3
    ## √ tidyr   1.0.2     √ stringr 1.4.0
    ## √ readr   1.3.1     √ forcats 0.4.0

    ## Warning: package 'ggplot2' was built under R version 3.6.2

    ## Warning: package 'tidyr' was built under R version 3.6.2

    ## Warning: package 'purrr' was built under R version 3.6.1

    ## Warning: package 'dplyr' was built under R version 3.6.1

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
df_1 <- data.frame(A = c('asd', 'adf', 'afg', 'agh', 'ahj'), stringsAsFactors = FALSE)
df_2 <- data.frame(B = c('as', 'af', 'aj'), stringsAsFactors = FALSE)
```

这里 for 循环我觉得复杂了，可以向量化操作。

``` r
left_join(df_1 %>% mutate(on = 1),
          df_2 %>% mutate(on = 1), by = 'on') %>% 
    select(-on) %>% 
    group_by(A) %>% 
    mutate(match = str_detect(A,B),
           text = ifelse(match==1,B,"")) %>% 
    summarise(
        match = sum(match),
        text = str_flatten(text,"")
    )
```

    ## # A tibble: 5 x 3
    ##   A     match text 
    ##   <chr> <int> <chr>
    ## 1 adf       0 ""   
    ## 2 afg       1 af   
    ## 3 agh       0 ""   
    ## 4 ahj       0 ""   
    ## 5 asd       1 as

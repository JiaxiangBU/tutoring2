字符模糊匹配
================

``` r
knitr::opts_chunk$set(warning = FALSE, message = FALSE)
library(tidyverse)
library(data.table)
data <- fread('data.csv')
```

``` r
library(rebus)
data %>% 
    select(phone_province) %>% 
    mutate(
        province_simplify = 
            str_extract(data$province
                        ,data$phone_province %>% 
                            str_flatten('|') %>% 
                            or()
                        )
    )
```

    ##   phone_province province_simplify
    ## 1           广东              <NA>
    ## 2           云南              云南
    ## 3           辽宁              <NA>
    ## 4           贵州              <NA>
    ## 5         内蒙古            内蒙古
    ## 6           宁夏              宁夏

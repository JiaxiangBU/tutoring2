提取路径
================

``` r
path <- "D:/tmp/Peking-xwt-1/TestResult/007018-99999/007018-99999-2011"
```

``` r
library(tidyverse)
```

    ## ─ Attaching packages ───────────────────────── tidyverse 1.2.1 ─

    ## ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.8
    ## ✔ tidyr   0.8.2     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ─ Conflicts ────────────────────────── tidyverse_conflicts() ─
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
path %>% 
    dirname() %>% 
    basename() %>% 
    str_split("-") %>% 
    .[[1]] %>% 
    .[1]
```

    ## [1] "007018"

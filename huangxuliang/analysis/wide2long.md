
``` r
library(tidyverse)
```

    ## -- Attaching packages ------------------------------------------------------------------------------ tidyverse 1.2.1 --

    ## √ ggplot2 3.2.0     √ purrr   0.3.2
    ## √ tibble  2.1.3     √ dplyr   0.8.2
    ## √ tidyr   0.8.3     √ stringr 1.4.0
    ## √ readr   1.3.1     √ forcats 0.4.0

    ## Warning: package 'ggplot2' was built under R version 3.5.3

    ## Warning: package 'tibble' was built under R version 3.5.3

    ## Warning: package 'tidyr' was built under R version 3.5.3

    ## Warning: package 'purrr' was built under R version 3.5.3

    ## Warning: package 'dplyr' was built under R version 3.5.3

    ## Warning: package 'stringr' was built under R version 3.5.3

    ## Warning: package 'forcats' was built under R version 3.5.3

    ## -- Conflicts --------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(readxl)
library(magrittr)
```

    ## 
    ## Attaching package: 'magrittr'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     set_names

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     extract

``` r
df <- read_excel("../refs/20190918_kaifanghongguan_nvxing(2)(1).xlsx")
```

``` r
df %>% dim
```

    ## [1] 121440     22

``` r
df %<>%
    `names<-`(df %>% names %>% make.names() %>% str_remove_all("^X"))
# 字段名不要加空格
```

``` r
df2 <- 
df %>% 
    gather(year, value, -Country.Name, -Series.Name) %>% 
    spread(Series.Name, value)
```

``` r
df2[1:6,1:6]
```

    ## # A tibble: 6 x 6
    ##   Country.Name year  `Access to anti~ `Access to anti~ `Account owners~
    ##   <chr>        <chr> <chr>            <chr>            <chr>           
    ## 1 Afghanistan  1999~ ..               ..               ..              
    ## 2 Afghanistan  2000~ ..               ..               ..              
    ## 3 Afghanistan  2001~ ..               ..               ..              
    ## 4 Afghanistan  2002~ ..               ..               ..              
    ## 5 Afghanistan  2003~ ..               ..               ..              
    ## 6 Afghanistan  2004~ ..               ..               ..              
    ## # ... with 1 more variable: `Account ownership at a financial institution
    ## #   or with a mobile-money-service provider, male (% of population ages
    ## #   15+)` <chr>

``` r
# 审阅
```

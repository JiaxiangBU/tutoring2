国家接壤
================

1.  国家之间相互接壤，是为1，否为0
2.  相互接壤中，隔海也算，但是标记出来，是为1，否为0

表格大小 \(39\times39\)行和4列

``` r
library(tidyverse)
matrix(NA,nrow = 10,ncol = 4) %>% 
  `colnames<-`(c('国家A','国家B','是否接壤','是否隔海')) %>% 
  as.data.frame()
```

    ##    国家A 国家B 是否接壤 是否隔海
    ## 1     NA    NA       NA       NA
    ## 2     NA    NA       NA       NA
    ## 3     NA    NA       NA       NA
    ## 4     NA    NA       NA       NA
    ## 5     NA    NA       NA       NA
    ## 6     NA    NA       NA       NA
    ## 7     NA    NA       NA       NA
    ## 8     NA    NA       NA       NA
    ## 9     NA    NA       NA       NA
    ## 10    NA    NA       NA       NA

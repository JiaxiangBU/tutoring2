
``` r
# library(tidyverse) 
# str_extract('"a_1_2>2000"', '>\\d+')
```

``` r
text <- '"a_1_2>2000"'
```

``` r
library(rebus)
library(magrittr)
```

    ## 
    ## Attaching package: 'magrittr'

    ## The following object is masked from 'package:rebus':
    ## 
    ##     or

``` r
library(stringr)
```

    ## Warning: package 'stringr' was built under R version 3.5.3

    ## 
    ## Attaching package: 'stringr'

    ## The following object is masked from 'package:rebus':
    ## 
    ##     regex

``` r
text %>% 
    str_match(">(\\d{4})") %>% .[1,2]
```

    ## [1] "2000"

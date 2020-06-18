
> 按照D，把数据分为四个数据框

``` r
library(tidyverse)

set.seed(45L)
df <- tibble(
    A = runif(10, 0, 1),
    B = runif(10, 0, 1),
    D = c(0, 0, 0, 1, 1, 1, 1, 0, 0, 1)
)
```

``` r
df %>% 
    group_by(cumsum(c(0,abs(diff(D))))) %>% 
    nest() %>% 
    .$data
```

    ## [[1]]
    ## # A tibble: 3 x 3
    ##       A     B     D
    ##   <dbl> <dbl> <dbl>
    ## 1 0.633 0.369     0
    ## 2 0.318 0.880     0
    ## 3 0.241 0.308     0
    ## 
    ## [[2]]
    ## # A tibble: 4 x 3
    ##       A     B     D
    ##   <dbl> <dbl> <dbl>
    ## 1 0.378 0.460     1
    ## 2 0.352 0.431     1
    ## 3 0.298 0.411     1
    ## 4 0.228 0.965     1
    ## 
    ## [[3]]
    ## # A tibble: 2 x 3
    ##       A     B     D
    ##   <dbl> <dbl> <dbl>
    ## 1 0.555 0.142     0
    ## 2 0.185 0.409     0
    ## 
    ## [[4]]
    ## # A tibble: 1 x 3
    ##         A     B     D
    ##     <dbl> <dbl> <dbl>
    ## 1 0.00528 0.238     1

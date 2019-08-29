
``` r
df <- data.frame(A = 1:10, B = 1:10, type = rep(letters[1:5], each = 2)); df
```

    ##     A  B type
    ## 1   1  1    a
    ## 2   2  2    a
    ## 3   3  3    b
    ## 4   4  4    b
    ## 5   5  5    c
    ## 6   6  6    c
    ## 7   7  7    d
    ## 8   8  8    d
    ## 9   9  9    e
    ## 10 10 10    e

``` r
result <- data.frame(A = c(3, 7, 11, 15, 19), B = c(3, 7, 11, 15, 19), type = letters[1:5]); result
```

    ##    A  B type
    ## 1  3  3    a
    ## 2  7  7    b
    ## 3 11 11    c
    ## 4 15 15    d
    ## 5 19 19    e

``` r
library(tidyverse)
df %>% 
    group_by(type) %>% 
    summarise_all(funs(sum)) %>% 
    select(A,B,type)
```

    ## # A tibble: 5 x 3
    ##       A     B type 
    ##   <int> <int> <fct>
    ## 1     3     3 a    
    ## 2     7     7 b    
    ## 3    11    11 c    
    ## 4    15    15 d    
    ## 5    19    19 e

``` r
    # 排序
```

找最近的点
================
Jiaxiang Li
2019-03-14

``` r
suppressMessages(library(tidyverse))
```

``` r
read_lines("L04808.inf", n_max = 6)
```

    ## [1] "k\t-48.470881\t32.011461\t95.238590"  
    ## [2] "i\t-21.382022\t29.339303\t104.449558" 
    ## [3] "j\t19.595904\t31.194517\t102.236371"  
    ## [4] "l\t45.550416\t32.628547\t97.349969"   
    ## [5] "v\t-28.168727\t-40.454120\t110.929256"
    ## [6] "w\t25.815436\t-41.598142\t108.601852"

``` r
read_lines("L04808.vtx", n_max = 6)
```

    ## [1] "-7.438540\t-91.531036\t84.705287" "-6.838273\t-91.779326\t84.984915"
    ## [3] "-4.882652\t-93.316424\t85.449459" "-4.779594\t-93.432092\t85.415700"
    ## [5] "-4.126869\t-93.563063\t85.388501" "-3.469838\t-93.705728\t85.336970"

``` r
vtx <- read_delim("L04808.vtx",delim = '\t',col_names = c('x1','y1','z1'))
```

    ## Parsed with column specification:
    ## cols(
    ##   x1 = col_double(),
    ##   y1 = col_double(),
    ##   z1 = col_double()
    ## )

``` r
inf <- read_delim("L04808.inf",delim = '\t',col_names = c('l','x2','y2','z2'))
```

    ## Parsed with column specification:
    ## cols(
    ##   l = col_character(),
    ##   x2 = col_double(),
    ##   y2 = col_double(),
    ##   z2 = col_double()
    ## )

``` r
vtx %>% dim
```

    ## [1] 32251     3

``` r
inf %>% dim
```

    ## [1] 17  4

`vtx`是一个立体的脸。

``` r
inf %>% mutate(by = 1) %>% 
    full_join(vtx %>% mutate(by = 1) %>% 
                  mutate(vtx_index = row_number())
                  , by = 'by') %>% 
    group_by(l) %>% 
    mutate(
        dist = (x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2
    ) %>% 
    filter(
        dist == min(dist)
    )
```

    ## # A tibble: 17 x 10
    ## # Groups:   l [17]
    ##    l           x2     y2    z2    by       x1      y1    z1 vtx_index
    ##    <chr>    <dbl>  <dbl> <dbl> <dbl>    <dbl>   <dbl> <dbl>     <int>
    ##  1 k     -4.85e+1  32.0   95.2     1 -4.86e+1  32.1    95.3     23786
    ##  2 i     -2.14e+1  29.3  104.      1 -2.13e+1  29.9   104.      23814
    ##  3 j      1.96e+1  31.2  102.      1  1.94e+1  31.7   103.      23860
    ##  4 l      4.56e+1  32.6   97.3     1  4.52e+1  32.3    97.7     23889
    ##  5 v     -2.82e+1 -40.5  111.      1 -2.83e+1 -40.1   111.      10292
    ##  6 w      2.58e+1 -41.6  109.      1  2.60e+1 -42.1   109.      10349
    ##  7 o      0.        0    140       1  5.77e-2  -0.832 140.      17346
    ##  8 p     -1.42e-3  38.6  113.      1  9.09e-3  38.0   113.      24265
    ##  9 m     -1.90e+1  -7.42 116.      1 -1.91e+1  -7.43  116.      16834
    ## 10 n      2.00e+1  -7.76 114.      1  1.99e+1  -7.78  114.      16879
    ## 11 r     -1.00e+0 -39.4  126.      1 -8.56e-1 -39.3   126.      10823
    ## 12 s      4.14e-1 -35.2  130.      1  9.09e-1 -35.3   130.      12597
    ## 13 t      7.99e-1 -46.3  127.      1  3.03e-1 -46.6   127.       9073
    ## 14 q     -1.06e-3 -14.6  126.      1  3.82e-2 -14.3   127.      15373
    ## 15 z     -1.00e+0 -82.6  116.      1 -7.60e-1 -82.2   117.       3206
    ## 16 x     -7.33e+1 -26.1   35.9     1 -7.34e+1 -25.9    36.1     15000
    ## 17 y      6.28e+1 -30.9   30.1     1  6.27e+1 -31.0    30.3     15496
    ## # ... with 1 more variable: dist <dbl>

如果运算量大，运算速度慢，可以采用下面的方法。 round 图片加速运算。

``` r
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
library(wrapr)
```

    ## 
    ## Attaching package: 'wrapr'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     coalesce

    ## The following object is masked from 'package:tibble':
    ## 
    ##     view

``` r
# vtx
vtx %>% round(-1) %>% distinct() -> vtx_n1;dim(vtx_n1)
```

    ## [1] 707   3

``` r
vtx %>% round( 0) %>% distinct() -> vtx_00;dim(vtx_00)
```

    ## [1] 29632     3

``` r
vtx %>% round( 1) %>% distinct() -> vtx_01;dim(vtx_01)
```

    ## [1] 32235     3

``` r
vtx %>% round( 2) %>% distinct() -> vtx_02;dim(vtx_02)
```

    ## [1] 32240     3

``` r
vtx %>% round( 3) %>% distinct() -> vtx_03;dim(vtx_03)
```

    ## [1] 32240     3

然后按照round后的图片，先找 local 最优，再调试。

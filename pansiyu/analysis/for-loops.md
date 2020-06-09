
``` r
library(tidyverse)
library(fs)
```

我看了下整体代码，你做这样的修改

``` r
fun <- function(x,y) print(x,y)
```

``` r
for (i in 1:3) {
    for (j in 1:3) {
        fun(i,j)
    }
}
```

    ## [1] 1
    ## [1] 1
    ## [1] 1
    ## [1] 2
    ## [1] 2
    ## [1] 2
    ## [1] 3
    ## [1] 3
    ## [1] 3

``` r
i <- 1:3
j <- 1:3
map2_chr(i,j,fun)
```

    ## [1] 1
    ## [1] 2
    ## [1] 3

    ## [1] "1" "2" "3"

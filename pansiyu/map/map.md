map 用法
================
Jiaxiang Li
2018-11-26

# `x=x`

``` r
library(tidyverse)
```

    ## -- Attaching packages ------------------------------------------------------------------------------------------------------------------------------ tidyverse 1.2.1 --

    ## √ ggplot2 3.1.0     √ purrr   0.2.5
    ## √ tibble  1.4.2     √ dplyr   0.7.8
    ## √ tidyr   0.8.2     √ stringr 1.3.1
    ## √ readr   1.1.1     √ forcats 0.3.0

    ## -- Conflicts --------------------------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
spread <- list(sd = sd, iqr = IQR, mad = mad)
x <- rnorm(100)
invoke_map_dbl(spread, x = x)
```

    ##       sd      iqr      mad 
    ## 1.071393 1.381208 1.042040

[参考
Community](https://community.rstudio.com/t/problems-with-invoke-map-dbl-s-argument/18800?u=econkid)的这个答案，
注意函数`invoke_map_dbl(.f = spread, .x = list(NULL), ...)`，

1.  这里`x = x`指的是`...`，也就是其他参数。
2.  当对`.x`不指定时，默认`.x = list(NULL)`

# other

``` r
set.seed(123)
# 以下出现随机数，限定 seed
x <- rnorm(100)
library(purrr)
library(tidyr)
# invoke_map(spread, .x = x)
```

这里`spread`函数设定有问题，因为点开help文档，这里需要指定两个参数，`key`和`value`这里只有一列数据`rnorm(100)`。

> …中 x=x,为啥不是.x=x呢？我看这个函数的参数里是.x啊

`purrr::invoke_map`看 help 文档。

>   - `f`  
>     For `invoke`, a function; for `invoke_map` a list of functions.

这说明这里是一组函数，因此这里不能单个用`spread`，注意`list`的格式，写成`list(spread)`

>   - `.x`  
>     For `invoke`, an argument-list; for `invoke_map` a list of
>     argument-lists the same length as `.f (or length 1)`. The default
>     argument, `list(NULL)`, will be recycled to the same length as
>     `.f`, and will call each function with no arguments (apart from
>     any supplied in ….

这里依然说明是一组数据，因此不能单个用`rnorm(100)`，注意`list`的格式，写成`list(rnorm(100))`

为了跑通代码，我这里将函数`spread`替换成`mean`，你可以之后设置好`list`测试下。

``` r
invoke_map(list(mean),list(x))
```

    ## [[1]]
    ## [1] -0.5604756

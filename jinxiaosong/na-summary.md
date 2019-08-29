缺失值表
================
李家翔
2019-04-03

``` r
suppressMessages(source(here::here("R/load.R")))
```

``` r
df <- tibble(A = as.character(c(1,1,1,0,0)), B = c(NA,NA,10,NA,20), D = c(NA,10,10,20,20))

rs <- tibble(col_names = c('B','D'), na_num_1 = c(2,1),
na_num_0 = c(1,0), na_per_1 = c(2/3, 1/2),
na_per_0 = c(1/3,0))
```

``` r
df
```

    ## # A tibble: 5 x 3
    ##   A         B     D
    ##   <chr> <dbl> <dbl>
    ## 1 1        NA    NA
    ## 2 1        NA    10
    ## 3 1        10    10
    ## 4 0        NA    20
    ## 5 0        20    20

``` r
rs
```

    ## # A tibble: 2 x 5
    ##   col_names na_num_1 na_num_0 na_per_1 na_per_0
    ##   <chr>        <dbl>    <dbl>    <dbl>    <dbl>
    ## 1 B                2        1    0.667    0.333
    ## 2 D                1        0    0.5      0

``` r
df %>% 
    group_by(A) %>% 
    mutate_all(is.na) %>% 
    summarise_all(sum) %>% 
    # 前面和你差不多，根据 rs 需要转置
    column_to_rownames('A') %>% 
    t() %>% 
    # 加入比例
    {cbind(.,./rowSums(.))} %>% 
    
    # 命名
    `colnames<-`(paste0(colnames(.),
                     c(rep("num",2),rep("num",2))))
```

    ## `mutate_all()` ignored the following grouping variables:
    ## Column `A`
    ## Use `mutate_at(df, vars(-group_cols()), myoperation)` to silence the message.

    ##   0num 1num      0num      1num
    ## B    1    2 0.3333333 0.6666667
    ## D    0    1 0.0000000 1.0000000

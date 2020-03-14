
``` r
library(tidyverse)
df <- data.frame(A = 1:5)
df_tmp <- matrix(NA, ncol = 3, nrow = 5) %>%
    as.data.frame() %>%
    `names<-`(paste0(c('a', 'b', 'd'), "_score"))

df_bind <- bind_cols(df, df_tmp)

for (i in c('a', 'b', 'd')) {
    df_bind[, paste0(c('a', 'b', 'd'), "_score")] <- df$A
    
}

df_bind
```

    ##   A a_score b_score d_score
    ## 1 1       1       1       1
    ## 2 2       2       2       2
    ## 3 3       3       3       3
    ## 4 4       4       4       4
    ## 5 5       5       5       5

> 这是我解决这个问题的间接方法

如果最终目的是生成这个数据集`df_bind`， 每列都一样，我觉得可以这么搞。

比如你想要新增三列。

``` r
matrix(rep(df$A, 3 + 1),
       nrow = nrow(df))    %>%
    `colnames<-`(c(df %>% names(), paste0(letters[0:3], "_score"))) %>%
    as.data.frame()
```

    ##   A a_score b_score c_score
    ## 1 1       1       1       1
    ## 2 2       2       2       2
    ## 3 3       3       3       3
    ## 4 4       4       4       4
    ## 5 5       5       5       5

``` r
# 变量
# df
# 3 也就是新增多少行
```

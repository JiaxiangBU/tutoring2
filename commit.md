
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

> 其实我更想知道的是，能不能再循环中增加列

``` r
df # 还是这个数据，假设每次我都随机增加一列
```

    ##   A
    ## 1 1
    ## 2 2
    ## 3 3
    ## 4 4
    ## 5 5

``` r
set.seed(123)
for (i in 1:3) {
    feature_name <- paste0(letters[i],'_score')
    df[[feature_name]] <- runif(nrow(df),0,1)
}
df
```

    ##   A   a_score   b_score   c_score
    ## 1 1 0.2875775 0.0455565 0.9568333
    ## 2 2 0.7883051 0.5281055 0.4533342
    ## 3 3 0.4089769 0.8924190 0.6775706
    ## 4 4 0.8830174 0.5514350 0.5726334
    ## 5 5 0.9404673 0.4566147 0.1029247

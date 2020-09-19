
``` r
df <- read_excel("jinxiaosong/data/pivot_help.xlsx")  
```

``` r
df %>%
    group_by(cut,color) %>%
    summarise(pctg = sum(n)) %>% 
    ungroup() %>% 
    group_by(cut) %>% 
    mutate(pctg = pctg/sum(pctg)) %>% 
    spread(color,pctg)
```

    ## # A tibble: 5 x 8
    ## # Groups:   cut [5]
    ##   cut           D     E     F     G     H      I      J
    ##   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
    ## 1 Fair      0.101 0.139 0.194 0.195 0.188 0.109  0.0739
    ## 2 Good      0.135 0.190 0.185 0.178 0.143 0.106  0.0626
    ## 3 Ideal     0.132 0.181 0.178 0.227 0.145 0.0971 0.0416
    ## 4 Premium   0.116 0.169 0.169 0.212 0.171 0.104  0.0586
    ## 5 Very Good 0.125 0.199 0.179 0.190 0.151 0.0997 0.0561

我看了下你的代码，我发现你的思路是按照 dplyr 的方式去实现的。 就是说靠函数/pipeline，把每个 scalars
求出来，然后再进行汇总，这是 dplyr 的风格。 也就是是，你在每一次 group\_by
后，都需要统筹全局的去想想。

pandas 更喜欢自定义函数，你分好块，然后只需要思考其中一块怎么 lambda 函数完成，然后向量化操作。

思维上会不太一样。 建议你看一下
<https://github.com/JiaxiangBU/learn_credit_risk/pull/125>

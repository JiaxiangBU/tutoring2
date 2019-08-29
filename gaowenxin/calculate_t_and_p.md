计算 OLS 的 t 值 和 p 值
================

``` r
fit <- lm(disp ~ mpg, data = mtcars)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = disp ~ mpg, data = mtcars)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -103.05  -45.74   -8.17   46.65  153.75 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  580.884     41.740  13.917 1.26e-14 ***
    ## mpg          -17.429      1.993  -8.747 9.38e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 66.86 on 30 degrees of freedom
    ## Multiple R-squared:  0.7183, Adjusted R-squared:  0.709 
    ## F-statistic: 76.51 on 1 and 30 DF,  p-value: 9.38e-10

目前从 pmg 中，你已知 beta 和 se 了，那么 t 值等于

``` r
-17.429/1.993
```

    ## [1] -8.745108

你可以查看 `summary()` 结果中的 `-8.747`

<!-- t 分布是假设更严密的 z 分布，那么这里可以放缩一下，根据 z 分布计算出 p 值 -->

``` r
2*pt(-abs(-17.429/1.993),df=30)
```

    ## [1] 9.428247e-10

和 `summary()` 结果有一些误差，但是差不多，误差在

``` r
9.428247e-10/9.38e-10 - 1
```

    ## [1] 0.005143603

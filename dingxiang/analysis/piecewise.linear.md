断点回归
================

``` r
library(tidyverse)
library(fs)
```

``` r
load(here::here("../tutoring_private/dingxiang/data/dingxiang.Rdata"))
```

``` r
df <- data2 %>% 
    as.data.frame()
```

``` r
df %>% head()
```

    ##        Temp season variable      value
    ## 1  25.91810 Spring      Dim 0.02530587
    ## 5  27.86535 Summer      Dim 0.02530587
    ## 9  29.19039 Summer      Dim 0.03742650
    ## 10 28.55140 Summer      Dim 0.08278537
    ## 11 29.03562 Summer      Dim 0.01283722
    ## 12 28.39074 Summer      Dim 0.11909613

``` r
df %>% dim()
```

    ## [1] 27  4

``` r
# install.packages("SiZer")
library(SiZer)
```

    ## Warning: package 'SiZer' was built under R version 3.6.3

``` r
# 测试 demo
data(Arkansas)
Arkansas %>% dim
x <- Arkansas$year
y <- Arkansas$sqrt.mayflies

model <- piecewise.linear(x,y, CI=FALSE)
plot(model)
print(model)
predict(model, 2001)
```

``` r
fit <-
    piecewise.linear(
        df$Temp,
        df$value,
        middle = 1,
        CI = TRUE,
        bootstrap.samples = 100,
        sig.level = 0.05
    )
```

``` r
print(fit)
```

    ## [1] "Threshold alpha: 24.511351293446"
    ## [1] ""
    ## [1] "Model coefficients: Beta[0], Beta[1], Beta[2]"
    ## (Intercept)           x           w 
    ## -1.16609196  0.05691652 -0.11164444 
    ##       Change.Point Initial.Slope Slope.Change Second.Slope
    ## 2.5%      23.50089   -0.06897481  -0.49300497  -0.08040016
    ## 97.5%     27.41220    0.44311302   0.09189072   0.02956898

通过`str(fit)`发现其中对象`.$model`就是`lm`然后提取F值。

``` r
summary(fit$model)
```

    ## 
    ## Call:
    ## stats::lm(formula = y ~ x + w)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.15493 -0.08077 -0.01474  0.07276  0.20609 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept) -1.16609    1.13198  -1.030   0.3132  
    ## x            0.05692    0.04734   1.202   0.2409  
    ## w           -0.11164    0.05700  -1.959   0.0619 .
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.1018 on 24 degrees of freedom
    ## Multiple R-squared:  0.4016, Adjusted R-squared:  0.3518 
    ## F-statistic: 8.054 on 2 and 24 DF,  p-value: 0.002107

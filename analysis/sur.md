SUR demo
================

参考 Kleiber and Zeileis (2008)

``` r
knitr::opts_chunk$set(warning = FALSE, message = FALSE)
```

``` r
library(systemfit)
library(plm)
data("Grunfeld", package = "AER")
gr2 <- subset(Grunfeld, firm %in% c("Chrysler", "IBM")) # Id 太多会很慢
pgr2 <- pdata.frame(gr2, c("firm", "year"))
# use of 'plm.data' is discouraged, better use 'pdata.frame' instead
gr_ols <- systemfit(invest ~ value + capital, method = "OLS", data = pgr2)
gr_sur <- systemfit(invest ~ value + capital, method = "SUR", data = pgr2)
summary(gr_ols, residCov = FALSE, equations = FALSE) # 展示每个id每个beta
```

    ## 
    ## systemfit results 
    ## method: OLS 
    ## 
    ##         N DF     SSR detRCov   OLS-R2 McElroy-R2
    ## system 40 34 4107.98 11051.2 0.929037   0.927797
    ## 
    ##           N DF     SSR      MSE     RMSE       R2   Adj R2
    ## Chrysler 20 17 2997.44 176.3203 13.27856 0.913578 0.903411
    ## IBM      20 17 1110.53  65.3255  8.08242 0.952142 0.946512
    ## 
    ## 
    ## Coefficients:
    ##                        Estimate Std. Error  t value   Pr(>|t|)    
    ## Chrysler_(Intercept) -6.1899605 13.5064781 -0.45830 0.65254426    
    ## Chrysler_value        0.0779478  0.0199733  3.90260 0.00114521 ** 
    ## Chrysler_capital      0.3157182  0.0288132 10.95743 3.9888e-09 ***
    ## IBM_(Intercept)      -8.6855434  4.5451680 -1.91094 0.07302512 .  
    ## IBM_value             0.1314548  0.0311723  4.21704 0.00057991 ***
    ## IBM_capital           0.0853743  0.1003060  0.85114 0.40652221    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
summary(gr_sur, residCov = FALSE, equations = FALSE)
```

    ## 
    ## systemfit results 
    ## method: SUR 
    ## 
    ##         N DF     SSR detRCov   OLS-R2 McElroy-R2
    ## system 40 34 4113.64   11022 0.928939   0.927094
    ## 
    ##           N DF     SSR      MSE     RMSE       R2   Adj R2
    ## Chrysler 20 17 3001.64 176.5672 13.28786 0.913457 0.903276
    ## IBM      20 17 1112.00  65.4117  8.08775 0.952079 0.946441
    ## 
    ## 
    ## Coefficients:
    ##                        Estimate Std. Error  t value   Pr(>|t|)    
    ## Chrysler_(Intercept) -5.7031286 13.2773843 -0.42954 0.67292712    
    ## Chrysler_value        0.0779871  0.0195817  3.98266 0.00096271 ***
    ## Chrysler_capital      0.3114785  0.0286957 10.85455 4.5944e-09 ***
    ## IBM_(Intercept)      -8.0908189  4.5216484 -1.78935 0.09138881 .  
    ## IBM_value             0.1272417  0.0306021  4.15794 0.00065881 ***
    ## IBM_capital           0.0966341  0.0983302  0.98275 0.33951047    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

<div id="refs" class="references">

<div id="ref-Kleiber2008Applied">

Kleiber, Christian, and Achim Zeileis. 2008. *Applied Econometrics with
R*. Springer New York.

</div>

</div>

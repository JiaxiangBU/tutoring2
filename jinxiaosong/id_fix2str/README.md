身份证导出识别为int
================
李家翔
2018-11-15

> 因为我导出有身份证这个字段 他就默认为数值了 就算是我设置为字符型或者是因子型 他导出还是数值型

``` r
library(data.table)
library(tidyverse)
```

    ## ─ Attaching packages ────────────────────────────────────── tidyverse 1.2.1 ─

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ─ Conflicts ──────────────────────────────────────── tidyverse_conflicts() ─
    ## ✖ dplyr::between()   masks data.table::between()
    ## ✖ dplyr::filter()    masks stats::filter()
    ## ✖ dplyr::first()     masks data.table::first()
    ## ✖ dplyr::lag()       masks stats::lag()
    ## ✖ dplyr::last()      masks data.table::last()
    ## ✖ purrr::transpose() masks data.table::transpose()

``` r
tmp <- fread("1115_3.txt", encoding = 'UTF-8')
```

``` r
tmp
```

    ##                    V1
    ## 1: 123456999999999999
    ## 2: 12345645678914785x
    ## 3: 789456456123147852

``` r
write.csv(tmp, "tmp_output.csv", row.names = F)
```

基本代码跑完后，字符没有改变。

![](string_unchange.png)

那么Excel打开后为什么会改变呢？ 我猜是Excel对单元格进行了自动处理。

1.  这对长期使用Excel的人来说是友好的
2.  但是对数据分析的人来说是不友好的

我当年用Excel的时候，有过一个技巧，如下。

``` r
library(glue)
```

    ## 
    ## Attaching package: 'glue'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     collapse

``` r
tmp %>% 
    mutate(V2 = glue("\'{V1}")) %>% 
    write_excel_csv('tmp_addcomma.csv')
```

![](add_comma.png) ![](add_comma02.png)

我们检查下你的session
    info

``` r
sessioninfo::session_info()
```

    ## ─ Session info ──────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 3.5.1 (2018-07-02)
    ##  os       macOS  10.14                
    ##  system   x86_64, darwin15.6.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  zh_CN.UTF-8                 
    ##  ctype    zh_CN.UTF-8                 
    ##  tz       Asia/Shanghai               
    ##  date     2018-11-15                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package     * version date       lib source        
    ##  assertthat    0.2.0   2017-04-11 [1] CRAN (R 3.5.0)
    ##  backports     1.1.2   2017-12-13 [1] CRAN (R 3.5.0)
    ##  bindr         0.1.1   2018-03-13 [1] CRAN (R 3.5.0)
    ##  bindrcpp    * 0.2.2   2018-03-29 [1] CRAN (R 3.5.0)
    ##  broom         0.5.0   2018-07-17 [1] CRAN (R 3.5.0)
    ##  cellranger    1.1.0   2016-07-27 [1] CRAN (R 3.5.0)
    ##  cli           1.0.1   2018-09-25 [1] CRAN (R 3.5.0)
    ##  colorspace    1.3-2   2016-12-14 [1] CRAN (R 3.5.0)
    ##  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.5.0)
    ##  data.table  * 1.11.8  2018-09-30 [1] CRAN (R 3.5.0)
    ##  digest        0.6.18  2018-10-10 [1] CRAN (R 3.5.0)
    ##  dplyr       * 0.7.6   2018-06-29 [1] CRAN (R 3.5.1)
    ##  evaluate      0.12    2018-10-09 [1] CRAN (R 3.5.0)
    ##  forcats     * 0.3.0   2018-02-19 [1] CRAN (R 3.5.0)
    ##  ggplot2     * 3.0.0   2018-07-03 [1] CRAN (R 3.5.0)
    ##  glue        * 1.3.0   2018-07-17 [1] CRAN (R 3.5.0)
    ##  gtable        0.2.0   2016-02-26 [1] CRAN (R 3.5.0)
    ##  haven         1.1.2   2018-06-27 [1] CRAN (R 3.5.0)
    ##  hms           0.4.2   2018-03-10 [1] CRAN (R 3.5.0)
    ##  htmltools     0.3.6   2017-04-28 [1] CRAN (R 3.5.0)
    ##  httr          1.3.1   2017-08-20 [1] CRAN (R 3.5.0)
    ##  jsonlite      1.5     2017-06-01 [1] CRAN (R 3.5.0)
    ##  knitr         1.20    2018-02-20 [1] CRAN (R 3.5.0)
    ##  lattice       0.20-35 2017-03-25 [1] CRAN (R 3.5.1)
    ##  lazyeval      0.2.1   2017-10-29 [1] CRAN (R 3.5.0)
    ##  lubridate     1.7.4   2018-04-11 [1] CRAN (R 3.5.0)
    ##  magrittr      1.5     2014-11-22 [1] CRAN (R 3.5.0)
    ##  modelr        0.1.2   2018-05-11 [1] CRAN (R 3.5.0)
    ##  munsell       0.5.0   2018-06-12 [1] CRAN (R 3.5.0)
    ##  nlme          3.1-137 2018-04-07 [1] CRAN (R 3.5.1)
    ##  pillar        1.3.0   2018-07-14 [1] CRAN (R 3.5.0)
    ##  pkgconfig     2.0.1   2017-03-21 [1] CRAN (R 3.5.0)
    ##  plyr          1.8.4   2016-06-08 [1] CRAN (R 3.5.0)
    ##  purrr       * 0.2.5   2018-05-29 [1] CRAN (R 3.5.0)
    ##  R6            2.3.0   2018-10-04 [1] CRAN (R 3.5.0)
    ##  Rcpp          1.0.0   2018-11-07 [1] CRAN (R 3.5.0)
    ##  readr       * 1.1.1   2017-05-16 [1] CRAN (R 3.5.0)
    ##  readxl        1.1.0   2018-04-20 [1] CRAN (R 3.5.0)
    ##  rlang         0.3.0.1 2018-10-25 [1] CRAN (R 3.5.0)
    ##  rmarkdown     1.10    2018-06-11 [1] CRAN (R 3.5.0)
    ##  rprojroot     1.3-2   2018-01-03 [1] CRAN (R 3.5.0)
    ##  rstudioapi    0.8     2018-10-02 [1] CRAN (R 3.5.0)
    ##  rvest         0.3.2   2016-06-17 [1] CRAN (R 3.5.0)
    ##  scales        1.0.0   2018-08-09 [1] CRAN (R 3.5.0)
    ##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.5.0)
    ##  stringi       1.2.4   2018-07-20 [1] CRAN (R 3.5.0)
    ##  stringr     * 1.3.1   2018-05-10 [1] CRAN (R 3.5.0)
    ##  tibble      * 1.4.2   2018-01-22 [1] CRAN (R 3.5.0)
    ##  tidyr       * 0.8.1   2018-05-18 [1] CRAN (R 3.5.0)
    ##  tidyselect    0.2.5   2018-10-11 [1] CRAN (R 3.5.0)
    ##  tidyverse   * 1.2.1   2017-11-14 [1] CRAN (R 3.5.0)
    ##  withr         2.1.2   2018-03-15 [1] CRAN (R 3.5.0)
    ##  xml2          1.2.0   2018-01-24 [1] CRAN (R 3.5.0)
    ##  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.5.0)
    ## 
    ## [1] /Library/Frameworks/R.framework/Versions/3.5/Resources/library

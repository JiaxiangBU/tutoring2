
``` r
# setwd("F:/rwork") #不要使用这行代码，没必要。
# library(nCov2019)
library(tidyverse)
```

    ## -- Attaching packages -------------------------------------------------------------- tidyverse 1.2.1 --

    ## √ ggplot2 3.2.1     √ purrr   0.3.3
    ## √ tibble  2.1.3     √ dplyr   0.8.3
    ## √ tidyr   0.8.3     √ stringr 1.4.0
    ## √ readr   1.3.1     √ forcats 0.4.0

    ## Warning: package 'ggplot2' was built under R version 3.6.2

    ## Warning: package 'purrr' was built under R version 3.6.1

    ## Warning: package 'dplyr' was built under R version 3.6.1

    ## -- Conflicts ----------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
# x <- load_nCov2019()
# x %>% write_rds("x.rds")
# 为了方便你调用，我把 x 这个对象离线保存下来了
```

``` r
x <- readr::read_rds("x.rds")
```

``` r
data_path <- "data"
dir.create(data_path, recursive = TRUE)
```

    ## Warning in dir.create(data_path, recursive = TRUE): 'data'已存在

``` r
for (i in unique(x[["data"]][["province"]])) {
    x[["data"]][i, c(1:6, 9:11)] %>%
        write_excel_csv(file.path(data_path, paste(i, '.csv', sep = '')))
}
```

``` r
fs::dir_ls(data_path)
```

    ## data/上海.csv  data/云南.csv  data/内蒙古.csv data/北京.csv  data/台湾.csv  data/吉林.csv  
    ## data/四川.csv  data/天津.csv  data/宁夏.csv  data/安徽.csv  data/山东.csv  data/山西.csv  
    ## data/广东.csv  data/广西.csv  data/新疆.csv  data/江苏.csv  data/江西.csv  data/河北.csv  
    ## data/河南.csv  data/浙江.csv  data/海南.csv  data/湖北.csv  data/湖南.csv  data/澳门.csv  
    ## data/甘肃.csv  data/福建.csv  data/西藏.csv  data/贵州.csv  data/辽宁.csv  data/重庆.csv  
    ## data/陕西.csv  data/青海.csv  data/香港.csv  data/黑龙江.csv

`dat.temp <-` 可以去掉，因为 `data %>% write.csv`
是把数据导出，不需要把这个操作赋值到变量`dat.temp`上。
这部分数据导入和导出的问题，参考下
<https://github.com/JiaxiangBU/tutoring2/issues/25#issuecomment-590035565>

``` bash
git clone https://github.com/JiaxiangBU/tutoring2.git
```

clone 这个项目后，用 RStudio 打开它。

打开这个 Rmd ，在项目路径的`liyongtao/write_csv.Rmd`，你就可以直接复现这个例子了。

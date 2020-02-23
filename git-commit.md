
前面的`sessionInfo()`我进行了删除，为了你每次打开这个issue简洁和快一些。

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

我搭建了一个临时环境，如图

你可以在这个临时环境测试代码。 临时环境启动的时候，稍等2-3分钟就构建完成。

<http://beta.mybinder.org/v2/gh/JiaxiangBU/tutoring2/master?urlpath=rstudio>
打开文件`liyongtao/write_csv.Rmd`

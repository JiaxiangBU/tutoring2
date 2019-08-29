R Notebook
================

``` r
knitr::opts_chunk$set(warning = FALSE, message = FALSE)
library(readxl)
library(tidyverse)
```

    ## ─ Attaching packages ────────────────────────────────────── tidyverse 1.2.1 ─

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ─ Conflicts ──────────────────────────────────────── tidyverse_conflicts() ─
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
library(glue)
```

    ## 
    ## Attaching package: 'glue'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     collapse

``` r
data <-
    read_excel('data.xlsx') %>% 
    rename_all(str_to_lower) %>% 
    # 变量名称用小写
    mutate_at(vars(starttime,endtime),dmy_hms)
    # 时间格式有问题，需要修改
```

> 表格中每一个ID表示每一个病人， num表示用某种药物的次数（第1次，第2次。。。），
> starttime和endtime分别是这种药物使用的起止时间。随后一列是时间差。
> 我现在想要刷选出针对每一个病人，
> 
> 1.  如果只用过一次药，那么就筛选出第一次。
> 2.  如果用过不止一次，那么筛选出每一次用药的开始时间与上一次用药的结束时间的差值小于一天的所有行。
> 3.  并且第一次用药记录保留

那么这个是两个需求。

# 需求一

``` r
data_1 <- 
data %>% 
    group_by(id) %>% 
    filter(n() == 1)
    # 只有一次用药的人
data_1
```

    ## # A tibble: 6 x 5
    ## # Groups:   id [6]
    ##       id   num starttime           endtime             duration_hours
    ##    <dbl> <dbl> <dttm>              <dttm>                       <dbl>
    ## 1 200024     1 2127-03-03 16:15:00 2127-03-03 20:30:00           4.25
    ## 2 200029     1 2115-03-29 21:30:00 2115-03-29 23:00:00           1.5 
    ## 3 200030     1 2150-11-13 15:00:00 2150-11-14 12:00:00          21   
    ## 4 200065     1 2120-03-22 23:00:00 2120-03-23 17:30:00          18.5 
    ## 5 200075     1 2159-09-23 01:40:00 2159-09-23 09:45:00           8.08
    ## 6 200087     1 2196-08-31 08:14:00 2196-09-01 08:30:00          24.3

# 需求二

``` r
data_2 <- 
    data %>% 
    group_by(id) %>% 
    filter(n() > 1) %>%
    arrange(starttime) %>% 
    # 需要查看本次和上次的关系，因此排序
    # mutate(is_ok = (starttime - lag(endtime)) < ddays(1))
    filter(
        (
            (starttime - lag(endtime)) < ddays(1) | num == 1
        )
    )
data_2
```

    ## # A tibble: 13 x 5
    ## # Groups:   id [4]
    ##        id   num starttime           endtime             duration_hours
    ##     <dbl> <dbl> <dttm>              <dttm>                       <dbl>
    ##  1 200028     1 2133-10-29 17:49:00 2133-10-30 02:06:00          8.28 
    ##  2 200028     2 2133-10-30 02:06:00 2133-10-30 14:31:00         12.4  
    ##  3 200063     1 2141-03-21 11:00:00 2141-03-21 14:14:00          3.23 
    ##  4 200063     2 2141-03-21 14:14:00 2141-03-21 18:27:00          4.22 
    ##  5 200063     3 2141-03-21 18:27:00 2141-03-22 03:05:00          8.63 
    ##  6 200063     4 2141-03-22 03:05:00 2141-03-22 13:30:00         10.4  
    ##  7 200077     1 2163-04-17 01:00:00 2163-04-18 02:30:00         25.5  
    ##  8 200077     2 2163-04-18 03:00:00 2163-04-18 06:00:00          3    
    ##  9 200059     1 2198-02-11 00:45:00 2198-02-11 03:15:00          2.5  
    ## 10 200059     2 2198-02-11 03:30:00 2198-02-11 11:40:00          8.17 
    ## 11 200059     3 2198-02-11 12:25:00 2198-02-11 13:15:00          0.833
    ## 12 200059     4 2198-02-12 00:45:00 2198-02-12 15:00:00         14.2  
    ## 13 200059     5 2198-02-13 05:00:00 2198-02-13 07:00:00          2

> data\_2里病人的第一次用药都没有了，都是从第二次开始的？

是的 这是按照需求一和需求二分开的。

> 但是第二次还是需要与第一次比较的。？

进行什么样的比较？ “如果只用过一次药”和“如果用过不止一次”两个条件是互斥不重叠。

> 我将“filter(n() \> 1) %\>%”这句删除，结果好像还是一样

是指`data_2`的结果一样还是，合并后的结果一样？

# 合并

``` r
bind_rows(data_1,data_2) %>% 
    write_excel_csv('output.csv')
```

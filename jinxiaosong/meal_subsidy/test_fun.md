
这是晓松的函数

``` r
p <- 
profvis::profvis({
  
canbu_summary <- function(path, file, work_cols) 
{
  library(hms)
  library(readxl)
  library(magrittr)
  library(tidyverse)
  library(lubridate)
  library(data.table)
  
  setwd(path)
  
  df <- read_excel(file)

  ## 对excel的数据进行一定的整理
  df %<>% 
    select(-1) %>% 
    setnames(names(.), c(paste0('V', 1:ncol(.)))) %>%
    mutate_all(~str_remove_all(., '[  \n]'))
  
  ## 选择工作日索引和非工作日索引
  cols_nowork <- paste0('V', work_cols-1)
  cols_work   <- setdiff(names(df), cols_nowork)
  
  ## 按照规则统计工作日的餐补情况
  df_work <- 
    df %>%
    select(cols_work) %>%
    mutate_all(
      ~ifelse(
        (as.hms(paste0(str_sub(., nchar(.)-4, nchar(.)), ':00')) -
           as.hms(paste0(str_sub(., 1, 5), ':00'))) / 60 >= 600, T, F
      ) & 
        (as.hms(paste0(str_sub(., 1, 5), ':00')) <= as.hms('10:10:00')) &
        (as.hms(paste0(str_sub(., nchar(.)-4, nchar(.)), ':00')) >= as.hms('20:00:00'))
    ) %>% 
    mutate(Freq_Work = rowSums(., na.rm = T), Money_Work = Freq_Work * 20)
  
  ## 按照规则统计非工作日的餐补情况
  df_nowork <-
    df %>%
    select(cols_nowork) %>%
    mutate_all(
      ~as.numeric(as.hms(paste0(str_sub(., nchar(.)-4, nchar(.)), ':00')) -
                    as.hms(paste0(str_sub(., 1, 5), ':00'))) / 3600 / 4
    ) %>% 
    mutate(Freq_No_Work  = rowSums(., na.rm = T),
           Freq_No_Work  = round(Freq_No_Work - 0.34 + .Machine$double.eps*1.1),
           Money_No_Work = Freq_No_Work * 20)
  
  ## 合并两个统计结果并导出
  df_end <- 
    bind_cols(df_work, df_nowork) %>%
    mutate(Freq  = Freq_Work + Freq_No_Work,
           Money = Money_Work + Money_No_Work) %>%
    select(Freq, Money) %>%
    write_excel_csv(paste0(path, '/', '餐补统计_', str_remove_all(as.character(today()), '-'), ".csv"))
  
}
canbu_summary(path = '.', 
              file = '000.xlsx', 
              work_cols = c(4,5,11,12,18,19,25,26))
})
htmlwidgets::saveWidget(p, "profile.html")
```

点击`profile.html`查看。

1.  慢的地方在于写了很多 %\>% 估计这里需要优化，合并函数。

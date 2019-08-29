
``` r
knitr::opts_chunk$set(warning = FALSE, message = FALSE, eval = F)
```

> 每个文件夹代表一个站点。

这部分代码可以使用 `matrix` 而非 `data.frame` 的类型来处理，会快很多，底层逻辑参考
[DataCamp](https://github.com/JiaxiangBU/r_code/blob/master/datacamp/ch3.md)

``` r
path_old <- "TestData"    # 原数据的路径
path_new <- "TestResult" # 整理后的文件夹所在的路径，不能是原数据的路径
```

``` r
#### 读取数据
df <- 
  tibble(
    files_path_old = file.path(path_old) %>% 
      list.files(full.names = T) %>% 
      list.files(full.names = T)
  ) %>%
  mutate(
    files_name = str_extract(files_path_old, "\\d+-.+"),
    id         = str_extract(files_name, "\\d+-\\d+"),
    path_new   = str_c(path_new, id)
  ) %>%
  unnest()
```

``` r
library(tidyverse)
all_file_path <- 
    "TestData" %>% 
    list.files(full.names = T,recursive = T)
```

``` r
dir_name_matrix <- 
    all_file_path %>% 
    dirname()
new_name_matrix <- 
    all_file_path %>% 
    basename() %>% 
    str_match('(\\d+-\\d+)-(\\d+)')
```

``` r
if (!dir.exists("TestResult")) {
    dir.create("TestResult")
}

file.path("TestResult",new_name_matrix[,2]) %>% 
    unique() %>% 
    as_tibble() %>% 
    mutate(
        create_dir = map(value
                         ,~if (!dir.exists(.)) {
                             dir.create(.)
                         }
                         )
    )

data_frame(
    old_name = all_file_path
    ,new_name = file.path("TestResult",new_name_matrix[,2],new_name_matrix[,3])
) %>% 
    mutate(
        rename_exe = 
            map2_lgl(
                old_name,new_name
                ,file.rename
            )
    )
```

使用 `file.rename` 是剪切而不是复制功能，因此效率会高。

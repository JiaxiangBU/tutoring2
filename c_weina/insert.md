insert
================

``` sql
library(tidyverse)
library(xfun)
here::here('files','181127_蔡维娜_代码问题.txt') %>% 
    read_utf8() %>% 
    str_extract_all('[A-z]{3,}\\.[A-z0-9_]+') %>% 
    unlist %>% 
    unique %>% 
    as_tibble()
```

``` sql
sqlQuery(impala,"show table stats opd.best_route_framework_cwn")
```

都compute了。

``` sql

insert overwrite opd.best_route_channels_null_cwn

...

union all

...

union all

...
```

这是你的代码结构，看起来可以分开 `insert`，降低job的消耗。

``` sql
insert overwrite opd.best_route_channels_null_cwn

...

insert write opd.best_route_channels_null_cwn
...

insert write opd.best_route_channels_null_cwn

...
```

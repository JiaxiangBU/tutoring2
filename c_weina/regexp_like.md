regexp\_like
================
Jiaxiang Li
2019-03-15

``` r
library(RODBC)
impala <- odbcConnect("Impala")
```

``` r
sqlQuery(impala,"with a as (
    select 'as_ddf' as x1 union all
    select 'asddf' as x1
)
select regexp_like(x1, '_')
from a")
```

    ##   regexp_like(x1, '_')
    ## 1                    1
    ## 2                    0

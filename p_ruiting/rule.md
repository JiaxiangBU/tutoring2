整理短信的规则
================

``` sql
select 
    content
from t181115_subsetmainsms_ljx
order by rand(123)
limit 100
```

``` r
library(rebus)
```

``` r
or('http','cn')
```

    ## <regex> (?:http|cn)

``` r
START %R%
    '【' %R%
    one_or_more(ANY_CHAR) %R%
    '】'
```

    ## <regex> ^【[.]+】

``` r
'额度'
```

    ## [1] "额度"

``` r
'\\d{4,}'
```

    ## [1] "\\d{4,}"

`(?:http|cn)`

``` sql
select content
from xyjl.t181115_subsetmainsms_ljx
where
    regexp_like(content,'(?:http|cn)')
    and regexp_like(content,'额度')
    and regexp_like(content,'\\d{4,}')
    and !regexp_like(content,'审核')
order by rand(123)
```

``` sql
select 
    avg(
        regexp_like(content,'(?:http|cn)')
        and regexp_like(content,'额度')
        and regexp_like(content,'\\d{4,}')
        -- and !regexp_like(content,'审核')
        -- 干扰很少
    )
from xyjl.t181115_subsetmainsms_ljx
```

之后处理短信的规则

1.  `avg(A and B and C and !D)` \> 5%
2.  `rand(123)` 100个，查看准确率
3.  `avg(A and B and C and !D and E)` \> 5%

-----

1.  第52周
    1.  周一
    2.  总结成交、营销短信的主要规则，次要规则归档 (5%)
    3.  开始做分析类训练 (R)
2.  第1-2周
    1.  开始训练 50% + 分析 50%
3.  第3-4周
    1.  出分析结果

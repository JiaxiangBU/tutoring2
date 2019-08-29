code log
================

``` r
knitr::opts_chunk$set(warning = FALSE, message = FALSE)
```

### 2018-12-21 19:05:14

1.  申请Gitlab，找运维开权限
2.  神策数据，找余果，找表的研发，找我帮忙，问impala有没有表
3.  李昊，开权限，**周一**，读特定表的权限

更新

### 2018-12-19 11:46:55

messagetime记录错误的是主营短信，目前我看了信用精灵的短信，没有记错的情况

``` r
library(RODBC)
impala <- odbcConnect("Impala")
sqlQuery(impala,"
select 
    sum(
        cast(now() as string) < messagetime
    )
    ,avg(
        cast(now() as string) < messagetime
    )
from opd.t181115_subsetxyjlSms_ljx
         ")
```

``` 
  sum(cast(now() as string) < messagetime) avg(cast(now() as string) < messagetime)
1                                        0                                        0
```

### 2018-12-13 13:25:47

这里的翻译都有问题 在 impala中

1.  `[.]` -\> `.`: `char_class = F`
2.  `[\d]` -\> `\\d`: `as.character()`查看

<!-- end list -->

``` r
library(rebus)
library(tidyverse)
'【' %R%
    one_or_more(ANY_CHAR,char_class = F) %R%
    '】'%R%
    one_or_more(ANY_CHAR,char_class = F) %R%
    or('http'
       ,'t' %R% 
           or('/','.') %R% 
           'cn'
       ) %R%
    one_or_more(or('/','.')) %R%
    optional(SPC,char_class = F) %R%
    '验证码' %R%
    optional(or('：',':'),char_class = F) %R%
    repeated(DGT,1,4,char_class = F) %>% 
    as.character()
```

    ## [1] "【.+】.+(?:http|t(?:/|.)cn)(?:/|.)+\\s?验证码(?:：|:)?\\d{1,4}"

``` sql
-- 正则化验证
select regexp_like(
    '【快贷】新产品，5000元额度已入您的账户，3日有效，请尽快查收！戳 https://12i.cn/GdEnsq 验证码：1退订回T'
    ,'【.+】.+(?:http|t(?:/|.)cn)(?:/|.)+\\s?验证码(?:：|:)?\\d{1,4}'
)
```

``` sql
select 
    sum(
        regexp_like(content,'http|t\\.cn') 
        and regexp_like(content,'退订') 
        and regexp_like(content,'【.+】.+(?:http|t(?:/|.)cn)(?:/|.)+\\s?验证码(?:：|:)?\\d{1,4}')
        )
    /sum(
        regexp_like(content,'http|t\\.cn') 
        and regexp_like(content,'退订')
        )
from opd.t181204_smsAddCompany_ljx
-- 0.008758495443115662
-- 比例很少
```

### 2018-12-12 15:11:38

rebus 使用举例

``` r
library(rebus)
```

``` r
optional('(') %R%
    repeated(DGT,3) %R%
    optional(')') %R%
    char_class("-.() ") %R%
    repeated(DGT,3) %R%
    char_class("-.() ") %R%
    repeated(DGT,4)
```

    ## <regex> [(]?[\d]{3}[)]?[-.() ][\d]{3}[-.() ][\d]{4}

``` r
one_or_more(ANY_CHAR) %R%
    '验证码' %R%
    # or(DGT,repeated(DGT,6),repeated(DGT,8))
    or(repeated(DGT,1,6),repeated(DGT,8))
```

    ## <regex> [.]+验证码(?:[\d]{1,6}|[\d]{8})

### 2018-12-12 14:02:30

1.  How to count
2.  combine logic

<!-- end list -->

``` sql
SELECT 
    count(1)
    ,b.company_clean
FROM xyjl.t181115_subsetmainsms_ljx a
INNER JOIN [shuffle] xyjl.wd_7 b
ON a.content= b.content
WHERE messagetime>='2018-09-01'
    AND messagetime<='2018-11-30'
group by
```

### 2018-12-06 16:41:00

``` sql
select*
from
(select * 
from xyjl.t181115_subsetmainsms_ljx
where messagetime>='2018-05-30' and messagetime<='2018-11-30'
--and convert(char(8),messagetime,108)>='22:30:00' and convert(char(8),messagetime,108)<='23:00:00'
order by user_id) a
where content like '%注册%'
limit 1000

-- 加xyjl 库名
-- from (...) 加 alias，无论是with 还是 from 格式
```

### 2018-12-06 15:49:46

group by + count

``` git
with a as (
    select 1 as x1 union all
    select 2 as x1 union all
    select 3 as x1 union all
    select 4 as x1 union all
    select 5 as x1 union all
    select 3 as x1
)
select count(1), x1
from a
group by 2
```

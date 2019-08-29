\\ 取数
================

``` sql
select "\\u6ce8\\u518c\\u6210\\u529f" as x1
-- \u6ce8\u518c\u6210\u529f

with a as (
select "\\u6ce8\\u518c\\u6210\\u529f" as x1
)
select 
    regexp_like(
        x1
        ,"\\\\u6ce8\\\\u518c\\\\u6210\\\\u529f"
    )
from a
-- true
```

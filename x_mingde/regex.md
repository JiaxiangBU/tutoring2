
``` sql
with a as (
    select '485,2:152,0:4712,1:330' as x1 union all
    select '3302,1:4349,0:31772,3:1873' as x1
)
select 
    regexp_extract(x1,'(\\d:[\\d]+),(\\d:[\\d]+),(\\d:[\\d]+)',1) as text_01
    ,regexp_extract(x1,'(\\d:[\\d]+),(\\d:[\\d]+),(\\d:[\\d]+)',2) as text_02
    ,regexp_extract(x1,'(\\d:[\\d]+),(\\d:[\\d]+),(\\d:[\\d]+)',3) as text_03
from a
```

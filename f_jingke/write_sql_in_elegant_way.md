Write SQL Code in an elegant way
================

``` sql
select  
 F.borrower_id
 ,F.还款金额
 ,M.分案时间
 ,M.id
 ,M.owner_id
 ,M.status
 ,M.updatetime
from (
 select
  borrower_id
  ,sum(total_amount)as'还款金额'
 from tb_repayment_record
 where dun_case_id>0
  and date_format(repayment_time,'%Y-%m-%d')=date_format(current_date(),'%Y-%m-%d')
 ) as F
left join (
 select 
  A.borrower_id
  ,A.分案时间
  ,B.id
  ,B.owner_id
  ,B.status
  ,B.updatetime
 from (
  select 
   borrower_id
   ,max(inserttime) as '分案时间'
  from tb_case_allocation
  group by borrower_id
 )as A
 left join (
  select 
   id
   ,owner_id
   ,status
   ,borrower_id
   ,inserttime
   ,updatetime
  from tb_case_allocation
 ) as B
 on A.borrower_id=B.borrower_id
 ) AS M
on F.borrower_id=M.borrower_id
```

1.  `select`, `from`, `join`, `on`都是 statement，因此注意缩进

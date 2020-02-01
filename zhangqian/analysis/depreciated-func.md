
参考 <https://q.cnblogs.com/q/120407/>

    ## Warning: package 'magrittr' was built under R version 3.6.1

> 我这里测试用的`__version__ = '1.2.45'`
> 
> ``` python
> print(ts.__version__)
> ```
> 
> 应该是sina的界面升级了，导致老的url失效了！ 建议重写这个采集，可以参考老的； 因为数据结构也不一样了，json格式完全不一致。
> 所以重写是必须的。
> 
> 老的滚动新闻URL：没有取到数据，解析结果就list index out of range错误。
> <http://roll.news.sina.com.cn/interface/rollnews_ch_out_interface.php?col=43&spec=&type=&ch=03&k=&offset_page=0&offset_num=0&num=80&asc=&page=1&r=0.3724394976041019>
> 
> 新的滚动新闻URL：
> <https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2509&k=&num=50&page=1&r=0.5819635692046212>

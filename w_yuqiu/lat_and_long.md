身份证数据处理成经纬度
================
李家翔
2018-12-18

宇秋，

下周除了短信文本使用正则化处理外， 可以做一下这个工作的准备工作。 身份证数据是敏感数据，因此最好我们自己来处理。

1.  申请 Impala 账号，完成考试
    1.  参考这个[博客笔记](https://jiaxiangli.netlify.com/2017/12/04/r-impala/)
    2.  相关书可以关注 Bansal, Chauhan, and Mehrotra (2016),Capriolo, Wampler,
        and Rutherglen (2012),Du (2015) 中 SQL Query, Describe 和 Show
        命令，书籍电子版可以查看 [Library Genesis](http://gen.lib.rus.ec/)
2.  申请 Impala 库`opd`和`xyjl` 的权限
3.  处理身份证数据为经纬度数据
4.  上传本地数据到Impala中

先完成 Impala 申请权限先，这是准备工作。

-----

以下是我和余果讨论的需求，可以更好理解这个任务的目的。

余果，

周五我们讨论使用身份证信息做“合作方-用户”层面的模型。

身份证前六位是用户出生地，这个数据需要转换成经纬度来做特征变量，效果会很显著。
    我目前是找到

1.  每个身份证前六位对应的县市地址
2.  但是县市地址对应的经纬度，是需要调用地图数据的，我目前尝试了下用百度地图的API，但是发现一个免费的AK，爬取不了多少数据，县市地址大概3000多个

我了解到印尼风险那边，已经开始考虑使用用户出生地、办公地的经纬度做一些分析了，因此这个方向上应该没什么问题。

以下是需求list

1.  因此我们需要知道这些经纬度的操作，是否主营已经做过，我们可以去调用下他们的数据。
2.  我们这边研发目前是否已经在做地址翻译成经纬度的工作了？
3.  我们是否会爬取用户数据的时候加上了GPS，之后可以查看经纬度上用户的行为，比如经常在那几个地方活动，可以看出人群差异，是安居乐业型，还是长途司机的类型。

这边需要跟

1.  主营讨论下神策数据是否可用
2.  研发讨论可行性

<div id="refs" class="references">

<div id="ref-Bansal2016Apache">

Bansal, Hanish, Saurabh Chauhan, and Shrey Mehrotra. 2016. *Apache Hive
Cookbook*. Packt Publishing.

</div>

<div id="ref-capriolo2012programming">

Capriolo, Edward, Dean Wampler, and Jason Rutherglen. 2012. *Programming
Hive: Data Warehouse and Query Language for Hadoop*. " O’Reilly Media,
Inc.".

</div>

<div id="ref-du2015apache">

Du, Dayong. 2015. *Apache Hive Essentials*. Packt Publishing Ltd.

</div>

</div>

R动态页面爬虫
================
李家翔
2018-12-25

  - 2018-12-25 22:32:24  
    目前完成带cookie一个页面的爬虫。

<details>

<summary>动态代码做了一定修改</summary>

``` r
library(httr)
cookie <- ' _u_=1; gr_user_id=40f8d796-9967-4f05-b8e9-5ad94b4fdbce; Hm_lvt_7226f1398a8a1aae74384b0f7635de6f=1545374993; AlteonP=A8KeEQnySd7Wkp8OMNsQTw$$; __RequestVerificationToken=HWDlXbsh0czOhNPjLp5-CBYhP4HOM_IJwBL0FJmEScxG60_bsLhoA8EQ6pQrxO-U_ql7ohw9Ti_LUQtHmYVm-Uh8rAmHo4BVjyOTKmgybXMjHXhkwfh8RxCE2TbaXC-LWzeLDUx2G6vFuk-iLDxElw2; gr_session_id_a58d28f5fdbbcb8b=566fb47d-7fac-46a0-b63c-899eb81d0acd; gr_session_id_a58d28f5fdbbcb8b_566fb47d-7fac-46a0-b63c-899eb81d0acd=true; Hm_lpvt_7226f1398a8a1aae74384b0f7635de6f=1545394443; iplocation=%E4%B8%8A%E6%B5%B7%E5%B8%82%7C0%7C0'

headers <- c('Accept'='text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
             'Content-Type'='text/html; charset=utf-8',          
             'Referer'='http://www.pizzahut.com.cn/StoreList', 
             'Host'= 'www.pizzahut.com.cn',
             'User-Agent'='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106    
             Safari/537.36','Connection'='keep-alive',
             'cookie'=cookie)

payload<-list(
  pageIndex=1,
  pageSize=50, 
  relativeOffset=0,
  frontCategoryId=-1
)

url <- "http://www.pizzahut.com.cn/StoreList"
louwill <- POST(url,add_headers(.headers =headers),body = payload)  ##GET还是POST
# content(louwill)$result
```

</details>

> 我的想法：只需要一页的结果可以出来，然后利用for对cookie进行循环就可以。

这也是我的想法。

<details>

<summary>查看结构</summary>

参考[sohu](http://www.sohu.com/a/256181769_455817)

``` r
library(tidyverse)
louwill %>% str
```

    ## List of 10
    ##  $ url        : chr "http://www.pizzahut.com.cn/StoreList"
    ##  $ status_code: int 200
    ##  $ headers    :List of 6
    ##   ..$ cache-control      : chr "private"
    ##   ..$ content-type       : chr "text/html; charset=utf-8"
    ##   ..$ x-aspnetmvc-version: chr "4.0"
    ##   ..$ set-cookie         : chr "__RequestVerificationToken=2ZPsYdFYHA0wr9JbquttCIQc9VppKOZdCi8GPSNMokFxumg1uq9klilu09ILNKbn-pOl34P_7EfF9OIB8t4c"| __truncated__
    ##   ..$ date               : chr "Tue, 25 Dec 2018 14:27:51 GMT"
    ##   ..$ content-length     : chr "136642"
    ##   ..- attr(*, "class")= chr [1:2] "insensitive" "list"
    ##  $ all_headers:List of 1
    ##   ..$ :List of 3
    ##   .. ..$ status : int 200
    ##   .. ..$ version: chr "HTTP/1.1"
    ##   .. ..$ headers:List of 6
    ##   .. .. ..$ cache-control      : chr "private"
    ##   .. .. ..$ content-type       : chr "text/html; charset=utf-8"
    ##   .. .. ..$ x-aspnetmvc-version: chr "4.0"
    ##   .. .. ..$ set-cookie         : chr "__RequestVerificationToken=2ZPsYdFYHA0wr9JbquttCIQc9VppKOZdCi8GPSNMokFxumg1uq9klilu09ILNKbn-pOl34P_7EfF9OIB8t4c"| __truncated__
    ##   .. .. ..$ date               : chr "Tue, 25 Dec 2018 14:27:51 GMT"
    ##   .. .. ..$ content-length     : chr "136642"
    ##   .. .. ..- attr(*, "class")= chr [1:2] "insensitive" "list"
    ##  $ cookies    :'data.frame': 2 obs. of  7 variables:
    ##   ..$ domain    : chr [1:2] "www.pizzahut.com.cn" "#HttpOnly_www.pizzahut.com.cn"
    ##   ..$ flag      : logi [1:2] FALSE FALSE
    ##   ..$ path      : chr [1:2] "/" "/"
    ##   ..$ secure    : logi [1:2] FALSE FALSE
    ##   ..$ expiration: POSIXct[1:2], format: NA ...
    ##   ..$ name      : chr [1:2] "AlteonP" "__RequestVerificationToken"
    ##   ..$ value     : chr [1:2] "BfZfNwnySd6njjQV63nOdA$$" "2ZPsYdFYHA0wr9JbquttCIQc9VppKOZdCi8GPSNMokFxumg1uq9klilu09ILNKbn-pOl34P_7EfF9OIB8t4cbfkXhUx2zsor9o79CRKOKHVuprg"| __truncated__
    ##  $ content    : raw [1:136642] 0d 0a 0d 0a ...
    ##  $ date       : POSIXct[1:1], format: "2018-12-25 14:27:51"
    ##  $ times      : Named num [1:6] 0 0.0134 0.0242 0.0246 0.0246 ...
    ##   ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
    ##  $ request    :List of 7
    ##   ..$ method    : chr "POST"
    ##   ..$ url       : chr "http://www.pizzahut.com.cn/StoreList"
    ##   ..$ headers   : Named chr [1:7] "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" "text/html; charset=utf-8" "http://www.pizzahut.com.cn/StoreList" "www.pizzahut.com.cn" ...
    ##   .. ..- attr(*, "names")= chr [1:7] "Accept" "Content-Type" "Referer" "Host" ...
    ##   ..$ fields    :List of 4
    ##   .. ..$ pageIndex      : chr "1"
    ##   .. ..$ pageSize       : chr "50"
    ##   .. ..$ relativeOffset : chr "0"
    ##   .. ..$ frontCategoryId: chr "-1"
    ##   ..$ options   :List of 2
    ##   .. ..$ useragent: chr "libcurl/7.54.0 r-curl/3.2 httr/1.3.1"
    ##   .. ..$ post     : logi TRUE
    ##   ..$ auth_token: NULL
    ##   ..$ output    : list()
    ##   .. ..- attr(*, "class")= chr [1:2] "write_memory" "write_function"
    ##   ..- attr(*, "class")= chr "request"
    ##  $ handle     :Class 'curl_handle' <externalptr> 
    ##  - attr(*, "class")= chr "response"

</details>

``` r
library(rvest)
xml <- 
    read_html(louwill$content) %>%
    html_nodes('.re_RNew')
get_text <- 
    function(text){
        xml %>% 
        html_nodes(text) %>% 
        html_text()    
    }
cbind(
    get_text('.re_NameNew')
    ,get_text('.re_addr') %>% matrix(ncol = 2,byrow = T)
) %>% 
    as.data.frame() %>% 
    set_names('name','address','tel')
```

    ##                name                                  address          tel
    ## 1          龙盛餐厅      都市路3759号龙盛国际广场101-102商铺 021-54338250
    ## 2          文峰餐厅                            张扬北路809号 021-58711934
    ## 3        新都会餐厅                  莲花南路1500号新都会A座 021-33580286
    ## 4          长江餐厅                           长江西路2211号 021-33873982
    ## 5          浦星餐厅                           陈行公路2688号 021-34795198
    ## 6          龙茗餐厅                             龙茗路1024号 021-54141161
    ## 7  奉贤南方国际餐厅 南奉公路8515号南方国际购物中心一层、二层 021-33611517
    ## 8          双阳餐厅               控江路1063号华联吉买盛一层 021-65203371
    ## 9    徐泾家乐福餐厅                         沪青平公路1817号 021-59765879
    ## 10     宝山宝龙餐厅               杨南路2211号宝龙广场一层M1 021-66877013

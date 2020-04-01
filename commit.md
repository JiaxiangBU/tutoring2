
> (<span class="citeproc-not-found" data-reference-id="JiaxiangBU">**???**</span>)
> 有以下几个问题哈：
> ![image](https://user-images.githubusercontent.com/36298417/78095926-e47b4400-740a-11ea-906e-97b48bc58f8e.png)

Git bash 解决。只跑`$`

> 下面的都是在rstudio运行是吗？
> 
>     rmarkdown::render("jinxiaosong/nb2gitbook/bookdown.Rmd")
>     file.edit("jinxiaosong/nb2gitbook/build.R")
>     rstudioapi::viewer("jinxiaosong/nb2gitbook/bookdown.html")

是的。

> 你返回的链接中没有图片？
> ![image](https://user-images.githubusercontent.com/36298417/78096095-5b184180-740b-11ea-9fb9-d3b04935b2fd.png)

是 notebook 的问题，这个图片在 notebook 本身没有显示出来。

``` r
knitr::include_graphics("figure/20200401122247.png")
```

<img src="figure/20200401122247.png" width="1920" />

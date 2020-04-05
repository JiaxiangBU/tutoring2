
> 我觉得关键是你那个图其实是动态的， 所以 markdown 加载不了。 还有一种办法 我想到了 端到端的 Rmd 直接写 python
> 我可以试试

``` r
dir_tree("jinxiaosong/nb2gitbook", recurse = F)
```

    ## jinxiaosong/nb2gitbook
    ## +-- bookdown.html
    ## +-- bookdown.Rmd
    ## +-- build.R
    ## +-- libs
    ## +-- Makefile
    ## +-- nb_with_toc.ipynb
    ## +-- nb_with_toc.md
    ## +-- test_02.html
    ## +-- test_02.ipynb
    ## \-- test_02.Rmd

参考 <https://github.com/aaren/notedown>

``` bash
$ notedown jinxiaosong/nb2gitbook/test_02.ipynb --to markdown --strip > jinxiaosong/nb2gitbook/test_02.md
```

``` r
file_move("jinxiaosong/nb2gitbook/test_02.md", "jinxiaosong/nb2gitbook/test_02.Rmd")
```

```` r
read_lines("jinxiaosong/nb2gitbook/test_02.Rmd") %>% 
    str_replace_all("```python","```{python}") %>% 
    write_lines("jinxiaosong/nb2gitbook/test_02.Rmd")
````

``` r
c(
    read_lines("jinxiaosong/nb2gitbook/bookdown.Rmd", n_max = 22),
    read_lines("jinxiaosong/nb2gitbook/test_02.Rmd")
) %>%
    write_lines("jinxiaosong/nb2gitbook/
                ")
```

``` python
p_all = liftchart(df_raw, xvars=['test_x'], yvar='y', uv=20, g=10)
p_all.render_notebook()
## <pyecharts.render.display.HTML object at 0x000000003730B978>
```

并且我使用了`self_contained: TRUE`也没用。

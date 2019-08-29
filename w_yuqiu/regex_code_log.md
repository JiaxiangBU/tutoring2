Code log
================
Jiaxiang Li
2018-12-18

``` r
strings <- c("a", "ab", "acb", "accb", "acccb", "accccb")
grep("ac+b", strings, value = TRUE)
#> [1] "acb"    "accb"   "acccb"  "accccb"
grep("ac.+b", strings, value = TRUE)
#> [1] "accb"   "acccb"  "accccb"
grep("ac.b", strings, value = TRUE)
#> [1] "accb"
```

<sup>Created on 2018-12-18 by the [reprex
package](https://reprex.tidyverse.org) (v0.2.1)</sup>

这里的

1.  `+` = `rebus::one_or_more()`
2.  `.` = `rebus::ANY_CHAR`

参考
[Cheatsheet](https://github.com/JiaxiangBU/cheatsheets_print/blob/master/strings.pdf)

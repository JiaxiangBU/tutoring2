
``` r
source(here::here("R/load.R"))
```

``` r
df <- read_excel("refs/Omega2.xlsx")
```

    ## New names:
    ## * `` -> ...1

``` r
df %>% 
    column_to_rownames("...1") %>% 
    as.matrix() -> mtr
mtr[upper.tri(mtr, diag = TRUE)] <- NA
df <- 
    mtr %>% 
    as.data.frame() %>% 
    rownames_to_column("lhs") %>% 
    gather(rhs, value, -lhs) %>% 
    na.omit()
```

``` r
df %>% head
```

    ##        lhs      rhs        value
    ## 2 F010201A F010101A 8.556040e-01
    ## 3 F010401A F010101A 2.439833e-02
    ## 4 F010601A F010101A 7.244093e-09
    ## 5 F011201A F010101A 9.276003e-03
    ## 6 F011401A F010101A 6.595367e-03
    ## 7 F011601A F010101A 1.843249e-15

``` r
get_n_unique <- function(cutoff = 0.01, df){
    df %>% 
    filter(value > cutoff) %>% 
    summarise(
        n_distinct(lhs)
    ) %>% 
    pull
}
```

``` r
map_int(list(0.01, 0.05, 0.09), get_n_unique, df = df)
```

    ## [1] 31 22 18

选出阈值最多那一个 cutoff 即可。

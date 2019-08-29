source(here::here("../imp_rmd/R/load.R")) 
read_file("wangjuan/analysis/ilets_writing_20190709.md") %>% 
    str_extract_all("\\[[A-z]+\\s?[A-z]+\\s?[A-z]+\\]", simplify = TRUE) %>% 
    table()
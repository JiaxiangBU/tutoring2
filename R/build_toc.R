

# source ------------------------------------------------------------------

source(here::here("R/load.R"))

pattern_path <- "\\.(md|ipynb|html)$"
ignore_list <- ""
path_df <-
    dir_info(here::here(), recurse = TRUE, regexp = pattern_path) %>%
    select(path, modification_time)

source(here::here("R/get_title.R"))

library(projmgr)
library(lubridate)

# html --------------------------------------------------------------------




html_df <-
    path_df %>%
    filter(basename(path) %>% str_detect("\\.html$")) %>%
    mutate(title = map_chr(path, safely_get_html_title)) %>%
    mutate(
        publish_path = path %>% str_replace(here::here(), "https://jiaxiangbu.github.io/tutoring/")
    )


# ipynb -------------------------------------------------------------------



ipynb_pattern <- "\\.ipynb$"

ipynb_df <-
    path_df %>%
    filter(basename(path) %>% str_detect(ipynb_pattern)) %>%
    mutate(title = map_chr(path, prettify_file_path, regex_pattern = ipynb_pattern)) %>%
    mutate(
        publish_sub_path = path %>% str_remove(here::here()) %>%
            str_remove("^/") %>%
            str_replace_all("/", "%2F"),
        publish_root_path = "https://mybinder.org/v2/gh/JiaxiangBU/tutoring/master?filepath=",
        publish_path = paste0(publish_root_path, publish_sub_path)
        
    )


# md ----------------------------------------------------------------------



md_pattern <- "\\.md$"

md_df <-
    path_df %>%
    filter(basename(path) %>% str_detect(md_pattern)) %>%
    mutate(title = map_chr(path, safely_get_md_title, md_pattern = md_pattern)) %>%
    mutate(
        publish_path = path %>%
            str_replace(here::here(), "https://jiaxiangbu.github.io/tutoring/") %>%
            str_remove(md_pattern)
    )



# tmp_toc -----------------------------------------------------------------

tmp_toc_df <-
    bind_rows(html_df, ipynb_df, md_df) %>%
    mutate(
        owner_name = path %>% dirname() %>% str_remove(here::here()) %>% str_to_title(),
        owner_path = path %>% str_replace(
            here::here(),
            "https://github.com/JiaxiangBU/tutoring/tree/master/"
        )
    ) %>%
    mutate(md_link = glue(
        "1. [{title}]({publish_path}) ([{owner_name}]({owner_path}))"
    ))
    

# github issue ------------------------------------------------------------

repo <- create_repo_ref("JiaxiangBU", "tutoring")
issue_list <- get_issues(repo, state = "all") %>% parse_issues()
issue_df <-
    issue_list %>%
    as_tibble() %>%
    rename(publish_path = url) %>%
    mutate(modification_time = as_datetime(updated_at)) %>% 
    mutate(
        owner_name = user_login,
        owner_path = glue("https://github.com/users/{user_login}")
    )



# toc ---------------------------------------------------------------------

tmp_toc_df2 <-
    tmp_toc_df %>%
    select(md_link, modification_time)
tmp_issue_df2 <-
    issue_df %>%
    # select(owner_name, owner_path, title, publish_path) %>% 
    # .$owner_path
    transmute(
        md_link = glue("1. [{title}]({publish_path}) ([{owner_name}]({owner_path}))"),
        modification_time
    )

toc_df <-
    bind_rows(tmp_toc_df2, tmp_issue_df2) %>% arrange(desc(modification_time))

# source ------------------------------------------------------------------
devtools::load_all()

repo_name <- "tutoring2"
pattern_path <- "\\.(md|ipynb|html)$"
ignore_list <- ""
path_df <-
    dir_info(here::here(), recurse = TRUE, regexp = pattern_path) %>%
    select(path, modification_time)

# html --------------------------------------------------------------------

html_pattern <- "\\.html$"

html_df <-
    path_df %>%
    subset_by_type(html_pattern) %>%
    mutate(title = map_chr(path, safely_get_html_title)) %>%
    mutate(publish_path = path %>% str_replace(
        here::here(),
        glue::glue("https://jiaxiangbu.github.io/{repo_name}/")
    ))

# ipynb -------------------------------------------------------------------

ipynb_pattern <- "\\.ipynb$"

ipynb_df <-
    path_df %>%
    subset_by_type(ipynb_pattern) %>%
    mutate(title = map_chr(path, prettify_file_path, regex_pattern = ipynb_pattern)) %>%
    mutate(
        publish_sub_path = path %>% str_remove(here::here()) %>%
            str_remove("^/") %>%
            str_replace_all("/", "%2F"),
        publish_root_path = "https://mybinder.org/v2/gh/JiaxiangBU/tutoring2/master?filepath=",
        publish_path = paste0(publish_root_path, publish_sub_path)

    )

# md ----------------------------------------------------------------------

md_pattern <- "\\.md$"

md_df <-
    path_df %>%
    subset_by_type(md_pattern) %>%
    mutate(title = map_chr(path, safely_get_md_title, md_pattern = md_pattern)) %>%
    mutate(
        publish_path = path %>%
            str_replace(here::here(), "https://jiaxiangbu.github.io/tutoring2/") %>%
            str_remove(md_pattern)
    )



# tmp_toc -----------------------------------------------------------------

tmp_toc_df <-
    bind_rows(html_df, ipynb_df, md_df) %>%
    mutate(
        owner_name = path %>% dirname() %>% str_remove(here::here()) %>% str_to_title(),
        owner_path = path %>% str_replace(
            here::here(),
            "https://github.com/JiaxiangBU/tutoring2/tree/master/"
        )
    ) %>%
    mutate(md_link = glue(
        "1. [{title}]({publish_path}) (\[@{owner_name}]({owner_path}))"
    ))


# github issue ------------------------------------------------------------

issue_df <- get_issue_list(repo_name = "tutoring")
issue_df2 <- get_issue_list(repo_name = "tutoring2")

# toc ---------------------------------------------------------------------

tmp_toc_df2 <-
    tmp_toc_df %>%
    select(md_link, modification_time)
tmp_issue_df2 <-
    issue_df %>%
    bind_rows(issue_df2) %>%
    transmute(
        md_link = glue(
            "1. [{title}]({publish_path}) ([\@{owner_name}]({owner_path}))"
        ),
        modification_time
    )

toc_df <-
    bind_rows(tmp_toc_df2, tmp_issue_df2) %>% arrange(desc(modification_time))


# delete something --------------------------------------------------------

toc_df <-
    toc_df %>%
    filter(
        md_link %>% str_detect("README", negate = TRUE),
        md_link %>% str_detect("utf8.md", negate = TRUE),
        md_link %>% str_detect("NEWS", negate = TRUE),
        md_link %>% str_detect("R Notebook", negate = TRUE),
        md_link %>% str_detect("commit", negate = TRUE),
        md_link %>% str_detect("LICENSE", negate = TRUE),
        md_link %>% str_detect("CODE_OF_CONDUCT", negate = TRUE)
    )

tmp_path <- "tmp"
if (!dir.exists(tmp_path)) dir.create(tmp_path)

# toc_df <- read_rds("tmp/toc_df.rds")
# toc_df %>% class
# toc_df %>% names
toc_df <-
    toc_df %>%
    filter(md_link %>% str_detect("xxx", negate = TRUE))

toc_df %>% write_rds("tmp/toc_df.rds")


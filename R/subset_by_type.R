subset_by_type <- function(df, pattern) {
    df %>%
        filter(basename(path) %>% str_detect(pattern))
}

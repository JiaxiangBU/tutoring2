get_issue_list <- function(repo_name) {
    repo <- create_repo_ref("JiaxiangBU", repo_name)
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
    return(issue_df)
}

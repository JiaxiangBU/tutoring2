rmarkdown::render("git-commit.Rmd")
library(magrittr)
readr::read_lines("git-commit.md") %>%
    clipr::write_clip(allow_non_interactive = TRUE)

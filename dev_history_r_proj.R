
# setup -------------------------------------------------------------------

library(devtools)
use_git()

use_build_ignore("dev_history_r_proj.R")
library(magrittr)

# add desc ----------------------------------------------------------------

library(usethis)
# learn from
# use_description()
desc <- usethis:::build_description()
desc <- desc::description$new(text = desc)
usethis:::tidy_desc(desc)
lines <- desc$str(by_field = TRUE, normalize = FALSE, mode = "file")
write_over(proj_path("DESCRIPTION"), lines)
if (!getOption("usethis.quiet", default = FALSE)) {
    print(desc)
}
add2pkg::add_me(is_paste = TRUE)
file.edit("DESCRIPTION")
library(tidyverse)
basename(proj_path()) %>% clipr::write_clip()


# add license -------------------------------------------------------------



options(usethis.full_name = "Jiaxiang Li")
use_cc0_license()


# add namespace -----------------------------------------------------------



use_namespace()

# coding ------------------------------------------------------------------




# prettify ----------------------------------------------------------------

if (file.exists("README.Rmd")) {
    file.rename("README.Rmd", "README-bak.Rmd")
    file.edit("README-bak.Rmd")
}
use_readme_rmd()
file.edit("README.Rmd")
file.remove("README-bak.Rmd")
rmarkdown::render("README.Rmd")
rstudioapi::viewer("README.html")
file.remove("README.html")

# add disclaimer ----------------------------------------------------------

usethis::use_code_of_conduct()
clipr::write_clip('`r add2pkg::add_disclaimer("Jiaxiang Li")`')
file.edit("README.Rmd")
rmarkdown::render("README.Rmd")
rstudioapi::viewer("README.html")
file.remove("README.html")

# add examlpes ------------------------------------------------------------

clipr::read_clip() %>%
    str_c("#' ", .) %>%
    clipr::write_clip()

clipr::read_clip() %>%
    str_c("#' \\dontrun{", ., "}") %>%
    clipr::write_clip()


# add dirs ----------------------------------------------------------------

library(tidyverse)
library(fs)
list("analysis", "output", "refs") %>% map(dir.create)


# add commit --------------------------------------------------------------

glue::glue("Add metadata

1. license
1. readme
1. namespace
1. desc") %>% clipr::write_clip()

# update explanation in README --------------------------------------------

file.edit("README.Rmd")
readme_lines <- read_lines("README.Rmd")
c(readme_lines[1:20],read_lines("../usr_reg_pred/README.Rmd")[-1:-20]) %>% write_lines("README.Rmd")
rmarkdown::render("README.Rmd")
rstudioapi::viewer("README.html")
file.remove("README.html")

# update template ---------------------------------------------------------

library(fs)
file_copy("dev_history_r_proj.R", "../dev_history/refs/dev_history_r_proj.R",
          overwrite = TRUE)
# open it!


# gitdown -----------------------------------------------------------------

gitdown::git_down(
    repo = ".",
    book_path = "gitdown",
    open = TRUE,
    author = "Jiaxiang Li",
    pattern = c("ticket[[:digit:]]+", "#[[:digit:]]+"),
    names_section = c("Ticket", "Issues"),
    ref = "master"
)

library(gitdown)
get_commits_pattern(repo, pattern = "#[[:digit:]]+", ref = "master") %>%
    select(pattern, everything())

get_commits_tags(ref = NULL)

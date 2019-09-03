# path --------------------------------------------------------------------

Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc")
setwd(usethis::proj_path())

# source ------------------------------------------------------------------


source(here::here("../imp_rmd/R/load.R"))
source(here::here("../imp_rmd/R/job_print.R"))

job_print("Job Start: ")

system("git status")
system("git pull")
# pull first if any updated

rmarkdown::render(here::here("README.Rmd"), encoding = "UTF-8")
rstudioapi::viewer("README.html")
if (file.exists("README.html")) {file.remove("README.html")}

git2r::add(path = ".")
git2r::commit(message = "automatically update")
system("git push origin master")

job_print("Job End: ")


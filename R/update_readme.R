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
if (file.exists("README.html")) {file.remove("README.html")}

system("git add -A .")
system("git commit --no-verify -m 'automatically update'")
system("git push origin master")


job_print("Job End: ")


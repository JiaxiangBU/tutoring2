prettify_file_path <- function(path, regex_pattern) {
  path %>% basename() %>% str_remove(regex_pattern) %>% str_replace_all("-|_", " ")
}



get_html_title <- function(path) {
    read_lines(path) %>% str_subset("<title>") %>%
        xml2::as_xml_document() %>%
        xml2::xml_text()
}
safely_get_html_title <- purrr::possibly(get_html_title, "")

get_md_title <- function(path, md_pattern) {
  lines <- read_lines(path)
  title_line <- lines %>% str_which("================")
  if (!is.na(title_line) && length(title_line) > 0) {
      title <- lines[(title_line-1)]
      title <- title %>% str_remove("\\\\") %>% str_trim()
  } else {
      title <- prettify_file_path(path, md_pattern)
  }
  return(title)
}
safely_get_md_title <- purrr::possibly(get_md_title, "")

# debugonce(get_md_title)
# get_md_title("D:/work/tutoring/wangjuan/analysis/extract_subelement_in_json.md", md_pattern)
# get_md_title("D:/work/tutoring/jinxiaosong/batch_create_dir.md", md_pattern)
# get_md_title("D:/work/tutoring/zhangxinyue/target.md", md_pattern)
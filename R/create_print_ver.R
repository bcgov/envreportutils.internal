# Copyright 2017 Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#' PDF specifications for EnvReportBC print version
#'
#' @param ... arguments passed on to pdf_document
#' @param keep_tex keep tex file?
#'
#' @return pdf_document specification
#' @export
print_ver <- function(..., keep_tex = FALSE) {
  
  # get the locations of resource files located within the package
  template <- get_resource("template.tex")
  gphxpath <- get_resource("img")
  
  mainfont <- "Palatino Linotype"
  headfont <- "Calibri"
  
  # call the base html_document function, passing in the template location and 
  # path to template images
  rmarkdown::pdf_document(..., template = template, keep_tex = keep_tex,
                          latex_engine = "xelatex",
                          pandoc_args = c("--variable", 
                                          paste0("mainfont=", mainfont), "--variable", 
                                          paste0("sansfont=", headfont), "--variable", 
                                          paste0("gphxpath=", gphxpath, "/")))
}

get_resource <- function(resource) {
  system.file("rmarkdown", "templates", "print_ver", "resources", resource, package = "envreportutils.internal")
}

#' Convert html text to markdown
#'
#' @param html path to the html file to convert from
#' @param md path to target md (should not exist yet)
#'
#' @import rmarkdown
#' @return an Rmd document
#' @export
html_md <- function(html, md = tempfile(fileext = "md")) {
  if (!file.exists(html)) stop("file ", html, " does not exist")
  rmarkdown::pandoc_convert(input = html, to = "markdown", 
                            output = md)
  md
}

#' Create a draft print version based on the template
#'
#' @param filename the name of the Rmd file you wish to create
#'
#' @return The filename of the new document (invisibly)
#' @export
#'
#' @examples
#' \dontrun{
#' draft_print_ver("print_ver.Rmd")
#' }
draft_print_ver <- function(filename) {
  rmarkdown::draft(file = filename, package = "envreportutils.internal", 
                   template = "print_ver", create_dir = "default", 
                   edit = TRUE)
}

#' Convert a file on the SoE wwwd site to markdown in the envreportbc 
#' rmarkdown template, and save it in the \code{print_ver} folder.
#' 
#' If there is an existing file in the \code{print_ver} folder, a backup will be 
#' created
#'
#' @param html_file the file in the soe/indicators folder on the web. Use the form
#'  \code{folder/indicator.html} (e.g., \code{"land/roads.html"})
#'
#' @return writes the file to the \code{print_ver} folder of the current project.
#' @export
web2print_ver <- function(html_file) {
  url <- paste0("http://wwwd.env.gov.bc.ca/soe/indicators/", html_file)
  tmp_html <- tempfile(fileext = ".html")
  download.file(url, destfile = tmp_html)
  on.exit(unlink(tmp_html))
  proj_dir <- rstudioapi::getActiveProject()
  dir.create(file.path(proj_dir, "print_ver"), showWarnings = FALSE)
  proj <- basename(proj_dir)
  print_ver_file <- file.path(proj_dir, "print_ver", paste0(proj, ".Rmd"))
  if (file.exists(print_ver_file)) {
    file.rename(print_ver_file, paste0(print_ver_file, ".backup", Sys.Date()))
  }
  md_file <- html_md(tmp_html, print_ver_file)
  message("Converting ", url, " to\n    ", md_file)
  fix_print_ver(md_file, bucket = strsplit(html_file, "/")[[1]][1])
  file.edit(md_file)
  invisible(md_file)
}

fix_print_ver <- function(file, bucket) {
  rmd <- readLines(file)
  body_start <- grep("::: \\{#body\\}", rmd)[1]
  body_end <- grep("^::: \\{#shareIcons}", rmd)[1]
  rmd <- rmd[body_start:(body_end - 1)]
  title_line <- grep("==========+", rmd)[1]
  title_text <- rmd[title_line - 1]
  rmd <- rmd[title_line:length(rmd)]
  first_line <- grep("^[a-zA-Z]", rmd)[1]
  rmd <- rmd[first_line:length(rmd)]
  keep_lines <- !grepl("^:::($|.*\\}$)", rmd)
  rmd <- rmd[keep_lines]
  cat("---\n", file = file)
  cat("topic: \"", bucket, "\"\n", file = file, sep = "", append = TRUE)
  cat("title: \"", title_text, "\"\n", file = file, sep = "", append = TRUE)
  cat("output: envreportutils.internal::print_ver\n", file = file, append = TRUE)
  cat("---\n\n", file = file, append = TRUE)
  cat("<--! This dump from the html on the wwwd site will have lots of leftover tags
      and require formatting and cleaning up -->\n\n", file = file, append = TRUE)
  cat(rmd, file = file, sep = "\n", append = TRUE)
}

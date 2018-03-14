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

# #'Create a print version starter based on the template
# #'
# #'<full description of function>
# #'
# #' @param html Path to the html file to convert from
# #' @param name Short name which will form the base name of the .Rmd file
# #' @param dir Folder in which to place resulting .Rmd file. Default is 
# #'  \code{print_ver} inside the current working directory
# #' @param bucket the indicator topic. Required if html is \code{NULL}.
# #' @param title the indicator title. Required if html is \code{NULL}.
# #' @export
# create_print_ver <- function(html = NULL, name = NULL, dir = "print_ver", bucket = NULL, title = NULL) {
#   
#   if (is.null(name)) {
#     name <- basename(getwd())
#     message("Using the name of the current folder as the filename, since none was specified")
#   }
#   
#   if (!file.exists(dir)) {
#     dir.create(dir)
#   }
#   
#   filepath <- file.path(dir, paste0(name, ".Rmd"))
#   
#   if (file.exists(filepath)) {
#     stop(paste0("File ", filepath, " already exists"))
#   }
#   
#   if (is.null(html)) {
#     if (is.null(title) || is.null(bucket)) stop("You must specify a bucket and a title")
#     buckets <- get_buckets()
#     bucket <- buckets[match(tolower(bucket), tolower(buckets))]
#     if (is.na(bucket)) stop("Bucket must be one of ", paste(buckets, collapse = ", "))
#     main_content <- ""
#   } else {
#     md <- html_md(html)
#     lines <- readLines(md)
#     sections <- md_sections(lines)
#     bucket <- sections$bucket
#     title <- sections$title
#     main_content <- lines[sections$start:sections$end]
#   }
#   
#   header_content <- c("---", 
#                       paste0("title: ", bucket), 
#                       paste0("subtitle: ", title), 
#                       "bibliography: example.bib", 
#                       paste0("output:"),
#                       paste0("  pdf_document:"), 
#                       paste0("    template: D:/templates/print_ver_template.tex"), 
#                       "---")
#   
#   instructions <- "
# <!--
# Instructions:
# 
# The text will be littered with divs etc. You will need to remove them and 
# replace them with knitr code chunks in the appropriate places.
# 
# If you don't have a bibliography, delete the bibliography line in the YAML header.
# If you do have a bibliography, insert the filename. In-text citations are done as:
# [@Moe-etal-1999]. End the document with the bibliography heading (e.g., # References).
# -->"
#   
#   conn <- file(filepath, open = "w")
#   
#   writeLines(header_content, conn)
#   writeLines(instructions, conn)
#   writeLines(main_content, conn)
#   
#   close(conn)
#   
#   filepath
# }

# md_sections <- function(lines) {
#   bucket_line <- grep("\\{\\.bucket", lines)
#   bucket <- parse_bucket(lines[bucket_line])
#   h2_lines <- grep("------", lines)
#   title_line <- min(h2_lines[h2_lines > bucket_line] - 1)
#   start <- title_line + 2
#   title <- lines[title_line]
#   end <- find_end(lines)
#   list(start = start, bucket = bucket, title = title, end = end)
# }
# 
# find_end <- function(lines) {
#   updated_line <- grep("^Updated\\s+[A-Z][a-z]{2,8}\\s+\\d{4}", lines)
#   end <- updated_line + 1
#   end
# }

# parse_bucket <- function(bucket) {
#   bucket <- strsplit(bucket, "bucket|\\}")[[1]][2]
#   if (bucket == "Land") {
#     bucket <- "Land and Forests"
#   } else if (bucket == "PlantsAndAnimals") {
#     bucket <- "Plants and Animals"
#   } else if (bucket == "Climate") {
#     bucket <- "Climate Change"
#   }
#   bucket
# }

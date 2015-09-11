#'Create a print version starter based on the template
#'
#'<full description of function>
#'
#'@param html Path to the html file to convert from
#'@param name Short name which will form the base name of the .Rmd file
#'@param dir Folder in which to place resulting .Rmd file. Default is
#'  /code{print_ver} inside the current working directory
#'@export
#' @examples \donttest{
#'
#'}
create_print_ver <- function(html = NULL, name = NULL, dir = "print_ver") {
  
  if (is.null(name)) {
    name <- basename(getwd())
    message("Using the name of the current folder as the filename, since none was specified")
  }
  
  if (!file.exists(dir)) {
    dir.create(dir)
  }
  
  filepath <- file.path(dir, paste0(name, ".Rmd"))
  
  if (file.exists(filepath)) {
    stop(paste0("File ", filepath, " already exists"))
  }
  
  md <- html_md(html)
  lines <- readLines(md)
  sections <- md_sections(lines)
  
  header_content <- c("---", 
                      paste0("title: ", sections$bucket), 
                      paste0("subtitle: ", sections$title), 
                      "bibliography: example.bib", 
                      paste0("output:"),
                      paste0("  pdf_document:"), 
                      paste0("    template: D:/templates/print_ver_template.tex"), 
                      "---")
  
  instructions <- "
<!--
Instructions:

The text will be littered with divs etc. You will need to remove them and 
replace them with knitr code chunks in the appropriate places.

If you have a bibliography, insert the filename. In-text citations are done as:
[@Moe-etal-1999]. End the document with the bibliography heading (e.g., # References).
-->"
  
  main_content <- lines[sections$start:sections$end]
  
  conn <- file(filepath, open = "w")
  
  writeLines(header_content, conn)
  writeLines(instructions, conn)
  writeLines(main_content, conn)
  
  close(conn)
  
  filepath
}

#' Convert html text to Rmd for print version
#'
#' @param html path to the html file to convert from
#' @param rmd path to target rmd (should not exist yet)
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

md_sections <- function(lines) {
  bucket_line <- grep("\\{\\.bucket", lines)
  bucket <- parse_bucket(lines[bucket_line])
  h2_lines <- grep("------", lines)
  title_line <- min(h2_lines[h2_lines > bucket_line] - 1)
  start <- title_line + 2
  title <- lines[title_line]
  end <- find_end(lines)
  list(start = start, bucket = bucket, title = title, end = end)
}

find_end <- function(lines) {
  updated_line <- grep("^Updated\\s+[A-Z][a-z]{2,8}\\s+\\d{4}", lines)
  end <- updated_line + 1
  end
}

parse_bucket <- function(bucket) {
  bucket <- strsplit(bucket, "bucket|\\}")[[1]][2]
  if (bucket == "Land") {
    bucket <- "Land and Forests"
  } else if (bucket == "PlantsAndAnimals") {
    bucket <- "Plants and Animals"
  } else if (bucket == "Climate") {
    bucket <- "Climate Change"
  }
  
  bucket
}

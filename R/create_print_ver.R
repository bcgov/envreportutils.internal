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
  
  md <- html_md(html)
  
  lines <- readLines(md)
  sections <- md_sections(lines)
  
  if (!file.exists(dir)) {
    dir.create(dir)
  }
  
  filepath <- file.path(dir, paste0(name, ".Rmd"))
  
  if (file.exists(filepath)) {
    stop(paste0("File ", filepath, " already exists"))
  }
  
  writeLines(c("---", 
               paste0("title: ", bucket), 
               "subtitle: Insert indicator title here", 
               "bibliography: example.bib", 
               paste0("output:"),
               paste0("  pdf_document:"), 
               paste0("    template: D:/templates/print_ver_template.tex"), 
               "---", 
               "
<!--
Instructions:

Set title as one of: Air, Climate Change, Contaminants, Forests, Land, 
                     Plants and Animals, Sustainability, Waste, Water

Set subtitle as the indicator title (e.g., 'Trends in Tar Ball deposition in BC (1876-1921)')

If you have a bibliography, insert the filename. In-text citations are done as:
[@Moe-etal-1999]. End the document with the bibliography heading (e.g., # References).
-->"
  ), filepath)
  
  invisible(TRUE)
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

cat(lines[start:end], sep = "\n", file = file.path(out_dir, out_file))

md_sections <- function(lines) {
  bucket_line <- grep("\\{\\.bucket", lines)
  bucket <- strsplit(lines[bucket_line], "bucket|\\}")[[1]][2]
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

#'Create a print version starter based on the template
#'
#'<full description of function>
#'
#'@param  bucket Indicator topic (one of Air, Climate Change, Contaminants, 
#'  Forests, Land, Plants and Animals, Sustainability, Waste, Water)
#'@param  name Short name which will form the base name of the .Rmd file
#'@param  dir Folder in which to place resulting .Rmd file. Default is
#'  /code{print_ver} inside the current working directory
#'@export
#' @examples \donttest{
#'
#'}
create_print_ver <- function(bucket = NULL, name = NULL, dir = "print_ver") {
  
  bucket <- paste0(toupper(substring(bucket, 1, 1)), substring(bucket, 2))
  if (!bucket %in% c("Air", "Climate Change", "Contaminants", "Forests", "Land", 
                     "Plants and Animals", "Sustainability", "Waste", "Water")) {
    stop("Invalid topic name supplied to 'bucket'. Print version not created.", call. = FALSE)
  }
  
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
#' @param html 
#' @param rmd 
#'
#' @import rmarkdown
#' @return an Rmd document
#' @export
html_rmd <- function(html, rmd) {
  if (!file.exists(html)) stop("file ", html, " does not exist")
  if (file.exists(rmd)) cat_text <- TRUE else cat_text <- FALSE
  out_dir <- normalizePath(dirname(rmd), winslash = "/")
  out_file <- basename(rmd)
  rmarkdown::pandoc_convert(input = html, to = "markdown", 
                            output = file.path(out_dir, out_file))
  lines <- readLines(file.path(out_dir, out_file))
  start <- find_start(lines)
  end <- find_end(lines)
  cat(lines[start:end], sep = "\n", file = file.path(out_dir, out_file))
}

find_start <- function(lines) {
  bucket_line <- grep("\\{\\.bucket", lines)
  h2_lines <- grep("------", lines)
  title_line <- min(h2_lines[h2_lines > bucket_line])
  start <- title_line - 1
  start
}

find_end <- function(lines) {
  updated_line <- grep("^Updated\\s+[A-Z][a-z]{2,8}\\s+\\d{4}", lines)
  end <- updated_line + 1
  end
}

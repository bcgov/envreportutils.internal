#' Create a print version starter based on the template
#'
#' <full description of function>
#'
#' @param  bucket Indicator topic (one of Air, Climate Change, Contaminants, 
#'         Forests, Land, Plants and Animals, Sustainability, Waste, Water)
#' @param  name Short name which will form the base name of the .Rmd file
#' @param  dir Folder in which to place resulting .Rmd file
#' @export
#' @examples \donttest{
#'
#'}
create_print_ver <- function(bucket = NULL, name = NULL, dir = "print_ver") {
  
  if (!bucket %in% c("Air", "Climate Change", "Contaminants", "Forests", "Land", 
                     "Plants and Animals", "Sustainability", "Waste", "Water")) {
    stop("Invalid topic name supplied to 'bucket'", call. = FALSE)
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
    stop(paste0("File ", filepath, " already exists")
  }
  
  writeLines(c("---", 
               paste0("title: ", bucket), 
               "subtitle: Insert indicator title here", 
               "bibliography: example.bib", 
               paste0("output:"),
               paste0("  pdf_document:"), 
               paste0("    template: I:/SPD/Science Policy & Economics/State of Environment/_dev/templates/print_ver_template.tex"), 
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
}

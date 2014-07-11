#' Create a print version starter based on the template
#'
#' <full description of function>
#'
#' @param  bucket Indicator topic (one of Air, Climate Change, Contaminants, 
#'         Forests, Land, Plants and Animals, Sustainability, Waste, Water)
#' @param  name Short name which will form the base name of the .Rmd file
#' @param  path Folder in which to place resulting .Rmd file
#' @export
#' @examples \donttest{
#'
#'}
create_print_ver <- function(bucket = NULL, name = NULL, path = "print_ver") {
  
  if (!bucket %in% c("Air", "Climate Change", "Contaminants", "Forests", "Land", 
                     "Plants and Animals", "Sustainability", "Waste", "Water")) {
    stop("Invalid topic name supplied to 'bucket'", call. = FALSE)
  }
  
  if (is.null(title)) {
    stop("You must specify a title for the print version")
  }
  
  if (!file.exists(path)) {
    dir.create(path)
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
  ), file.path(path, paste0(name, ".Rmd")))
}

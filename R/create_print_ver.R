#' Create a print version starter based on the template
#'
#' <full description of function>
#'
#' @param  bucket Indicator topic (one of Air, Climate Change, Contaminants, 
#'         Forests, Land, Plants and Animals, Sustainability, Waste, Water)
#' @param  title Title of the indicator
#' @param  path path and filename of the resulting .Rmd file
#' @export
#' @examples \dontrun{
#'
#'}
create_print_ver <- function(bucket, title, path) {
  if (!bucket %in% c("Air", "Climate Change", "Contaminants", "Forests", "Land", 
                     "Plants and Animals", "Sustainability", "Waste", "Water")) {
    stop("Invalid topic name supplied to 'bucket'", call. = FALSE)
  }
  
  writeLines(c("---", 
               paste0("title: ", bucket), 
               paste0("subtitle: ", title), 
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

Set subtitle as the indicator title

If you have a bibliography, insert the filename. In-text citations are done as:
[@Moe-etal-1999]. End the document with the bibliography heading (e.g., # References).
-->"
  ), path)
}

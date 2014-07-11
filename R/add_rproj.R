#' Add an RProject file to a directory
#'
#' <full description of function>
#'
#' @param  path folder path of the project
#' @export
#' @examples \dontrun{
#'
#'}
add_rproj <- function(path) {
  path <- file.path(path, paste0(basename(path), ".Rproj"))
  if (file.exists(path)) {
    stop(".Rproj already exists", call. = FALSE)
  }
  message("Adding Rstudio project file to ", basename(path))
  template_path <- system.file("templates/template.Rproj", 
                               package = "envreportbc")
  file.copy(template_path, path)
  invisible(TRUE)
}

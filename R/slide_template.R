#' Create a slide presentation from template
#'
#' @param title Short title of the presentation
#' @param path where do you want to put it? (default current directory)
#'
#' @return TRUE (invisibly)
#' @export
#'
#' @examples
#' slide_template("my_pres", path = "presentation")
slide_template <- function(title, path = ".") {
  if (missing(title)) stop("You must specify a title")
  add_file_from_template(path, 
                        fname = "io_presentation/presentation_template.Rmd", 
                        outfile = paste0(title, ".Rmd"))
  add_file_from_template(file.path(path, "css"), 
                         fname = "io_presentation/css/envreportbc-style.css", 
                         outfile = "envreportbc-style.css")
  add_file_from_template(file.path(path, "img"), 
                         fname = "io_presentation/img/EnvironmentalReportingBC_logo.png", 
                         outfile = "EnvironmentalReportingBC_logo.png")
  invisible(TRUE)
}

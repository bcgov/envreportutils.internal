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
  envreportutils:::add_file_from_template(path, 
                        fname = "io_presentation/presentation_template.Rmd", 
                        outfile = paste0(title, ".Rmd"))
  envreportutils:::add_file_from_template(file.path(path, "css"), 
                         fname = "io_presentation/css/envreportbc-style.css", 
                         outfile = "envreportbc-style.css")
  
  pngs <- c("BC_MoE_logo.png", "come-in-open.png", "databc.png", 
            "EnvironmentalReportingBC_logo.png", "envreportbc-github.png", 
            "pause_sink_dataviz.png", "rising-value.png", "SoE_books.png", 
            "state-salish-sea.png", "unep-soe_gateway.png")
  
  pngs <- file.path("io_presentation/img", pngs)
  
  lapply(pngs, function(png) {
    envreportutils:::add_file_from_template(file.path(path, "img"), 
                                            fname = png, 
                                            outfile = basename(png))
  })

  invisible(TRUE)
}

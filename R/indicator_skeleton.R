#' Creates the framework of a new indicator development folder
#'
#' Creates the folder structure for a new indicator, including a template for 
#' the printable version RMarkdown document.
#'
#' @import devtools
#' @param  path location to create new indicator
#' @param  print_ver create a print version template?
#' @param  bucket (required if print_ver = \code{TRUE}) Indicator topic (one of 
#'         Air, Climate Change, Contaminants, Forests, Land, Plants and Animals, 
#'         Sustainability, Waste, Water)
#' @param  title (required if print_ver = \code{TRUE}) Title of the indicator
#' @param  rstudio Create an Rstudio project file?
#' @export
#' @examples \dontrun{
#' indicator_skeleton(path = "c:/_dev/tarballs", print_ver = TRUE, 
#'                    bucket="Contaminants", 
#'                    title="Trends in Tar Ball deposition in BC (1876-1921)", 
#'                    rstudio = TRUE)
#'}
indicator_skeleton <- function (path, print_ver = TRUE, bucket, title, rstudio = FALSE) {  
  name <- basename(path)
  message("Creating indicator ", name, " in ", dirname(path))
  
  if (file.exists(path)) {
    stop("Directory already exists", call. = FALSE)
  }
  
  if (!file.exists(dirname(path))) {
    stop("Parent directory does not exist.", call. = FALSE)
  }
  
  dir.create(path)
  
  file.create(file.path(path, "01_load.R"), file.path(path, "02_clean.R"), 
              file.path(path, "03_analysis.R"), file.path(path, "04_output.R"))
  
  dir.create(file.path(path, "data"))
  dir.create(file.path(path, "out"))
  dir.create(file.path(path, "doc"))
  
  if (print_ver) {
    print_ver_path <- file.path(path, "print_ver")
    dir.create(print_ver_path)
    create_print_ver(bucket = bucket, title = title, 
                     path = file.path(print_ver_path, paste0(name, ".Rmd")))
  }
  
  if (rstudio) {
    add_rstudio_project(path)
  }
  
  invisible(TRUE)
}

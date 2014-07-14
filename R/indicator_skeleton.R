#' Creates the framework of a new indicator development folder
#'
#' Creates the folder structure for a new indicator, including a template for 
#' the printable version RMarkdown document.
#'
#' @param  path location to create new indicator
#' @param  print_ver create a print version template?
#' @param  bucket (required if print_ver = \code{TRUE}) Indicator topic (one of 
#'         Air, Climate Change, Contaminants, Forests, Land, Plants and Animals, 
#'         Sustainability, Waste, Water)
#' @param  rstudio Create an Rstudio project file?
#' @export
#' @examples \donttest{
#' indicator_skeleton(path = "c:/_dev/tarballs", print_ver = TRUE, 
#'                    bucket="Contaminants", 
#'                    title="Trends in Tar Ball deposition in BC (1876-1921)", 
#'                    rstudio = TRUE)
#'}
indicator_skeleton <- function (path = ".", print_ver = TRUE, bucket, rstudio = FALSE) {  
  
  if (path == ".") {
    path <- getwd()
  } else {
    
    if (file.exists(path)) {
      stop("Directory already exists", call. = FALSE)
    }
    
    if (!file.exists(dirname(path))) {
      stop("Parent directory does not exist.", call. = FALSE)
    }
    
    dir.create(path)
  }

  files <- c(file.path(path, "01_load.R"), file.path(path, "02_clean.R"), 
             file.path(path, "03_analysis.R"), file.path(path, "04_output.R"))
  
  dirs <- c(file.path(path, "data"), file.path(path, "out"), file.path(path, "doc"))
  
  if (any(file.exists(files, dirs))) {
    stop("It looks as though you already have an indicator set up here")
  }
  
  name <- basename(path)
  
  message("Creating indicator ", name, " in ", dirname(path))
  
  file.create(files)
  
  lapply(dirs, dir.create)
  
  if (print_ver) {
    create_print_ver(bucket = bucket, name = basename(path), dir = file.path(path, "print_ver"))
  }
  
  if (rstudio) {
    add_rproj(path)
  }
  
  invisible(TRUE)
}

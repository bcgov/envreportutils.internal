#' Creates the framework of a new indicator development folder
#' 
#' Creates the folder structure for a new indicator.
#' @importFrom envreportutils analysis_skeleton
#' @param path location to create new indicator. If \code{"."} (the default), 
#'   the name of the working directory will be taken as the indicator name. If 
#'   not \code{"."}, the last component of the given path will be used as the 
#'   indicator name.
#' @param git_init Create a new git repository? Logical, default \code{TRUE}.
#' @param git_clone the url of a git repo to clone.
#' @param rstudio Create an Rstudio project file?
#' @param apache Add licensing info for release under Apache 2.0? Default \code{TRUE}.
#' @param copyright_holder the name of the copyright holder (default 
#' "Province of British Columbia). Only necessary if adding a license
#' @details If you are cloning a repository (\code{git_clone = "path_to_repo"}),
#'   you should run this function from the root of your dev folder and leave 
#'   \code{path = "."}, as the repository will be cloned into a new folder. If 
#'   you are setting up a new project (with or without git), \code{path} should 
#'   be \code{"."} if you are within an already created project directory, or 
#'   the name of the folder you want to create.
#'   
#'   You can see more examples in the package vignette. Type
#'   \code{browseVignettes("envreportbc")} to view it.
#' @export
#'  @examples \donttest{
#'  indicator_skeleton(path = "c:/_dev/tarballs")
#' }
indicator_skeleton <- function(path = ".", git_init = TRUE, 
                               git_clone = NULL, rstudio = TRUE, apache = TRUE, 
                               copyright_holder = "Province of British Columbia") {
  
  analysis_skeleton(path = path, git_init = git_init, git_clone = git_clone, 
                    rstudio = rstudio, apache = apache, 
                    copyright_holder = copyright_holder)
  
  invisible(TRUE)
}

# Function to be executed on error, to clean up files already created
# error_cleanup <- function(t) {
#   info <- file.info(list.files(all.files = TRUE, include.dirs = TRUE, no.. = TRUE))
#   del_files <- rownames(info[t < info$ctime, ])
#   cat("Deleting generatedfiles:", del_files)
#   unlink(del_files, recursive = TRUE, force = TRUE)
# }

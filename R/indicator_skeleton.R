#' Creates the framework of a new indicator development folder
#' 
#' Creates the folder structure for a new indicator, including a template for 
#' the printable version RMarkdown document.
#' 
#' @param  path location to create new indicator. If \code{"."} (the default), 
#'   the name of the working directory will be taken as the indicator name. If 
#'   not \code{"."}, the last component of the given path will be used as the 
#'   indicator name.
#' @param  print_ver create a print version template?
#' @param  bucket (required if print_ver = \code{TRUE}) Indicator topic (one of 
#'   Air, Climate Change, Contaminants, Forests, Land, Plants and Animals, 
#'   Sustainability, Waste, Water)
#' @param git_init Create a new git repository? Logical, default \code{TRUE}.
#' @param git_clone the url of a git repo to clone.
#' @param  rstudio Create an Rstudio project file?
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
#'  indicator_skeleton(path = "c:/_dev/tarballs", print_ver = TRUE, 
#'                     bucket="Contaminants", 
#'                     rstudio = TRUE)
#' }
indicator_skeleton <- function (path = ".", print_ver = TRUE, bucket, git_init = TRUE, git_clone = NULL, rstudio = TRUE) {

#   now <- Sys.time()
#   options(error = quote(error_cleanup(now)))
#   on.exit(options(error = NULL), add = TRUE)
  curr_dir <- getwd()
  on.exit(setwd(curr_dir), add = TRUE)
  
  if (path != ".") {
    if (file.exists(path)) {
      stop("Directory already exists", call. = FALSE)
    } else {
      dir.create(path, recursive = TRUE)
      setwd(path)
    }
  }

  if (is.character(git_clone)) {
    clone_git(git_clone)
    git_init = FALSE
    ## clone_git will run setwd(), so need to get path again
    path <- getwd()
  }
  
  ## Need to check for indicator structure
  Rfiles <- c("01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", 
              "internal.R")
  dirs <- c("data", "out", "tmp")
  if (any(file.exists(Rfiles, dirs))) { ## file.exists is case-insensitive
    #if (git) unlink(c(".git", ".gitignore", recursive = TRUE, force = TRUE)
    stop("It looks as though you already have an indicator set up here!")
  }
  
  ## Add the necessary R files and directories
  message("Creating new indicator in ", path)
  lapply(Rfiles, file.create)
  lapply(dirs, dir.create)
  
  add_metafiles("README.md", "LICENSE")
  
  if (rstudio) {
    if (!length(list.files(pattern = "*.Rproj", ignore.case = TRUE))) add_rproj() else 
      warning("Rproj file already exists, so not adding a new one")
  }
  
  if (print_ver) {
    create_print_ver(bucket = bucket, name = basename(path), 
                     dir = "print_ver")
  }
  
  if (git_init) {
    if (file.exists(".git")) {
      warning("This directory is already a git repository. Not creating a new one")
    } else {
      system("git init")
    }
  }
  
  if (git_init || is.character(git_clone)) {
    write_gitignore(".Rproj.user", ".Rhistory", ".RData", "out/", "tmp/", 
                    "internal.R", "print_ver/*.pdf")
  }
  
  invisible(TRUE)
}

# Function to be executed on error, to clean up files already created
error_cleanup <- function(t) {
  info <- file.info(list.files(all.files = TRUE, include.dirs = TRUE, no.. = TRUE))
  del_files <- rownames(info[t < info$ctime, ])
  cat("Deleting generatedfiles:", del_files)
  unlink(del_files, recursive = TRUE, force = TRUE)
}


# Git functions -----------------------------------------------------------

clone_git <- function(url) {
  
  system(paste("git clone", url))
  path <- extract_repo_name(url)
  cat("Setting working directory to ", path)
  setwd(path)
  
  invisible(TRUE)
}

extract_repo_name <- function(url) {
  gsub(".*/([A-Za-z0-9._-]+?)(\\.git|/)?$", "\\1", url)
}

write_gitignore <- function(..., path = ".") {
  gitignew <- c(...)
  if (file.exists(".gitignore")) {
    gitignore <- readLines(".gitignore")
    gitignew <- union(gitignore, gitignew)
  }
  cat(gitignew, file = file.path(path, ".gitignore"), append = FALSE, sep = "\n")
  invisible(TRUE)
}

## Add metafiles (README.md, LICENSE, etc.)
add_metafiles <- function(...) {
  files <- c(...)
  stopifnot(inherits(files, "character"))
  
  for (file in files) {
    if (file.exists(file)) {
      ans <- readline(paste0(file, " exists. Overwrite? (y/n): "))
      if (tolower(ans) == "y") file.create(file)
    } else {
      file.create(file)
    }
  }
  invisible(TRUE)
}

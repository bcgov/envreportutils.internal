#' Install a local envreportbc package
#'
#'<full description>
#' @param pkgname The name of the package
#' @param path = NULL the path where the package is stored. Defaults to default location on the I drive.
#' @export
#' @return None
#' @examples \dontrun{
#' install_dev("envreportutils")
#'}
install_dev <- function(pkgname, path = "D:/packages") {

  pkgs <- local_packages(path = path, pkg = pkgname)
  pkg_file <- pkgs$path

  is_loaded <- paste0("package:",pkgname) %in% search()
  
  if (is_loaded) {
    pass <- readline("Package is currently loaded. Should it be unloaded before attempting installation (y/n)? ")
    if (tolower(pass) == "y") {
      unloadNamespace(pkgname)
      on.exit({
        message("Reloading package ", pkgname)
        library(pkgname, character.only = TRUE, quietly = TRUE)
      })
    }
  }
  
  install.packages(pkg_file, repos = NULL, type = "win.binary")

  invisible(NULL)
  
}

#' List available packages developed by Environmental Reporting BC
#'
#' @param pkg the name of a package (optional)
#' @param path The path where packages are stored. Defaults to default location on the I drive.
#'
#' @export
#' @return a data frame of packages, versions, and locations
local_packages <- function(path = "D:/packages", pkg = NULL) {
  
  if (.Platform$OS.type == "windows") {
    ext <- "zip"
  } else {
    ext <- "tar.gz"
  }
  
  pkg_files <- list.files(path, pattern = paste0(pkg, "_\\d+.+\\.", ext), full.names = TRUE)
  descs <- lapply(pkg_files, read_desc)
  
  pkgs <- sapply(descs, get_pkg_name)
  vers <- sapply(descs, get_pkg_version)
  
  pkgdf <- data.frame(Package = pkgs, Version = vers, 
                      path = paste0(pkg_files), 
                      stringsAsFactors = FALSE)
  
  if (!is.null(pkg)) {
    pkgdf <- pkgdf[pkgdf$Package == pkg,]
    
    if (nrow(pkgdf) > 1) {
      maxver <- max(pkgdf$Version)
      pkgdf <- pkgdf[pkgdf$Version == maxver,]
    }
  }
  
  pkgdf
}

#' @importFrom utils unzip untar
read_desc <- function(file){
  if (tools::file_ext(file) == "zip") {
    fun <- unzip
    zip_file <- TRUE
    } else {
      fun <- untar
    }
  files <- fun(file, list = TRUE)
  if (zip_file) files <- files[["Name"]]
  desc <- files[grep("/DESCRIPTION$", files)]
  desc <- fun(file, files = desc, exdir = tempdir())
  readLines(desc)
}

get_pkg_name <- function(desc) {
  pkg_line <- desc[grep("Package:", desc)]
  pkg_name <- strsplit(pkg_line, ":\\s*")[[1]][2]
  pkg_name
}

get_pkg_version <- function(desc) {
  vers_line <- desc[grep("Version:", desc)]
  version <- strsplit(vers_line, ":\\s*")[[1]][2]
  version
}

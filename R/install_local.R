#' Install a local envreportbc package
#'
#'<full description>
#' @param pkgname The name of the package
#' @param  install_path = NULL the path where the package is stored. Defaults to default location on the I drive.
#' @export
#' @return None
#' @examples \dontrun{
#' install_dev("envreportutils")
#'}
install_dev <- function(pkgname, install_path = NULL) {
  
  if (is.null(install_path)) {
    install_path <- "I:/SPD/Science Policy & Economics/State of Environment/_dev/packages"
  }
  
  pkgs <- local_packages(path = install_path)
  pkgs <- pkgs[pkgs$Package == pkgname,]
  
  if (nrow(pkgs) > 1) {
    pkgrow <- pkgs[which.max(pkgs$Version),]
    warning("More than one version of ", pkgname, 
            " found. Installed latest version (", pkgrow$Version, ")")
    pkg_file <- pkgrow$path
  } else {
    pkg_file <- pkgs$path
  }
  
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
  
  install.packages(pkg_file, repos = NULL)

  invisible(NULL)
  
}

#' List available packages developed by Environmental Reporting BC
#'
#' @param path = NULL The path where packages are stored. Defaults to default location on the I drive.
#' @export
#' @return a data frame of packages, versions, and locations
#' @examples \dontrun{
#'  local_packages()
#'}
local_packages <- function(path = NULL) {
  if (is.null(path)) {
    path <- "I:/SPD/Science Policy & Economics/State of Environment/_dev/packages"
  }
  
  if (.Platform$OS.type == "windows") {
    ext <- "zip"
  } else {
    ext <- "tar.gz"
  }
  
  pkg_files <- list.files(path, pattern = paste0("_\\d+.+\\.", ext))
  pkgs <- sapply(strsplit(pkg_files, paste0("_\\d+.+\\.", ext)), `[`, 1)
  vers <- as.numeric(gsub(paste0(".+_(\\d+.+)\\.", ext), "\\1", pkg_files))
  
  data.frame(Package = pkgs, Version = vers, 
             path = paste0(path, "/", pkg_files), 
             stringsAsFactors = FALSE)
}

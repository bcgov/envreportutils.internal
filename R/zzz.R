.onLoad <- function(libname, pkgname) {
  check_version("envreportbc")
  
  if (!set_ghostscript()) {
    packageStartupMessage("You do not appear to have ghostscript installed in ", 
                          "the usual place (C:/Program Files/gs/). ",
                          "Without it you will not be able to embed fonts in pdfs. ", 
                          "If you require this, please install ghostscript from ", 
                          "'http://ghostscript.com/download/gsdnld.html' and ",
                          "run envreportbc:::set_ghostscript('path_to_executable')")
  }
  invisible()
}

#' Set the environment variable for the path to the ghostscript executable.
#' @param gsfile path to the ghostscript executable
#' @keywords internal
#' @return logical dependent on whether or not the file exists
set_ghostscript <- function(gsfile = NULL) {
  if (is.null(gsfile)) {
    gsfile <- list.files("C:/Program Files/gs", recursive = TRUE, 
                         full.names = TRUE, pattern = "gswin(32|64)c\\.exe")
    gsfile <- gsfile[length(gsfile)] # If more than one, get the last, should be most recent
  }
  ret <- FALSE
  if (file.exists(gsfile)) {
    Sys.setenv(R_GSCMD = gsfile)
    ret <- TRUE
  }
  ret
}

#' @importFrom utils packageVersion
check_version <- function(pkg) {
  local_version <- packageVersion(pkg)
  server_version <- package_version(local_packages(pkg = pkg)$Version)
  
  if (server_version > local_version) {
    message("There is a newer version of ", pkg, " available (", 
            server_version, "). You have version", local_version, 
            ". You can install it with install.packages('", pkg, "')")
  }
}

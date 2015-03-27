#' Add a README.md file to the project directory
#' 
#' @param path Directory path (default \code{"."})
#' @param package Is this a package or a regular project? (Default \code{FALSE})
#' @export
#' @seealso \code{\link{add_contributing}}, \code{\link{add_license}}, \code{\link{add_license_header}}
#' @return NULL
add_readme <- function(path = ".", package = FALSE) {
  if (package) fname <- "pkg-README.md" else fname <- "README.md"
  add_file_from_template(path, fname)    
} 

#' Add a CONTRIBUTING.md file to the project directory
#' 
#' @param path Directory path (default \code{"."})
#' @export
#' @seealso \code{\link{add_readme}}, \code{\link{add_license}}, \code{\link{add_license_header}}
#' @return NULL
add_contributing <- function(path = ".") {
  add_file_from_template(path, "CONTRIBUTING.md")
}

#' Add a LICENSE file (Apache 2.0) to the project directory
#' 
#' @param path Directory path (default \code{"."})
#' @param package_desc Should the license be added to the DESCRIPTION file if this is a package?
#'
#' @export
#' @seealso \code{\link{add_readme}}, \code{\link{add_contributing}}, \code{\link{add_license_header}}
#' @return NULL
add_license <- function(path = ".", package_desc = FALSE) {
  add_file_from_template(path, "LICENSE")
  if (package_desc) {
    desc <- readLines(file.path(path, "DESCRIPTION"))
    desc[grep("License:", desc)] <- "License: Apache License (== 2.0) | file LICENSE"
    writeLines(desc, "DESCRIPTION")
  }
}

#' Add a file to a directory from a template in inst/templates
#'
#' Should really only be called by other functions
#' 
#' @param path Directory path (default \code{"."})
#' @param fname the name of the template file in inst/templates
#' @keywords internal
#' @seealso \code{\link{add_readme}}, \code{\link{add_contributing}}, \code{\link{add_license}}
#' @return NULL
add_file_from_template <- function(path, fname) {
  if (path == ".") {
    path <- getwd()
  }
  
  outfile <- file.path(path, fname)
  
  if (file.exists(outfile)) {
    warning(paste(fname, "already exists. Not adding a new one"))
  } else {
    message(paste("Adding file", fname))
    
    template_path <- system.file(file.path("templates", fname), 
                                 package = "envreportbc")
    file.copy(template_path, outfile)
  }
  
  invisible(TRUE)
}

#' Add the boilerplate Apache header to the top of a source code file
#' 
#' @param file Path to the file
#' @param year The year the license should apply
#' @export
#' @seealso \code{\link{add_license}}
#' @return NULL
add_license_header <- function(file, year) {
  
  license_txt <- '# Copyright YYYY Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.
'
  
  license_txt <- gsub("YYYY", year, license_txt)
  
  file_text <- readLines(file)

  writeLines(c(license_txt, file_text), file)
  message("adding Apache boilerplate header to the top of ", file)
  
  invisible(TRUE)
}

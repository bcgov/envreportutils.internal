add_readme <- function(path = ".", package = FALSE) {
  if (package) fname <- "pkg-README.md" else fname <- "README.md"
  add_file_from_template(path, fname)    
} 

add_contributing <- function(path = ".") {
  add_file_from_template(path, "CONTRIBUTING.md")
}

add_license <- function(path = ".") {
  add_file_from_template(path, "LICENSE")
}

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
  
  invisible(TRUE)
}

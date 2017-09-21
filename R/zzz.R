# Copyright 2017 Province of British Columbia
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

.onLoad <- function(libname, pkgname) {
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
set_ghostscript <- function(gsfile = "") {
  gs_path <- tools::find_gs_cmd(gsfile)
  
  if (nzchar(gs_path)) {
    Sys.setenv(R_GSCMD = gs_path)
    return(TRUE)
  } else {
    return(FALSE)
  }
}

get_buckets <- function() {
  c("Air", "Water", "Plants and Animals", "Climate Change", "Land and Forests", "Sustainability")
}

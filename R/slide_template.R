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

#' Create a slide presentation from template
#'
#' @param title Short title of the presentation
#' @param path where do you want to put it? (default current directory)
#'
#' @return TRUE (invisibly)
#' @export
#'
#' @examples
#' slide_template("my_pres", path = "presentation")
slide_template <- function(title, path = ".") {
  if (missing(title)) stop("You must specify a title")
  if (!dir.exists(path)) dir.create(path)
  
  envreportutils:::add_file_from_template(path, 
                        fname = file.path("io_presentation", "presentation_template.Rmd"), 
                        outfile = paste0(title, ".Rmd"), pkg = "envreportbc")
  envreportutils:::add_file_from_template(file.path(path, "css"), 
                         fname = file.path("io_presentation","css","envreportbc-style.css"), 
                         outfile = "envreportbc-style.css", pkg = "envreportbc")
  
  pngs <- c("BC_MoE_logo.png", "come-in-open.png", "databc.png", 
            "EnvironmentalReportingBC_logo.png", "envreportbc-github.png", 
            "pause_sink_dataviz.png", "rising-value.png", "SoE_books.png", 
            "state-salish-sea.png", "unep-soe_gateway.png")
  
  pngs <- file.path("io_presentation", "img", pngs)
  
  lapply(pngs, function(png) {
    envreportutils:::add_file_from_template(file.path(path, "img"), 
                                            fname = png, 
                                            outfile = basename(png), 
                                            pkg = "envreportbc")
  })

  invisible(TRUE)
}

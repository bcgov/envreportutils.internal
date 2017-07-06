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

#' Connect to the BCGW (LRDW)
#'
#'<full description>
#' @import tcltk
#'
#' @param user BCGW Username
#' @param  ... Additional parameters passed on to odbcConnect
#' @export
#' @return an odbc connection
bcgw_connect <- function(user, ...) {
  bit_64 <- R.Version()$arch == "x86_64"
  
  if (bit_64) {
    stop("You need to be running a 32 bit version of R to use ODBC.")
  }
  
  password <- getPass()
  
  RODBC::odbcConnect("BCGW", user, password, ...)
}

getPass <- function(){  
  wnd <- tktoplevel()
  tkraise(wnd)
  passVar <- tclVar("")
  #Label  
  tkgrid(tklabel(wnd,text = "Enter password:"))  
  #Password box
  passBox <- tkentry(wnd, textvariable = passVar,show = "*")
  tkgrid(passBox)
  tkfocus(wnd)
  #Hitting return will also submit password
  tkbind(passBox, "<Return>", function() tkdestroy(wnd));  
  #OK button
  tkgrid(tkbutton(wnd, text = "OK", command = function() tkdestroy(wnd)));  
  #Wait for user to click OK  
  tkwait.window(wnd);  
  password <- tclvalue(passVar);  
  return(password);  
} 

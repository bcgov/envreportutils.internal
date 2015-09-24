#' Connect to the BCGW (LRDW)
#'
#'<full description>
#' @import tcltk
#' @import RODBC
#'
#' @param user BCGW Username
#' @param  ... Additional parameters passed on to odbcConnect
#' @export
#' @return an odbc connection
#' @examples \dontrun{
#'
#'}
bcgw_connect <- function(user, ...) {

  bit_64 <- R.Version()$arch == "x86_64"
  
  if (bit_64) {
    stop("You need to be running a 32 bit version of R to use ODBC.")
  }
  
  password <- getPass()
  
  odbcConnect("BCGW", user, password, ...)
}

getPass <- function(){  
  wnd <- tktoplevel()
  tkraise(wnd)
  passVar <- tclVar("")
  #Label  
  tkgrid(tklabel(wnd,text = "Enter password:"))  
  #Password box
  passBox <- tkentry(wnd, textvariable = passVar,show = "*",)
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

#' Connect to the BCGW (LRDW)
#'
#'<full description>
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
  
  password <- readline("Please enter your passsword: ") 
  
  odbcConnect("BCGW", user, password, ...)
}

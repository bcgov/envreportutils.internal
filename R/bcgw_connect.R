#' Connect to the BCGW (LRDW)
#'
#'<full description>
#' @import RODBC
#'
#' @param user BCGW Username
#' @param  password BCGW password
#' @param  ... Additional parameters passed on to odbcConnect
#' @export
#' @return an odbc connection
#' @examples \dontrun{
#'
#'}
bcgw_connect <- function(user, password, ...) {
  odbcConnect("BCGW", user, password, ...)
}

#' Check that argument is in radians
#'
#' @param ex A `examiner_result`, presumably containing a call to a trig function.
#' @param radian_val a number: the desired angle in radians
#' @param message character string message to produce on failure
#' @param eps precision of comparison
#'
#' @examples
#' ex <- for_examiner(quote(15 * sin(3)))
#' trig_radian_check(ex, 3)
#' trig_radian_check(ex, 3 * pi / 180)
#' trig_radian_check(ex, 4*pi/180)
#'
#' @export
trig_radian_check <- function(ex, radian_val,
                              message = "Could not find call to a trigonometric function",
                              eps = 0.001) {
  if (failed(ex)) return(ex) # If ex is a failure, pass it on as a result.

  # grab the call to a trigonometric function
  trig_call <- line_calling(ex, sin, cos, tan, message = message)
  if (failed(trig_call)) return(trig_call)

  # get the argument to the trig call
  angle <- arg_number(arg_calling(trig_call, sin, cos, tan), 1, message = message)
  if (failed(angle)) return(angle)

  angle_val <- eval_tidy(angle$code[[1]])

  if (abs(angle_val - radian_val) < eps ) return(angle)
  else {
    if (abs(angle_val * pi / 180 - radian_val) < eps) {
      angle$message <- "Angles should be specified in radians."
    } else {
      angle$message <- "The angle isn't right."
    }
    angle$action <- "fail"
    return(angle)
  }
}

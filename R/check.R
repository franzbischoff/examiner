#' Apply passif/failif/okif tests to an identified code object
#'
#' A generic testing function for applying passif/failif tests with V and EX bindings
#' to a examiner_result object. Unlike `line_where()`, other line functions, no patterns
#' need to be provided. Just the passif/failif tests.
#'
#' @param ex the examiner_result object with a single line of code
#' @param ... passif/failif tests to be applied
#' @param message a character string to be used as the message for a failed result
#'
#' @return a examiner_result object reflecting the outcome of the tests
#'
#' @examples
#' code <- for_examiner(quote({x <- 3; y <- x^2 + 2}))
#' line2 <- line_where(code, insist(Z == "y"))
#' check(line2, passif(V == 11, "Right, eleven!"),
#'       message = "Sorry. The result should be 11.")
#' @export
check <- function(ex, ..., message = "Sorry!") {
  stopifnot(inherits(ex, "examiner_result"))
  if (failed(ex)) return(ex) # short circuit.
  if(length(ex$code) != 1) stop("check() is for handling just a single line of code.") # Author error

  line_binding(ex, I, ..., message = message,
               qkeys = quote({.(E); ..(V)}))
}

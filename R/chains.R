#' Expand a chain into a series of lines, each with `.` as the input.
#'
#' @usage expand_chain(ex)
#' @usage expand_all_chains(ex)
#'
#' A magrittr chain, e.g. `a \\%>\\% f() \\%>\\% g() \\%>\\% h()` is equivalent to a sequence of nested function
#' calls: `h(g(f(a)))`. It's also equivalent to a
#' sequence of statements: `. <- f(a); . <- g(.); h(.)` Expanding a chain means to rewrite it
#' into this last form. Note that `.` is an object name. It's value changes at each statement (except the last, which
#' is the result returned by the chain). By expanding a chain, you can use `examiner` statements to look at individual
#' function calls in the chain.
#'
#' `expand_chain()` expands one chain. `expand_all_chains()` takes a sequence of lines, some of
#' which may be chains, into an equivalent sequence of lines, none of which are chains.
#'
#'
#' @return A `examiner_result` object with one line for each of the functions in the chain.
#'
#' @details A magrittr chain consists of a sequence of function calls. Each function takes as input
#' the output of the function before it. (The first element of the chain may be an object
#' or a function call.) The `expand_` functions transform chains into a sequence of lines. Each such line
#' (except the first) will be a function with at least one of the inputs being denoted `.`. The value
#' of `.` for each line will be the object that is an input to that line.
#'
#' @param ex A `examiner_result` object with just one line of code.
#'
#' @examples
#' code <- for_examiner(quote({x <- 3 %>% sin( ) %>% cos(); x %>% sqrt() %>% log()}))
#' lineA <- line_chaining(code)
#' expand_chain(lineA)
#' expand_all_chains(code)
#' @rdname chains
#' @export
expand_chain <- function(ex) {
  stopifnot(inherits(ex, "examiner_result"))
  tmp <- simplify_ex(ex$code[[1]])
  if ( ! is_chain(tmp)) return(ex) # already expanded
  if (failed(ex)) return(ex) # short circuit on failure
  # originally, the logic was based on magrittr:::split_chain
  # which gave expressions for the single LHS and the possibly many RHS.
  # To avoid using an unexported function (i.e. :::), I re-wrote this
  # using lang_tail()
  CP <- call_args(quo_expr(skip_assign(ex$code[[1]])))
  if (is_call(CP[[1]]) && call_name(CP[[1]]) == "%>%") {
    # A chain longer than one link needs to have the first part
    # broken up
    first <- CP[[1]]
    CP[[1]] <- NULL
    CP <- c(call_args(first), CP)
  }
  for (k in seq_along(CP)) { # make sure there's a dot argument
                            # inserted in calls like 3 %>% sin()
    if (is_call(CP[[k]], n = 0))
      CP[[k]] <- call2(call_name(CP[[k]]), quote(.))
  }
  new_code <- list() # holds the sequence of quo's representing the chain
  this_env <- environment(ex$code[[1]])
  # loop over the remaining elements in the chain
  for (m in seq_along(CP)) {
    new_code[[m]] <- new_quosure(expr = CP[[m]], env = this_env)
    value <- eval_tidy(new_code[[m]]) # the previous element
    this_env <- child_env(.parent = this_env, . = value)
  }
  ex$code <- new_code
  return(ex)
}

#' @rdname chains
#' @export
expand_all_chains <- function(ex) {
  stopifnot(inherits(ex, "examiner_result"))
  if (failed(ex)) return(ex) # short circuit on failure
  newcode <- list()
  for (m in seq_along(ex$code)) {
    expanded <- expand_chain(new_examiner_result(action = "ok", code = ex$code[m]))
    newcode <- c(newcode, expanded$code)
  }
  ex$code <- newcode

  ex
}

#' @rdname chains
#' @export
is_chain <- function(ex) {
  ex <- simplify_ex(ex)
  if (! (is.call(ex) && is.call(quo_expr(ex)) )) {
    FALSE
  } else {
    identical(call_name(ex), "%>%")
  }
}


# Examples used in the documentation
# They are used in several places, so they are consolidated here.
# None of them are exported, so they need to be referred to with :::

rep_1234 <- function(USER_CODE) {
  code <- for_examiner(USER_CODE)
  res <- line_where(code,
                    insist(Z != "", "Remember to store the result under the name `Id`."),
                    insist(Z == "Id", "Use `Id` for the assignment, not {{Z}}."),
                    insist(F == "rep", "You're supposed to use `rep()`."))

  # res <- line_where(code, insist(Z != "", "Remember to store the result under the name `Id`."))
  # res <- line_where(res, insist(Z == "Id", "Use `Id` for the assignment, not {{Z}}."))
  #
  # res <- line_where(res, insist(F == "rep", "You're supposed to use `rep()`."))
  the_each_arg <- named_arg(res, "each",
                            message = "Look at the help for `rep()` to see what arguments are available to control the pattern of repetition. (These are documented under `...`)")
  t1 <- check(the_each_arg,
              failif(V != 3,
                     "Good use of `each=`, but each = {{V}} is not the right value."))
  if (failed(t1)) return(t1)

  the_vector <- vector_arg(res, message = "Where do you create the elements to be repeated?")
  t2 <- check(the_vector,
              failif(! identical(V, 1:4),
                     "The elements to be repeated are 1 through 4, not {{V}}. Where do you construct the set 1:4 to pass to `rep()`?"))



  t2
}

rep_abcd <- function(USER_CODE) {
  code <- for_examiner(USER_CODE)
  res <- line_where(code, insist(Z != "", "Remember to store the result under the name `Letter`."))
  res <- line_where(res, insist(Z == "Letter", "Use `Letter` for the assignment, not {{Z}}."))

  res <- line_where(res, insist(F == "rep"), message = "You're supposed to use `rep()`.")
  the_each_arg <- named_arg(res, "each",
                            message = "Look at the help for `rep()` to see what arguments are available to control the pattern of repetition. (These are documented under `...`)")
  t1 <- check(the_each_arg,
              failif(V != 4,
                     "Good use of `each=`, but each = {{V}} is not the right value."))
  if (failed(t1)) return(t1)

  the_vector <- vector_arg(res, message = "Where do you create the elements to be repeated?")
  t2 <- check(the_vector,
              failif(! identical(V, letters[1:3]),
                     "The elements to be repeated are 'a' through 'c', not {{V}}. Where do you construct that set?"))



  t2
}

# Will this be of any use in general
check_assigns <- function(ex, names = NULL, vals = NULL) {
  stopifnot(!is.null(names))
  if (!is.null(vals)) stopifnot(length(names) == length(vals))

  res <- ex
  for (k in seq_along(names)) {
    m <- paste("You're supposed to assign to an object called", names[k])
    t1 <- line_where(res, insist(Z == names[k], m))
    if (! is.null(vals)) {
      m <- paste("The object called", names[k], "should be a",
                 to_sensible_character(vals[[k]]))
      t1 <- line_where(t1,
                       insist(Z == names[k], "Wrong name used for assignment"),
                       insist(identical(V, vals[[k]]), "Wrong value for {{E}}."),
                       message = m)
    }
    if (failed(t1)) return(t1)
  }
  res
}

df_abcd_1234_x_y <- function(USER_CODE) {
  browser()
  code <- for_examiner(USER_CODE)
  Id <- rep(1:4, each = 3)
  x <- seq(1, 43, along.with=Id)
  y <- seq(-20,0, along.with=Id)
  df <- data.frame(x = x, y = y, Id = Id)
  check_assigns(code, c("Id", "x", "y", "df"),
                list(Id, x, y, df))
}

check_exer_14 <- function(submission) {
  code <- for_examiner(submission)
  if (failed(code)) return(code)
  check_blanks(code,
               quote(ggplot(mtcars, aes(x = ..x.., y = ..y.., color = ..c..)) + ..geom..()),
               insist(same_name(x, "mpg"), "{{x}} is not the variable on the horizontal axis."),
               insist(same_name(y, "hp"), "{{y}} is not the right variable for the vertical axis"),
               insist(same_name(c, "cyl"), "{{c}} is not the right variable to map to color."),
               insist(same_name(geom, "geom_point"), "{{geom}} is not the correct geom to make a scatter plot."),
               passif(TRUE, "Good job!"))
}

check_pythag <- function(submission) {
  code <- for_examiner(submission)
  if (failed(code)) return(code)
  check_blanks(code,
               quote(C <- ..fun..(A^2 + B^2)),
               passif(fun == quote(sqrt), "Right!"),
               insist(fun == quote(sqrt),
                      "Think again. {{fun}} is not the right function to use."))
}



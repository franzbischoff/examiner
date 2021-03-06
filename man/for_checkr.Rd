% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/for_examiner.R
\name{for_examiner}
\alias{for_examiner}
\title{Translate a sequence of commands into a sequence of quosures}
\usage{
for_examiner(exprs)
}
\arguments{
\item{exprs}{an expression or set of expressions in a curly brace}
}
\value{
a quosure for each expression in exs, with an associated
environment that reflects the state when that expression was evaluated.
}
\description{
This function is the first step in any examiner sequence. It scans the
quoted commands for parse errors, evaluates the lines one at a time, and
packages up the lines into quosures with an environment in which the line
should be executed. (That way the lines can be evaluated in a stand-alone
manner.)
}
\examples{
code <- for_examiner(quote({x <- 2; y <- x^2; z <- x + y}))
class(code)
passed(code)
line_where(code, insist(Z == "z", "No line with assignment to 'z'."))
line_where(code, insist(V == 4), insist(Z == "y"))
}

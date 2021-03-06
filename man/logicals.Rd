% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/logicals.R
\name{\%or\%}
\alias{\%or\%}
\alias{\%and\%}
\alias{\%or\%.examiner_result}
\alias{\%and\%.examiner_result}
\alias{not}
\title{Combine or negate examiner_results}
\usage{
res1 \%or\% res2

res1 \%and\% res2

\method{\%or\%}{examiner_result}(res1, res2)

\method{\%and\%}{examiner_result}(res1, res2)

not(res1)
}
\arguments{
\item{res1}{the first examiner result}

\item{res2}{the second examiner result}
}
\description{
The outcome of a examiner test is an object of class \code{examiner_result} that indicates
whether the test was passed or failed or was sufficient to move on to additional tests.
}
\examples{
# normally these results are made by the checking functions
code <- for_examiner(quote(1))
pa <- check(code, passif(V==1, "Good!"))
pb <- check(code, passif(V==1, "Great!"))
fa <- check(code, failif(V==1, "too bad"))
fb <- check(code, failif(V==1, "sorry"))
oka <- check(code, noteif(V==1, "note a"))
okb <- check(code, noteif(V==1, "note b"))
pa \%or\% pb
pa \%and\% pb
fa \%or\% fb
fa \%and\% fb
oka \%or\% okb
oka \%and\% okb
oka \%and\% fa
oka \%or\% fa
pa \%or\% fa
pa \%and\% fa
pa \%or\% oka
pa \%and\% oka
examiner::not(pa)
examiner::not(fa)

}

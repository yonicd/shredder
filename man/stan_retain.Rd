% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stan_retain.R
\name{stan_retain}
\alias{stan_retain}
\title{Return object with specific chains}
\usage{
stan_retain(object, chains = 1)
}
\arguments{
\item{object}{stanfit object}

\item{chains}{numeric, chains to retain, Default: 1}
}
\value{
stanfit object
}
\description{
Use stan_retain() to choose chains to retain.
}
\examples{
\donttest{
rats <- rats_example(nCores = 1)

#retain first chain only
rats\%>\%
  stan_retain()
  
#retain chains 1 and 3
rats\%>\%
  stan_retain(c(1,3))
 }
}
\seealso{
Other utility: 
\code{\link{stan_axe}()},
\code{\link{stan_names}()}
}
\concept{utility}

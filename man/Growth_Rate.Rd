% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Growth_Rate.R
\name{Growth_Rate}
\alias{Growth_Rate}
\title{Growth_Rate}
\usage{
Growth_Rate(Ticker)
}
\arguments{
\item{Ticker}{The ticker of the stock to be evaluated}
}
\value{
Growth The estimated average and recent growth rate. Returns a list.
}
\description{
This function aims to calculate the terminal growth rate g using the retention ratio b and return on equity (ROE). It calculates the growth rate using the most recent data or average data and returns both.
}
\examples{
{
 # Calculate the growth rate g for AAPL. The function calculates the average ROE growth rate and most recent ROE growth rate
   growth_rate <- Growth_Rate("AAPL")
}
}
\seealso{
\code{\link[tidyquant]{tq_get}}
}

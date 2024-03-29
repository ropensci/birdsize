% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/species_data_functions.R
\name{get_sd_parameters}
\alias{get_sd_parameters}
\title{Estimate parameters for scaling of standard deviation with mean body size}
\usage{
get_sd_parameters(raw_size_data)
}
\arguments{
\item{raw_size_data}{dataframe of species' mean and standard deviation body
sizes; use the included \code{raw_masses} data table.}
}
\value{
list of \verb{$slope} and \verb{$intercept} from the linear model fit
}
\description{
Calculates parameters for a (log-log linear) scaling relationship between the
mean and standard deviation of a species' mean body size. Given a table of
species with known mean and standard deviation body sizes, fits a linear
model of the form \code{log(var(body_size)) ~ log(mean(body_size))} and extracts
parameter estimates, which can then be used to estimate the standard
deviation of body mass for a species based only on its mean body mass. See
also Thibault et al. (2011) for this method applied to the Breeding Bird
Survey.
}
\references{
\itemize{ \item{Thibault, K. M., White, E. P., Hurlbert, A. H., &
Ernest, S. K. M. (2011). Multimodality in the individual size distributions
of bird communities. Global Ecology and Biogeography, 20(1), 145–153.
https://doi.org/10.1111/j.1466-8238.2010.00576.x} }
}
\keyword{internal}

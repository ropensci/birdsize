% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/species_data_functions.R
\name{get_sp_mean_size}
\alias{get_sp_mean_size}
\title{Summarize records of mean and standard deviation of body mass to
species-level means}
\usage{
get_sp_mean_size(sd_dat)
}
\arguments{
\item{sd_dat}{dataframe of mean and standard deviation of body mass for all
records for all species; generated by \code{add_estimated_sds}}
}
\value{
\code{sd_dat} summarized to species-level means for the mean and standard
deviation of body mass
}
\description{
The CRC Handbook (Dunning 2008) often contains multiple records for mean body
mass (and standard deviation of body mass) for a species, drawn from
different locations or for different sexes. This function summarizes across
all records for each species to produce species-level means for the mean and
standard deviation of body mass.
}
\references{
\itemize{ \item{Dunning, J. B. (2008). CRC handbook of avian body
masses (2nd ed.). CRC Press.} }
}
\keyword{internal}

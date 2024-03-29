% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/species_define.R
\name{species_define}
\alias{species_define}
\title{Define a species}
\usage{
species_define(
  AOU = NA_integer_,
  scientific_name = NA_character_,
  mean_size = NA_real_,
  sd_size = NA_real_,
  sim_species_id = 1
)
}
\arguments{
\item{AOU}{the numeric AOU code used for this species in the Breeding Bird
Survey}

\item{scientific_name}{the species' scientific name, as "Genus species"}

\item{mean_size}{mean body size}

\item{sd_size}{sd of body size}

\item{sim_species_id}{identifier; if using taxonomic info, defaults to AOU.
If not, defaults to 1. Supplying other values can be useful for simulation
models.}
}
\value{
list with species parameter information
}
\description{
Creates a list with taxonomic/identifying information and parameters for mean
and standard deviation of body mass.
}
\details{
The identifying information used depends on which parameters are provided,
with the following order of preference: AOU > scientific name > user provided
mean and sd > user provided mean and estimated sd.
}
\examples{
species_define(AOU = 2881)
species_define(scientific_name = "Perdix perdix")
species_define(mean_size = 400, sd_size = 30)
species_define(mean_size = 400)
}

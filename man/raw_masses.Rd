% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{raw_masses}
\alias{raw_masses}
\title{Records of mean and standard deviation body masses}
\format{
A data frame with 928 rows and 19 variables:
\describe{
\item{species_id}{the species ID}
\item{english_common_name}{the English common name, from Paradieck et al. (2019)}
\item{sporder}{order, from Paradieck et al. (2019)}
\item{family}{family, from Paradieck et al. (2019)}
\item{genus}{genus, from Paradieck et al. (2019)}
\item{species}{species, from Paradieck et al. (2019)}

\item{mass}{mean body size for this sex/location, from Dunning (2008), in grams}
\item{sd}{standard deviation of body size for this sex/location, if provided in Dunning (2008). Contains \code{NA} for records without standard deviation measurements}
\item{sex}{sex, if provided in Dunning (2008). Conatins \code{NA} for records without values for "sex" in Dunning (2008). \code{m} or \code{f}}
\item{subspecies}{subspecies, from Dunning (2008). Contains \code{NA} for record with no subspecies listed in Dunning (2008)}
\item{location}{location, if provided in Dunning (2008)}
\item{name_mismatch}{flag = 1, if there is a mismatch between the scientific name in Paradieck et al. (2019) versus in Dunning (2008). Typically these are small changes in spelling}
\item{name_notes}{name as listed in Dunning (2008), if different from that listed in Paradieck et al. (2019)}
\item{not_in_dunning}{flag = 1, if this species does not have a record in Dunning (2008)}
\item{close_genus}{if a species is not in Dunning (2008), but a closely related species - e.g. recently renamed, or taxonomically divided between 2008 and 2019 - is, the genus of that closely related species.}
\item{close_species}{if a species is not in Dunning (2008), but a closely related species - e.g. recently renamed, or taxonomically divided between 2008 and 2019 - is, the species of that closely related species.}
\item{close_subspecies}{if a species is not in Dunning (2008), but a closely related species - e.g. recently renamed, or taxonomically divided between 2008 and 2019 - is, the subspecies of that closely related species.}
\item{close_species_notes}{notes explaining the details of the "closely related" species designations}
\item{AOU}{The AOU}
}
}
\usage{
raw_masses
}
\description{
A table of mean and (where available) standard deviation body masses for birds in the North American Breeding Bird Survey. The species list derives from \code{SpeciesList.txt} in Paradieck et al. (2019), filtered to remove species poorly sampled via the Breeding Bird Survey methods (following Harris et al. 2018) and augmented with all records, for each species, of mean (and, where available, standard deviation) body size  found in the CRC Handbook of Avian Body Masses (Dunning 2008). There are often multiple records for a species, for different sexes or locations. Each record is included as a separate line.
}
\references{
\itemize{
\item{Dunning, J. B. (2008). CRC handbook of avian body masses (2nd ed.). CRC Press.}
\item{Harris, D. J., Taylor, S. D., & White, E. P. (2018). Forecasting biodiversity in breeding birds using best practices. PeerJ, 6, e4278. https://doi.org/10.7717/peerj.4278}
\item{Pardieck, K. L., Ziolkowski, D. J., Lutmerding, M., Aponte, V., & Hudson, M.-A. (2019). North American Breeding Bird Survey Dataset 1966—2018, version 2018.0. U.S. Geological Survey. https://doi.org/10.5066/P9HE8XYJ}
}
}
\keyword{internal}

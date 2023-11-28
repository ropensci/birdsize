#' Cleaned data for a hypothetical Breeding Bird Survey route.
#'
#' This is the cleaned version of [demo_route_raw], a toy dataset for use in vignettes and function testing. It contains all the same column names as would be expected for a Breeding Bird survey route dataset downloaded, e.g. from ScienceBase or the Data Retriever (Pardieck et al. 2019). However, the actual data values are simulated data.
#'
#' Nearly all column names are inherited from Pardieck et al. (2019) and are further explained in the Files and Fields Definitions document included as part of the Breeding Bird Survey data release.
#'
#' The cleaning process removes unidentified species and those poorly sampled by Breeding Bird Survey methods (using the [filter_bbs_survey] function) and, for these data, filters the `year` to `1994` for rapid testing.
#'
#' @format A data frame with 27 rows and 15 variables:
#' \describe{
#'   \item{record_id}{inherited from data downloaded through the Data Retriever}
#'   \item{routedataid}{inherited from Pardieck et al. 2018 (as are all following fields). Unique data identification number.}
#'   \item{countrynum}{inherited. Three-digit numerical code for country. In these data, the toy countrynum is 900.}
#'   \item{statenum}{inherited. Two-digit numerical code for state, province, or territory. For these data, the toy number is 99.}
#'   \item{route}{inherited. Three-digit code identifying the route, unique within states. For this dataset, 1.}
#'   \item{rpid}{inherited. Three-digit run protocol identifier. Here, set to 101.}
#'   \item{year}{inherited. Four-digit year of the survey.}
#'   \item{AOU}{inherited. Five-digit species identification number.}
#'   \item{count10}{inherited. Total individuals of the species recorded on stops 1-10.}
#'   \item{count20}{inherited. Total individuals of the species recorded on stops 11-20.}
#'   \item{count30}{inherited. Total individuals of the species recorded on stops 21-30.}
#'   \item{count40}{inherited. Total individuals of the species recorded on stops 31-40.}
#'   \item{count50}{inherited. Total individuals of the species recorded on stops 40-50.}
#'   \item{stoptotal}{inherited. Total number of stops (of 50), where the species was recorded.}
#'   \item{speciestotal}{inherited. Total individuals of the species recorded across the entire run of the route (sum of stops).}
#' }
#' @references \itemize{
#'   \item{Pardieck, K. L., Ziolkowski, D. J., Lutmerding, M., Aponte, V., & Hudson, M.-A. (2019). North American Breeding Bird Survey Dataset 1966—2018, version 2018.0. U.S. Geological Survey. https://doi.org/10.5066/P9HE8XYJ}
#' }
#'
#'
"demo_route_clean"


#' Raw data for a hypothetical Breeding Bird Survey route.
#'
#' A toy dataset for use in vignettes and function testing. It contains all the same column names as would be expected for a Breeding Bird survey route dataset downloaded, e.g. from ScienceBase or the Data Retriever (Pardieck et al. 2019). However, the actual data values are simulated data.
#'
#' Nearly all column names are inherited from Pardieck et al. (2019) and are further explained in the Files and Fields Definitions document included as part of the Breeding Bird Survey data release.
#'
#' @format A data frame with 1160 rows and 15 variables:
#' \describe{
#'   \item{record_id}{inherited from data downloaded through the Data Retriever}
#'   \item{routedataid}{inherited from Pardieck et al. 2018 (as are all following fields). Unique data identification number.}
#'   \item{countrynum}{inherited. Three-digit numerical code for country. In these data, the toy countrynum is 900.}
#'   \item{statenum}{inherited. Two-digit numerical code for state, province, or territory. For these data, the toy number is 99.}
#'   \item{route}{inherited. Three-digit code identifying the route, unique within states. For this dataset, 1.}
#'   \item{rpid}{inherited. Three-digit run protocol identifier. Here, set to 101.}
#'   \item{year}{inherited. Four-digit year of the survey.}
#'   \item{AOU}{inherited. Five-digit species identification number.}
#'   \item{count10}{inherited. Total individuals of the species recorded on stops 1-10.}
#'   \item{count20}{inherited. Total individuals of the species recorded on stops 11-20.}
#'   \item{count30}{inherited. Total individuals of the species recorded on stops 21-30.}
#'   \item{count40}{inherited. Total individuals of the species recorded on stops 31-40.}
#'   \item{count50}{inherited. Total individuals of the species recorded on stops 40-50.}
#'   \item{stoptotal}{inherited. Total number of stops (of 50), where the species was recorded.}
#'   \item{speciestotal}{inherited. Total individuals of the species recorded across the entire run of the route (sum of stops).}
#' }
#' @references \itemize{
#'   \item{Pardieck, K. L., Ziolkowski, D. J., Lutmerding, M., Aponte, V., & Hudson, M.-A. (2019). North American Breeding Bird Survey Dataset 1966—2018, version 2018.0. U.S. Geological Survey. https://doi.org/10.5066/P9HE8XYJ}
#' }
#'
#'
"demo_route_raw"


#' List of species known to `birdsize`
#'
#' A table of the AOU (Pardieck et al 2019), genus, and species of the 443 species with species-specific data built in to `birdsize`.
#'
#' @format A data frame with 443 rows and 6 variables:
#' \describe{
#'   \item{AOU}{AOU used in Paradieck et al. (2019)}
#'   \item{genus}{genus, from Paradieck et al. (2019)}
#'   \item{species}{species, from Paradieck et al. (2019)}
#'   }
#' @references \itemize{
#'   \item{Pardieck, K.L., Ziolkowski Jr., D.J., Lutmerding, M., Aponte, V., and Hudson, M-A.R., 2019, North American Breeding Bird Survey Dataset 1966 - 2018 (ver. 2018.0): U.S. Geological Survey, Patuxent Wildlife Research Center, https://doi.org/10.5066/P9HE8XYJ.}
#' }
#'
#' @keywords export
#'
"known_species"

#' Which AOUs correspond to nontarget species.
#'
#' Downloaded using the rdataretriever in June 2022.
#' For inclusion in package vignettes, function testing.
#' Citation needed!
#'
#' @format A data frame with 263 rows and 4 variables:
#' \describe{
#'   \item{AOU}{AOU}
#'   \item{english_common_name}{English common name}
#'   \item{genus}{genus}
#'   \item{species}{species}
#' }
#' @references \itemize{
#'   \item{Pardieck, K. L., Ziolkowski, D. J., Lutmerding, M., Aponte, V., & Hudson, M.-A. (2019). North American Breeding Bird Survey Dataset 1966—2018, version 2018.0. U.S. Geological Survey. https://doi.org/10.5066/P9HE8XYJ}
#' }
#'
#' @keywords internal
#'
#'
"nontarget_species"

#' Records of mean and standard deviation body masses
#'
#' A table of mean and (where available) standard deviation body masses for birds in the North American Breeding Bird Survey. The species list derives from `SpeciesList.txt` in Paradieck et al. (2019), filtered to remove species poorly sampled via the Breeding Bird Survey methods (following Harris et al. 2018) and augmented with all records, for each species, of mean (and, where available, standard deviation) body size  found in the CRC Handbook of Avian Body Masses (Dunning 2008). There are often multiple records for a species, for different sexes or locations. Each record is included as a separate line.
#'
#' @format A data frame with 928 rows and 19 variables:
#' \describe{
#'   \item{species_id}{the species ID}
#'   \item{english_common_name}{the English common name, from Paradieck et al. (2019)}
#'   \item{sporder}{order, from Paradieck et al. (2019)}
#'   \item{family}{family, from Paradieck et al. (2019)}
#'   \item{genus}{genus, from Paradieck et al. (2019)}
#'   \item{species}{species, from Paradieck et al. (2019)}
#'
#'   \item{mass}{mean body size for this sex/location, from Dunning (2008), in grams}
#'   \item{sd}{standard deviation of body size for this sex/location, if provided in Dunning (2008). Contains `NA` for records without standard deviation measurements}
#'   \item{sex}{sex, if provided in Dunning (2008). Conatins `NA` for records without values for "sex" in Dunning (2008). `m` or `f`}
#'   \item{subspecies}{subspecies, from Dunning (2008). Contains `NA` for record with no subspecies listed in Dunning (2008)}
#'   \item{location}{location, if provided in Dunning (2008)}
#'   \item{name_mismatch}{flag = 1, if there is a mismatch between the scientific name in Paradieck et al. (2019) versus in Dunning (2008). Typically these are small changes in spelling}
#'   \item{name_notes}{name as listed in Dunning (2008), if different from that listed in Paradieck et al. (2019)}
#'   \item{not_in_dunning}{flag = 1, if this species does not have a record in Dunning (2008)}
#'   \item{close_genus}{if a species is not in Dunning (2008), but a closely related species - e.g. recently renamed, or taxonomically divided between 2008 and 2019 - is, the genus of that closely related species.}
#'   \item{close_species}{if a species is not in Dunning (2008), but a closely related species - e.g. recently renamed, or taxonomically divided between 2008 and 2019 - is, the species of that closely related species.}
#'   \item{close_subspecies}{if a species is not in Dunning (2008), but a closely related species - e.g. recently renamed, or taxonomically divided between 2008 and 2019 - is, the subspecies of that closely related species.}
#'   \item{close_species_notes}{notes explaining the details of the "closely related" species designations}
#'   \item{AOU}{The AOU}
#' }
#' @references \itemize{
#'  \item{Dunning, J. B. (2008). CRC handbook of avian body masses (2nd ed.). CRC Press.}
#'  \item{Harris, D. J., Taylor, S. D., & White, E. P. (2018). Forecasting biodiversity in breeding birds using best practices. PeerJ, 6, e4278. https://doi.org/10.7717/peerj.4278}
#'   \item{Pardieck, K. L., Ziolkowski, D. J., Lutmerding, M., Aponte, V., & Hudson, M.-A. (2019). North American Breeding Bird Survey Dataset 1966—2018, version 2018.0. U.S. Geological Survey. https://doi.org/10.5066/P9HE8XYJ}
#' }
#' @keywords internal
"raw_masses"

#' Species-level means for the mean and standard deviation of body size for species in the North American Breeding Bird Survey.
#'
#' A table of species-level mean values for the means and standard deviations of body size for species in the North American Breeding Bird Survey (Paradieck et al. 2019) based on records in the CRC Handbook of Avian Body Masses (2008). Standard deviations, where not provided in the CRC Handbook, are estimated based on a scaling relationship between a species' mean body size and the standard deviation of its body size (see also Thibault et al. 2010). Species-level means are reported for both the mean mean mass and mean standard deviation for all species.
#'
#' @format A data frame with 443 rows and 6 variables:
#' \describe{
#'   \item{AOU}{AOU used in Paradieck et al. (2019)}
#'   \item{genus}{genus, from Paradieck et al. (2019)}
#'   \item{species}{species, from Paradieck et al. (2019)}
#'   \item{mean_mass}{mean mass across all records in Dunning (2008) for that species, in grams}
#'   \item{mean_sd}{mean standard deviation of body mass across all records from Dunning (2008). For records for which a standard deviation is not provided, the standard deviation is estimated based on the scaling relationship derived from this dataset. Estimated standard deviations are calculated prior to taking species-level means.}
#'   \item{contains_estimates}{TRUE/FALSE whether or not the mean_sd column includes estimated standard deviations}
#'   \item{scientific_name}{the genus and species together}
#' }
#' @references \itemize{
#'  \item{Dunning, J. B. (2008). CRC handbook of avian body masses (2nd ed.). CRC Press.}
#'   \item{Pardieck, K. L., Ziolkowski, D. J., Lutmerding, M., Aponte, V., & Hudson, M.-A. (2019). North American Breeding Bird Survey Dataset 1966—2018, version 2018.0. U.S. Geological Survey. https://doi.org/10.5066/P9HE8XYJ}
#'   \item{Thibault, K. M., White, E. P., Hurlbert, A. H., & Ernest, S. K. M. (2011). Multimodality in the individual size distributions of bird communities. Global Ecology and Biogeography, 20(1), 145–153. https://doi.org/10.1111/j.1466-8238.2010.00576.x}
#' }
#'
#' @keywords internal
#'
"sd_table"

#' Table of AOUs corresponding to unidentified species.
#'
#' This data table is used internally to filter out unidentified species based on their AOUs. It is derived from the species table available in Pardieck et al. (2019)
#'
#' @format A data frame with 72 rows and 4 variables:
#' \describe{
#'   \item{AOU}{AOU}
#'   \item{english_common_name}{English common name}
#'   \item{genus}{genus}
#'   \item{species}{species}
#' }
#' @references \itemize{
#'   \item{Pardieck, K. L., Ziolkowski, D. J., Lutmerding, M., Aponte, V., & Hudson, M.-A. (2019). North American Breeding Bird Survey Dataset 1966—2018, version 2018.0. U.S. Geological Survey. https://doi.org/10.5066/P9HE8XYJ}
#' }
#'
#' @keywords internal
#'
#'
"unidentified_species"


#' Toy data frame of abundances and AOUs (for vignettes)
#'
#' This data table is a toy data frame for the vignettes. It has abundances and AOU codes for 5 species to make up a hypothetical community.
#' @format A data frame with 5 rows and 2 variables:
#' \describe{
#'   \item{AOU}{AOU}
#'   \item{abundance}{Number of individuals to simulate masses for}
#' }
#'
#'
#'
"toy_aou_community"


#' Toy data frame of abundances and species names (for vignettes)
#'
#' This data table is a toy data frame for the vignettes. It has abundances and
#' scientific names for 5 species to make up a hypothetical community.
#' @format A data frame with 5 rows and 2 variables:
#' \describe{
#'   \item{scientific_name}{Scientific name}
#'   \item{abundance}{Number of individuals to simulate masses for}
#' }
#'
#'
#'
"toy_species_name_community"


#' Toy data frame of abundances and species mean sizes (for vignettes)
#'
#' This data table is a toy data frame for the vignettes. It has abundances and
#' mean body sizes for 5 species to make up a hypothetical community.
#' @format A data frame with 5 rows and 3 variables:
#' \describe{
#'   \item{mean_size}{Mean mass, in g}
#'   \item{abundance}{Number of individuals to simulate masses for}
#'   \item{sim_species_id}{ID}
#' }
#'
#'
#'
"toy_size_community"

#' Cleaned data for a hypothetical Breeding Bird Survey route.
#'
#' This is the cleaned version of [demo_route_raw], a toy dataset for use in vignettes and function testing. It contains all the same column names as would be expected for a Breeding Bird survey route dataset downloaded, e.g. from ScienceBase or the Data Retriever (Pardieck et al. 2019). However, the actual data values are simulated data.
#'
#' Nearly all column names are inherited from Pardieck et al. (2019) and are further explained in the Files and Fields Definitions document included as part of the Breeding Bird Survey data release.
#'
#' The cleaning process removes unidentified species and those poorly sampled by Breeding Bird Survey methods (using the [filter_bbs_species] function) and, for these data, filters the `year` to `1994` for rapid testing.
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
#'   \item{aou}{inherited. Five-digit species identification number.}
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

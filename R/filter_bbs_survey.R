
#' Clean raw Breeding Bird Survey survey data
#'
#' The raw data for the Breeding Bird Survey includes unidentified species and some species that are not well-sampled by the BBS methods. This function filters a dataframe to remove those species.
#'
#' @param bbs_survey_data data frame with columns for species and AOU
#'
#' @return bbs_survey_data with unidentified species, nightbirds, waterbirds, non-targets removed
#' @export
#'
#' @examples
#'
#' head(filter_bbs_survey(demo_route_raw))
#'

filter_bbs_survey <- function(bbs_survey_data) {


  colnames(bbs_survey_data) <- tolower(colnames(bbs_survey_data))
  colnames(bbs_survey_data)[ which(colnames(bbs_survey_data) == "aou")] <- "AOU"


  if(!("AOU" %in% colnames(bbs_survey_data))) {
    stop("`AOU` column is required!")
  }

  unidentified_species <- unidentified_species
  nontarget_species <- nontarget_species
  bbs_survey_data <- bbs_survey_data[ !(bbs_survey_data$AOU %in% unidentified_species$AOU), ]
  bbs_survey_data <- bbs_survey_data[ !(bbs_survey_data$AOU %in% nontarget_species$AOU), ]

  bbs_survey_data

}

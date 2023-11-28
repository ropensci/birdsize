#' Check for unidentified species
#'
#' Derived from MATSS, originally derived from Harris et al 2018 (weecology/bbs-forecasting)
#'
#' @param names species name
#'
#' @return logical
#' @keywords internal
#'
#'
is_unidentified <- function(names) {
  names[names == "auratus auratus x auratus cafer"] <-
    "auratus auratus"
  grepl("sp\\.| x |\\/", names)
}

#' Find unidentified species from species' name
#'
#' For transparency and testing, not for use.
#'
#' @param species_table The species list for the Breeding Bird Survey.
#'
#' @return dataframe of unidentified species AOUs and names
#' @keywords internal
find_unidentified_species <- function(species_table) {
  unidentified_species_table <- species_table
  unidentified_species_table$is_unid <-
    is_unidentified(unidentified_species_table$species)
  unidentified_species_table <-
    unidentified_species_table[unidentified_species_table$is_unid,]
  unidentified_species_table <-
    unidentified_species_table[, c("AOU", "english_common_name", "genus", "species")]

  unidentified_species_table
}

#' Find nontarget species
#'
#' For transparency and testing, not for use.
#'
#' @param species_table The species list for the Breeding Bird Survey.
#'
#' @return dataframe of nontarget species AOUs and names
#'
#' @keywords internal
find_nontarget_species <- function(species_table) {
  nontarget_species_complement <- species_table
  nontarget_species_complement <-
    nontarget_species_complement[nontarget_species_complement$AOU > 2880,]
  nontarget_species_complement <-
    nontarget_species_complement[nontarget_species_complement$AOU < 3650 |
                                   nontarget_species_complement$AOU > 3810,]
  nontarget_species_complement <-
    nontarget_species_complement[nontarget_species_complement$AOU < 3900 |
                                   nontarget_species_complement$AOU > 3910,]
  nontarget_species_complement <-
    nontarget_species_complement[nontarget_species_complement$AOU < 4160 |
                                   nontarget_species_complement$AOU > 4210,]
  nontarget_species_complement <-
    nontarget_species_complement[nontarget_species_complement$AOU != 7010,]


  nontarget_species_table <- species_table
  nontarget_species_table <-
    nontarget_species_table[!(nontarget_species_table$AOU %in% nontarget_species_complement$AOU),]
  nontarget_species_table <-
    nontarget_species_table[, c("AOU", "english_common_name", "genus", "species")]

  nontarget_species_table
}

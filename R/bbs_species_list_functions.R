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
  names[names == "auratus auratus x auratus cafer"] = "auratus auratus"
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
#
#   unidentified_species_table <- species_table %>%
#     dplyr::mutate(is_unid = is_unidentified(.data$species)) %>%
#     dplyr::filter(.data$is_unid == TRUE) %>%
#     dplyr::select(.data$aou, .data$english_common_name, .data$genus, .data$species)

  unidentified_species_table <- species_table
  unidentified_species_table$is_unid <- is_unidentified(unidentified_species_table$species)
  unidentified_species_table <- unidentified_species_table[ unidentified_species_table$is_unid, ]
  unidentified_species_table <- unidentified_species_table[ , c("aou", "english_common_name", "genus", "species")]

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
#
#   nontarget_species_complement <- species_table %>%
#     dplyr::filter(.data$aou > 2880) %>%
#     dplyr::filter(.data$aou < 3650 | .data$aou > 3810) %>%
#     dplyr::filter(.data$aou < 3900 | .data$aou > 3910) %>%
#     dplyr::filter(.data$aou < 4160 | .data$aou > 4210) %>%
#     dplyr::filter(.data$aou != 7010)

  nontarget_species_complement <- species_table
  nontarget_species_complement <- nontarget_species_complement[ nontarget_species_complement$aou > 2880,]
  nontarget_species_complement <- nontarget_species_complement[ nontarget_species_complement$aou < 3650 | nontarget_species_complement$aou > 3810,]
  nontarget_species_complement <- nontarget_species_complement[ nontarget_species_complement$aou < 3900 | nontarget_species_complement$aou > 3910,]
  nontarget_species_complement <- nontarget_species_complement[ nontarget_species_complement$aou < 4160 | nontarget_species_complement$aou > 4210,]
  nontarget_species_complement <- nontarget_species_complement[ nontarget_species_complement$aou != 7010,]

#
#   nontarget_species_table <- species_table %>%
#     dplyr::filter(!(.data$aou %in% nontarget_species_complement$aou)) %>%
#     dplyr::select(.data$aou, .data$english_common_name, .data$genus, .data$species)
  nontarget_species_table <- species_table
  nontarget_species_table <- nontarget_species_table[ !(nontarget_species_table$aou %in% nontarget_species_complement$aou), ]
  nontarget_species_table <- nontarget_species_table[ , c("aou", "english_common_name", "genus", "species")]

  nontarget_species_table
}



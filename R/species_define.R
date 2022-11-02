#' Define a species
#'
#' Creates a list with taxonomic/identifying information and parameters for mean and standard deviation of body mass.
#'
#' The identifying information used depends on which parameters are provided, with the following order of preference: AOU > genus + species > user provided mean and sd > user provided mean and estimated sd.
#'
#' @param aou AOU
#' @param genus genus
#' @param species species
#' @param mean_size mean body size
#' @param sd_size sd of body size
#' @param sim_species_id identifier; if using taxonomic info, defaults to AOU. If not, defaults to 1. Supplying other values can be useful for simulation models.
#'
#' @return list with species parameter information
#' @export
#' @examples
#' species_define(aou = 2881)
#' species_define(genus = "Perdix", species = "perdix")
#' species_define(mean_size = 400, sd_size = 30)
#' species_define(mean_size = 400)

species_define <- function(aou = NA, genus = NA, species = NA, mean_size = NA, sd_size = NA, sim_species_id = 1) {
  if (!is.na(aou)) {

    # use AOU to get mean, sd, genus, and species
    spPars <- species_lookup(aou = aou)
    thisSpecies <- list(aou = aou, genus = spPars$genus, species = spPars$species, mean_size = spPars$mean_mass, sd_size = spPars$mean_sd, sd_method = "AOU lookup", sim_species_id = aou)

    # Check that any user-supplied taxonomic info matches the AOU provided
    if (!is.na(genus)) {
      if (genus != thisSpecies$genus) {
        warning("User-provided genus does not match genus associated with this AOU")
      }
    }

    if (!is.na(species)) {
      if (species != thisSpecies$species) {
        warning("User-provided species does not match species associated with this AOU")
      }
    }

    return(thisSpecies)
  }

  # If AOU is not provided (implicit in order) try genus + species

  if (all(!is.na(genus), !is.na(species))) {
    spPars <- species_lookup(genus = genus, species = species)
    thisSpecies <- list(aou = spPars$aou, genus = spPars$genus, species = spPars$species, mean_size = spPars$mean_mass, sd_size = spPars$mean_sd, sd_method = "Scientific name lookup", sim_species_id = spPars$aou)
    return(thisSpecies)
  }

  # If neither of AOU or genus + species is provided (implicit in order)
  if (!is.na(mean_size)) {
    if (!is.na(sd_size)) {
      thisSpecies <- list(aou = as.numeric(NA), genus = as.character(NA), species = as.character(NA), mean_size = mean_size, sd_size = sd_size, sd_method = "Mean and SD provided", sim_species_id = sim_species_id)
      return(thisSpecies)
    }

    this_sd <- species_estimate_sd(mean_size)
    thisSpecies <- list(aou = as.numeric(NA), genus = as.character(NA), species = as.character(NA), mean_size = mean_size, sd_size = this_sd, sd_method = "SD estimated from mean", sim_species_id = sim_species_id)
    return(thisSpecies)
  }

  # If insufficient information is provided, throw an error

  stop("At least one of: AOU, genus + species, or mean_size must be provided!")
}

#' Species lookup
#'
#' Given either AOU or genus and species, looks up a species' taxonomic information and mean and standard deviation of body size in [sd_table].
#'
#' @param aou AOU species code as specified in the Breeding Bird Survey
#' @param genus genus
#' @param species species
#'
#' @return data frame with columns aou, genus, species, mean_mass, mean_sd, contains_estimates
#' @export
#'
#' @importFrom dplyr filter
#' @examples
#' species_lookup(aou = 2881)
#' species_lookup(genus = "Selasphorus", species = "calliope")
species_lookup <- function(aou = NA, genus = NA, species = NA) {
  sd_table <- sd_table

  provided_aou <- aou

  if (!is.na(provided_aou)) {
    if (!(provided_aou %in% sd_table$aou)) {
      stop("`aou` is invalid.")
    }

    return(sd_table %>%
      dplyr::filter(.data$aou == provided_aou))

  } else if (all(is.character(genus), is.character(species))) {
    proper_genus <- tolower(genus)
    substr(proper_genus, 1, 1) <- toupper(substr(proper_genus, 1, 1))
    proper_species <- tolower(species)

    sp_pars <- dplyr::filter(
      sd_table,
      genus == proper_genus,
      species == proper_species
    )

    if(nrow(sp_pars) > 1) {
      sp_pars <- sp_pars[1,]
    }

    valid_name <- nrow(sp_pars) == 1

    if (valid_name) {
      return(sp_pars)
    } else {
      stop("`genus` `species` combination is invalid.")
    }
  } else {
    stop("Either `aou` or both `genus` and `species` must be provided.")
  }
}

#' Define a species
#'
#' Populates a [Species] object with taxonomic/identifying information and parameters for mean and standard deviation of body mass. Order of preference: AOU > genus + species > user provided mean and sd > user provided mean and estimated sd.
#'
#' @param aou AOU
#' @param genus genus
#' @param species species
#' @param mean_size mean body size
#' @param sd_size sd of body size
#' @param id identifier; if using taxonomic info, defaults to AOU. If not, defaults to 1. Supplying other values can be useful for simulation models.
#'
#' @return object of class Species
#' @export
#' @importFrom methods new
species_define <- function(aou = NULL, genus = NULL, species = NULL, mean_size = NULL, sd_size = NULL, id = 1) {
  if (!is.null(aou)) {

    # use AOU to get mean, sd, genus, and species
    spPars <- species_lookup(species_code = aou)
    thisSpecies <- new("Species", aou = aou, genus = spPars$genus, species = spPars$species, mean_size = spPars$mean_mass, sd_size = spPars$mean_sd, sd_method = "AOU lookup", id = aou)

    # Check that any user-supplied taxonomic info matches the AOU provided
    if (!is.null(genus)) {
      if (genus != thisSpecies$genus) {
        warning("User-provided genus does not match genus associated with this AOU")
      }
    }

    if (!is.null(species)) {
      if (species != thisSpecies$species) {
        warning("User-provided species does not match species associated with this AOU")
      }
    }

    return(thisSpecies)
  }

  # If AOU is not provided (implicit in order) try genus + species

  if (all(!is.null(genus), !is.null(species))) {
    spPars <- species_lookup(genus = genus, species = species)
    thisSpecies <- new("Species", aou = aou, genus = spPars$genus, species = spPars$species, mean_size = spPars$mean_mass, sd_size = spPars$mean_sd, sd_method = "Scientific name lookup", id = aou)
    return(thisSpecies)
  }

  # If neither of AOU or genus + species is provided (implicit in order)
  if (!is.null(mean_size)) {
    if (!is.null(sd_size)) {
      thisSpecies <- new("Species", aou = as.numeric(NA), genus = as.character(NA), species = as.character(NA), mean_size = mean_size, sd_size = sd_size, sd_method = "Mean and SD provided", id = id)
      return(thisSpecies)
    }

    this_sd <- species_estimate_sd(mean_size)
    thisSpecies <- new("Species", aou = as.numeric(NA), genus = as.character(NA), species = as.character(NA), mean_size = mean_size, sd_size = this_sd, sd_method = "SD estimated from mean", id = id)
    return(thisSpecies)
  }

  # If insufficient information is provided, throw an error

  stop("At least one of: AOU, genus + species, or mean_size must be provided!")
}

#' An S4 class to hold species information
#'
#' @slot aou The AOU
#' @slot genus genus
#' @slot species species
#' @slot mean_size size
#' @slot sd_size sd of size
#' @slot sd_method known, or estimated
#' @slot id if AOU is provided, AOU; otherwise an integer for keeping track of hypothetical species

Species <- setClass("Species", slots = list(aou = "numeric", genus = "character", species = "character", mean_size = "numeric", sd_size = "numeric", sd_method = "character", id = "numeric"))

#' Look up species mean and sd body size given species ID
#'
#' @param species_code species_ID as specified in the Breeding Bird Survey
#' @param genus genus
#' @param species species
#'
#' @return data frame with columns species_id, genus, species, mean_mass, mean_sd, contains_estimates
#' @export
#'
#' @importFrom dplyr filter
#'
species_lookup <- function(species_code = NULL, genus = NULL, species = NULL) {
  sd_table <- sd_table

  if (!is.null(species_code)) {
    if (!(species_code %in% sd_table$species_id)) {
      stop("`species_code` is invalid.")
    }

    return(sd_table %>%
      dplyr::filter(.data$species_id == species_code))
  } else if (all(is.character(genus), is.character(species))) {
    proper_genus <- tolower(genus)
    substr(proper_genus, 1, 1) <- toupper(substr(proper_genus, 1, 1))
    proper_species <- tolower(species)

    sp_pars <- dplyr::filter(
      sd_table,
      genus == proper_genus,
      species == proper_species
    )

    valid_name <- nrow(sp_pars) == 1

    if (valid_name) {
      return(sp_pars)
    } else {
      stop("`genus` `species` combination is invalid.")
    }
  } else {
    stop("Either `species_code` or both `genus` and `species` must be provided.")
  }
}

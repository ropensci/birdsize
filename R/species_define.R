#' Define a species
#'
#' Creates a list with taxonomic/identifying information and parameters for mean
#' and standard deviation of body mass.
#'
#' The identifying information used depends on which parameters are provided,
#' with the following order of preference: AOU > scientific name > user provided
#' mean and sd > user provided mean and estimated sd.
#'
#' @param AOU  the numeric AOU code used for this species in the Breeding Bird
#'   Survey
#' @param scientific_name the species' scientific name, as "Genus species"
#' @param mean_size mean body size
#' @param sd_size sd of body size
#' @param sim_species_id identifier; if using taxonomic info, defaults to AOU.
#'   If not, defaults to 1. Supplying other values can be useful for simulation
#'   models.
#'
#' @return list with species parameter information
#' @export
#' @examples
#' species_define(AOU = 2881)
#' species_define(scientific_name = "Perdix perdix")
#' species_define(mean_size = 400, sd_size = 30)
#' species_define(mean_size = 400)
species_define <-
  function(AOU = NA_integer_,
           scientific_name = NA_character_,
           mean_size = NA_real_,
           sd_size = NA_real_,
           sim_species_id = 1) {
    if (!is.na(AOU)) {
      # use AOU to get mean, sd, genus, and species
      spPars <- species_lookup(AOU = AOU)
      thisSpecies <-
        list(
          AOU = AOU,
          scientific_name = spPars$scientific_name,
          mean_size = spPars$mean_mass,
          sd_size = spPars$mean_sd,
          sd_method = "AOU lookup",
          sim_species_id = AOU
        )

      # Check that any user-supplied taxonomic info matches the AOU provided
      if (!is.na(scientific_name)) {
        if (scientific_name != thisSpecies$scientific_name) {
          warning(
            "User-provided scientific name does not match scientific name associated with this AOU"
          )
        }
      }

      return(thisSpecies)
    }

    # If AOU is not provided (implicit in order) try scientific name

    if (all(!is.na(scientific_name))) {
      spPars <- species_lookup(scientific_name = scientific_name)
      thisSpecies <-
        list(
          AOU = spPars$AOU,
          scientific_name = spPars$scientific_name,
          mean_size = spPars$mean_mass,
          sd_size = spPars$mean_sd,
          sd_method = "Scientific name lookup",
          sim_species_id = spPars$AOU
        )
      return(thisSpecies)
    }

    # If neither of AOU or scientific name is provided (implicit in order)
    if (!is.na(mean_size)) {
      if (!is.na(sd_size)) {
        thisSpecies <-
          list(
            AOU = NA_integer_,
            scientific_name = NA_character_,
            mean_size = mean_size,
            sd_size = sd_size,
            sd_method = "Mean and SD provided",
            sim_species_id = sim_species_id
          )
        return(thisSpecies)
      }

      this_sd <- species_estimate_sd(mean_size)
      thisSpecies <-
        list(
          AOU = NA_integer_,
          scientific_name = NA_character_,
          mean_size = mean_size,
          sd_size = this_sd,
          sd_method = "SD estimated from mean",
          sim_species_id = sim_species_id
        )
      return(thisSpecies)
    }

    # If insufficient information is provided, throw an error

    stop("At least one of: AOU, scientific_name, or mean_size must be provided!")
  }

#' Species lookup
#'
#' Given either AOU or scientific name, looks up a species' taxonomic
#' information and mean and standard deviation of body size in [sd_table].
#'
#' @param AOU  the numeric AOU code used for this species in the Breeding Bird
#'   Survey
#' @param scientific_name the species' scientific name, as "Genus species"
#'
#' @return data frame with columns AOU, genus, species, mean_mass, mean_sd,
#'   contains_estimates, scientific_name
#' @export
#'
#' @examples
#' species_lookup(AOU = 2881)
#' species_lookup(scientific_name = "Selasphorus calliope")
species_lookup <-
  function(AOU = NA_integer_,
           scientific_name = NA_character_) {
    provided_AOU <- AOU

    if (!is.na(provided_AOU)) {
      if (!(provided_AOU %in% sd_table$AOU)) {
        stop("`AOU` is invalid.")
      }

      return(sd_table[sd_table$AOU == provided_AOU,])
    } else if (is.character(scientific_name)) {
      proper_scientific_name <- tolower(scientific_name)
      substr(proper_scientific_name, 1, 1) <-
        toupper(substr(proper_scientific_name, 1, 1))

      sp_pars <-
        sd_table[sd_table$scientific_name == proper_scientific_name,]

      if (nrow(sp_pars) > 1) {
        sp_pars <- sp_pars[1,]
      }

      valid_name <- nrow(sp_pars) == 1

      if (valid_name) {
        return(sp_pars)
      } else {
        stop("Scientific name is invalid.")
      }
    } else {
      stop("Either `AOU` or a valid scientific name must be provided.")
    }
  }

#' Draw individuals to make a population.
#'
#' This is not a user-facing function; rather it is the random number generator under-the-hood for [pop_generate].
#'
#' @param species_mean mean body size
#' @param species_sd standard deviation of body size
#' @param species_abundance number of individuals to draw
#'
#' @return vector of individuals' simulated body masses
#'
#' @importFrom stats rnorm
#' @keywords internal
ind_draw <- function(species_mean = NULL, species_sd = NULL, species_abundance = NULL) {
  if (is.null(species_mean)) {
    stop("`species_mean` must be provided")
  }

  if (is.null(species_sd)) {
    stop("`species_sd` must be provided")
  }

  if (is.null(species_abundance)) {
    stop("`species_abundance` must be provided")
  }

  if (!is.numeric(species_abundance)) {
    stop("`species_abundance` must be numeric")
  }

  if (!(round(species_abundance) == species_abundance)) {
    stop("`species_abundance` must be a whole number")
  }

  population <- rnorm(n = species_abundance, mean = species_mean, sd = species_sd)

  while (any(population < 0)) {
    population[which(population < 0)] <- rnorm(n = sum(population < 0), mean = species_mean, sd = species_sd)
  }

  population
}

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




#' Simulate body masses for a population
#'
#' Draws body mass measurements for a population of birds (of all the same species) given the population size and either (1) the species id or (2) the mean and potentially standard deviation of body mass for that species.
#'
#' Fills in the necessary parameters based on the parameters provided and passes these to [ind_draw()].
#'
#' `species_abundance`, and *either* `species_mean` or `species_code`, must be provided. Depending on which parameters are provided:
#'
#' * `species_mean` and `species_sd`: If both mean and standard deviation body size are provided, uses the values provided to draw `species_abundance` individuals.
#' * `species_mean` but no `species_sd`: If mean is provided but standard deviation is not, estimates the standard deviation based on the scaling relationship between mean and standard deviation of body mass (see [species_estimate_sd()]).
#' * `species_code` or both `genus` and `species` but no `species_mean` or `species_sd`: If parameter values are not provided, but a species code is, look up the mean and standard deviation body mass for that species (see [species_lookup()].
#' * If both species ID (`species_code`) _and_ `species_mean` are provided, uses the species ID and ignores the mean provided.
#'
#' @param species_abundance integer number of individuals to draw. *Required*.
#' @param species_mean numeric, mean body mass (in grams) for this species.
#' @param species_sd numeric, standard deviation of body mass for this species.
#' @param species_code species ID for this species.
#'
#' @return a dataframe with `species_abundance` rows and columns for: `species_code`, `genus`, `species`, `species_mean`, `species_sd`, `species_abundance`, `simulation_method`, and `individual_mass`.
#' @export
pop_generate <- function(species_abundance = NULL, species_mean = NULL, species_sd = NULL, species_code = NULL) {
  if (all(!is.null(species_code), !is.null(species_mean))) {
    message("Both `species_code` and `species_mean` are provided; using `species_code` and overwriting `species_mean` based on species' parameters.")
  }


  if (!is.null(species_code)) {
    species_pars <- species_lookup(species_code)

    species_mean <- species_pars$mean_mass
    species_sd <- species_pars$mean_sd


    population <- ind_draw(species_mean = species_mean, species_sd = species_sd, species_abundance = species_abundance)

    simulation_method <- "species code provided"
  } else if (!is.null(species_mean)) {
    species_code <- NA

    simulation_method <- "mean and sd provided"

    if (!is.numeric(species_mean)) {
      stop("`species_mean`, if used, must be numeric")
    }

    if (is.null(species_sd)) {
      species_sd <- species_estimate_sd(species_mean)
      simulation_method <- "sd estimated from mean provided"
    }

    population <- ind_draw(
      species_abundance = species_abundance,
      species_mean = species_mean,
      species_sd = species_sd
    )
  } else {
    stop("Either `species_mean` or `species_code` must be provided.")
  }

  population_df <- data.frame(
    species_code = species_code,
    species_mean_mass = species_mean,
    species_sd_mass = species_sd,
    species_abundance = species_abundance,
    simulation_method = simulation_method,
    individual_mass = population
  )

  population_df
}

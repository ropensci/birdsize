#' Draw individuals to make a population.
#'
#' This is not a user-facing function; it is the random number generator under-the-hood for [pop_generate].
#'
#' @param species_mean mean body size
#' @param species_sd standard deviation of body size
#' @param species_abundance number of individuals to draw
#'
#' @return vector of individuals' simulated body masses
#'
#' @importFrom truncnorm rtruncnorm
#' @importFrom stats pnorm
#' @keywords internal
ind_draw <- function(species_mean = NA_real_, species_sd = NA_real_, species_abundance = NA_integer_) {
  if (is.na(species_mean)) {
    stop("`species_mean` must be provided")
  }

  if (is.na(species_sd)) {
    stop("`species_sd` must be provided")
  }

  if (is.na(species_abundance)) {
    stop("`species_abundance` must be provided")
  }

  if (!is.numeric(species_abundance)) {
    stop("`species_abundance` must be numeric")
  }

  if (!(round(species_abundance) == species_abundance)) {
    stop("`species_abundance` must be a whole number")
  }

  population <- truncnorm::rtruncnorm(n = species_abundance, a = 1, b = Inf, mean = species_mean, sd = species_sd)
#
#   while (any(population < 0)) {
#     population[which(population < 0)] <- rnorm(n = sum(population < 0), mean = species_mean, sd = species_sd)
#   }

  population
}



#' Simulate body masses for a population
#'
#' Draws body mass measurements for a population of birds (of all the same species) given the population size and either (1) the species AOU or (2) the mean and potentially standard deviation of body mass for that species.
#'
#' `abundance` is required, as well as *one of*: `AOU`, `scientific_name`, or `mean_size`.
#'
#' @param abundance integer number of individuals to draw. *Required*.
#' @param AOU AOU
#' @param scientific_name as "Genus species"
#' @param mean_size numeric, mean body mass (in grams) for this species.
#' @param sd_size numeric, standard deviation of body mass for this species.
#' @param sim_species_id defaults AOU or 1
#'
#' @return a dataframe with `abundance` rows - one record per individual - and columns for species attributes.
#'
#' Specifically:
#'
#' * `AOU`: the AOU, if provided
#' *  `sim_species_id`: the `sim_species_id` if provided
#' * `scientific_name`: the scientific name if provided
#' *  `individual_mass`: the simulated body mass (in grams) for this individual
#' *  `individual_bmr`: the simulated basal metabolic rate for this individual
#' *  `mean_size`: the mean body mass for this species (i.e. the parameter used for simulation)
#' *  `sd_size`: the standard deviation of body mass for this species (i.e. the parameter used for simulation)
#' *  `abundance`: the number of individuals simulated of this species (i.e. parameter used for simulation)
#' *  `sd_method`: the method for finding the standard deviation for body mass for this species
#'
#' @export
#' @examples
#'
#' pop_generate(abundance = 5, AOU = 2881)
#' pop_generate(abundance = 5, scientific_name = "Selasphorus calliope")
#' pop_generate(abundance = 5, mean_size = 20, sd_size = 3)
#'
pop_generate <- function(abundance = NA_integer_, AOU = NA_integer_, scientific_name = NA_character_, mean_size = NA_real_, sd_size = NA_real_, sim_species_id = 1) {
  this_species <- species_define(
    AOU = AOU,
    scientific_name = scientific_name,
    mean_size = mean_size,
    sd_size = sd_size,
    sim_species_id = sim_species_id
  )

  # abundance errors
  if (is.na(abundance)) {
    stop("`abundance` must be provided")
  }

  if (!is.numeric(abundance)) {
    stop("`abundance` must be numeric")
  }

  if (!(round(abundance) == abundance)) {
    stop("`abundance` must be a whole number")
  }

  # errors related to size pars

  if (is.na(this_species$mean_size)) {
    stop("`species_mean` must be provided")
  }

  if (is.na(this_species$sd_size)) {
    stop("`species_sd` must be provided")
  }

  # print message if the combination of mean and SD is likely (> 1% chance) to produce negative masses

  if (pnorm(1, this_species$mean_size, this_species$sd_size) > .01) {
    message("Very tiny species (a greater than 1% chance of a body mass value less than 1g)!")
  }

  # draw

  this_population <- ind_draw(species_mean = this_species$mean_size, species_sd = this_species$sd_size, species_abundance = abundance)

  this_population_bmr <- individual_metabolic_rate(this_population)

  population_df <- data.frame(
    AOU = this_species$AOU,
    sim_species_id = this_species$sim_species_id,
    individual_mass = this_population,
    individual_bmr = this_population_bmr,
    mean_size = this_species$mean_size,
    sd_size = this_species$sd_size,
    abundance = abundance,
    sd_method = this_species$sd_method,
    scientific_name = this_species$scientific_name
  )

  population_df
}

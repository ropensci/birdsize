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
ind_draw <- function(species_mean = NA, species_sd = NA, species_abundance = NA) {
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

  population <- rnorm(n = species_abundance, mean = species_mean, sd = species_sd)

  while (any(population < 0)) {
    population[which(population < 0)] <- rnorm(n = sum(population < 0), mean = species_mean, sd = species_sd)
  }

  population
}



#' Simulate body masses for a population
#'
#' Draws body mass measurements for a population of birds (of all the same species) given the population size and either (1) the species id or (2) the mean and potentially standard deviation of body mass for that species.
#'
#' Fills in the necessary parameters based on the parameters provided and passes these to [ind_draw()].
#'
#' @param abundance integer number of individuals to draw. *Required*.
#' @param aou aou
#' @param genus genus
#' @param species species
#' @param mean_size numeric, mean body mass (in grams) for this species.
#' @param sd_size numeric, standard deviation of body mass for this species.
#' @param sim_species_id defaults AOU or 1
#'
#' @return a dataframe with `abundance` rows and columns for species attributes.
#' @export
#' @examples
#'
#' pop_generate(abundance = 5, aou = 2881)
#' pop_generate(abundance = 5, genus = "Selasphorus", species = "calliope")
#' pop_generate(abundance = 5, mean_size = 20, sd_size = 3)
#'
pop_generate <- function(abundance = NA, aou = NA, genus = NA, species = NA, mean_size = NA, sd_size = NA, sim_species_id = 1) {
  this_species <- species_define(
    aou = aou,
    genus = genus,
    species = species,
    mean_size = mean_size,
    sd_size = sd_size,
    sim_species_id = sim_species_id
  )


  this_population <- ind_draw(species_mean = this_species$mean_size, species_sd = this_species$sd_size, species_abundance = abundance)

  this_population_bmr <- individual_metabolic_rate(this_population)

  population_df <- data.frame(
    aou = this_species$aou,
    sim_species_id = this_species$sim_species_id,
    genus = this_species$genus,
    species = this_species$species,
    individual_mass = this_population,
    individual_bmr = this_population_bmr,
    mean_size = this_species$mean_size,
    sd_size = this_species$sd_size,
    abundance = abundance,
    sd_method = this_species$sd_method
  )

  population_df
}

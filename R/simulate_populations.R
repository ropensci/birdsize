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
#' @param id defaults AOU or 1
#'
#' @return a dataframe with `abundance` rows and columns for species attributes.
#' @export
#' @examples
#'
#' pop_generate(abundance = 5, aou = 2881)
#' pop_generate(abundance = 5, genus = "Selasphorus", species = "calliope")
#' pop_generate(abundance = 5, mean_size = 20, sd_size = 3)
#'
pop_generate <- function(abundance = NULL, aou = NULL, genus = NULL, species = NULL, mean_size = NULL, sd_size = NULL, id = 1) {
  this_species <- species_define(
    aou = aou,
    genus = genus,
    species = species,
    mean_size = mean_size,
    sd_size = sd_size,
    id = id
  )


  this_population <- ind_draw(species_mean = this_species$mean_size, species_sd = this_species$sd_size, species_abundance = abundance)

  population_df <- data.frame(
    aou = this_species$aou,
    id = this_species$id,
    genus = this_species$genus,
    species = this_species$species,
    individual_mass = this_population,
    mean_size = this_species$mean_size,
    sd_size = this_species$sd_size,
    abundance = abundance,
    sd_method = this_species$sd_method
  )

  population_df
}

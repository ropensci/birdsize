#' Draw individuals to make a population
#'
#' @param species_mean mean body size
#' @param species_sd standard deviation of body size
#' @param species_abundance number of individuals to draw
#'
#' @return vector of individuals' simulated body masses
#' @export
#'
draw_population <- function(species_mean, species_sd, species_abundance){

  population <- rnorm(n = species_abundance, mean = species_mean, sd = species_sd)

  while(any(population < 0)) {

    population[ which(population < 0)] <- rnorm(n = sum(population < 0), mean = species_mean, sd = species_sd)

  }

  population

}

#' Look up species mean and sd body size given species ID
#'
#' @param species_code species_ID as specified in the Breeding Bird Survey
#'
#' @return data frame with columns species_id, genus, species, mean_mass, mean_sd, contains_estimates
#' @export
#'
lookup_species_pars <- function(species_code) {

  sd_table <- sd_table

  stopifnot(species_code %in% sd_table$species_id)

  sd_table[ which(sd_table$species_id == species_code), ]

}

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


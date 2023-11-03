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
  if(is.na(species_mean)) {
    stop("`species_mean` must be provided")
  }

  if(is.na(species_sd)) {
    stop("`species_sd` must be provided")
  }

  if(is.na(species_abundance)) {
    stop("`species_abundance` must be provided")
  }

  if(!is.numeric(species_abundance)) {
    stop("`species_abundance` must be numeric")
  }

  if(!(round(species_abundance) == species_abundance)) {
    stop("`species_abundance` must be a whole number")
  }

  population <- truncnorm::rtruncnorm(n = species_abundance, a = 1, b = Inf, mean = species_mean, sd = species_sd)


  population
}


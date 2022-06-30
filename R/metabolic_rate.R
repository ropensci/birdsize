#' Estimate individual-level basal metabolic rate
#'
#' @param mass mass in grams
#' @return estimated basal metabolic rate using pars from Fristoe 2015
#' @export
individual_metabolic_rate <- function(mass) {

  return(10.5 * (mass ^ .713))

}


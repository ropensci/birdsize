#' Estimate individual-level BMR
#'
#' Given an individual's body mass (in grams), use allometric scaling (Fristoe 2015) to estimate basal metabolic rate.
#'
#' @references \itemize{
#'   \item{Fristoe, T. S. (2015). Energy use by migrants and residents in North American breeding bird communities. Global Ecology and Biogeography, 24(4), 406–415. https://doi.org/10.1111/geb.12262}
#' }
#'
#' @param mass mass in grams
#' @return estimated basal metabolic rate
#' @export
#' @examples
#' individual_metabolic_rate(10)
individual_metabolic_rate <- function(mass) {

  return(10.5 * (mass ^ .713))

}


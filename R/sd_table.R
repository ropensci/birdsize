#' Species-level means for the mean and standard deviation of body size for species in the North American Breeding Bird Survey.
#'
#' A table of species-level mean values for the means and standard deviations of body size for species in the North American Breeding Bird Survey (Paradieck et al. 2019) based on records in the CRC Handbook of Avian Body Masses (2008). Standard deviations, where not provided in the CRC Handbook, are estimated based on a scaling relationship between a species' mean body size and the standard deviation of its body size (see also Thibault et al. 2010). Species-level means are reported for both the mean mean mass and mean standard deviation for all species.
#'
#' @format A data frame with 421 rows and 8 variables:
#' \describe{
#'   \item{species_id}{corresponds to the AOU used in Paradieck et al. (2019)}
#'   \item{genus}{genus, from Paradieck et al. (2019)}
#'   \item{species}{species, from Paradieck et al. (2019)}
#'   \item{mean_mass}{mean mass across all records in Dunning (2008) for that species, in grams}
#'   \item{mean_sd}{mean standard deviation of body mass across all records from Dunning (2008). For records for which a standard deviation is not provided, the standard deviation is estimated based on the scaling relationship derived from this dataset. Estimated standard deviations are calculated prior to taking species-level means.}
#'   \item{contains_estimates}{TRUE/FALSE whether or not the mean_sd column includes estimated standard deviations}
#' }
#' @references \itemize{
#'  \item{Dunning, J. B. (2008). CRC handbook of avian body masses (2nd ed.). CRC Press.}
#'   \item{Pardieck, K. L., Ziolkowski, D. J., Lutmerding, M., Aponte, V., & Hudson, M.-A. (2019). North American Breeding Bird Survey Dataset 1966—2018, version 2018.0. U.S. Geological Survey. https://doi.org/10.5066/P9HE8XYJ}
#'   \item{Thibault, K. M., White, E. P., Hurlbert, A. H., & Ernest, S. K. M. (2011). Multimodality in the individual size distributions of bird communities. Global Ecology and Biogeography, 20(1), 145–153. https://doi.org/10.1111/j.1466-8238.2010.00576.x}
#' }
#'
"sd_table"

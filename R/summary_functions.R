#' Calculate population-level summary statistics
#'
#' For a population (collection of individuals), calculate the total, mean, and standard deviation of abundance, biomass, and metabolic rate.
#'
#' For summary statistics grouped by species, year, or other variables, see [community_summarize].
#'
#' @param population a dataframe with one row per individual, and columns for `individual_mass` and `individual_bmr`, of the type produced by [pop_generate].
#'
#' @return a dataframe of summary metrics (see above) for this population
#' @export
#'
#' @examples
#' a_population <- pop_generate(10, mean_size= 20)
#' pop_summarize(a_population)
#' @importFrom dplyr group_by_at summarize ungroup n distinct
#' @importFrom stats sd
pop_summarize <- function(population) {

  summarize_vars <- c("individual_mass", "individual_bmr")

  id_vars <- colnames(population)[ which(!(colnames(population) %in% summarize_vars))]

  if(nrow(dplyr::distinct(population[,id_vars])) > 1) {
    warning("`population` data frame contains multiple id groups; population-wide summary may not work as expected!")
  }

  population %>%
    dplyr::group_by_at(id_vars) %>%
    dplyr::summarize(population_abundance = dplyr::n(),
                     population_biomass = sum(.data$individual_mass),
                     population_metabolic_rate = sum(.data$individual_bmr),
                     population_mean_size = mean(.data$individual_mass),
                     population_sd_size = sd(.data$individual_mass),
                     population_mean_bmr = mean(.data$individual_bmr),
                     population_sd_bmr = sd(.data$individual_bmr)) %>%
    dplyr::ungroup()

}

#' Compute grouped summary statistics for a community
#'
#' Calculate summary statistics (total, mean, and standard deviation for abundance, biomass, and metabolic rate) for a community, with flexible grouping options.
#'
#' For a dataframe of individuals from either numerous populations (of different species, or of the same species at different points in time), calculate summary statistics for each population or timestep, or for a different set of custom-specified grouping variables.
#'
#' @param community a dataframe with one row per individual, columns for `individual_mass` and `individual_bmr`, and any additional relevant grouping columns. For example, the output of [community_generate].
#' @param level a character string specifying whether to group according to "year", "species", "species_and_year", or "custom". To use "custom", specify the grouping variables using `id_vars`
#' @param id_vars a vector of column names to group by (if using `level = "custom"`)
#'
#' @return a dataframe with the total, mean, and standard deviation of body mass and metabolic rate summarized over the individuals in `community`, grouped according to the grouping variables.
#' @export
#'
#' @examples
#' bbs_route <- demo_route_raw %>% filter_bbs_survey()
#' community_data <- community_generate(bbs_route)
#' community_summarize(community_data)
#'
#' @importFrom dplyr group_by_at summarize ungroup n
#' @importFrom stats sd
#'
#'
community_summarize <- function(community, level = c("year", "species", "species_and_year", "custom"), id_vars = NULL) {

  # Check community has the variables to sum over

  if(!(all(c("individual_mass", "individual_bmr") %in% colnames(community)))) {
    stop("`community` is missing columns for body size and/or metabolic rate")
  }

  # Grouping

  level = match.arg(level, several.ok = F)


  id_vars <- switch(level,
                    year = c("routedataid", "countrynum", "statenum", "route", "rpid", "year"),
                    species = c("countrynum", "statenum", "route", "rpid", "aou","sim_species_id", "genus", "species", "mean_size", "sd_size"),
                    species_and_year = c("routedataid", "countrynum", "statenum", "route", "rpid", "year", "aou", "sim_species_id", "genus", "species",  "mean_size", "sd_size"),
                    custom = id_vars)

  if(level == "custom" && is.null(id_vars)) {
    stop("Set custom `id_vars` using `id_vars` argument")
  }

  id_vars <- id_vars[ which(id_vars %in% colnames(community))]

  if(length(id_vars) == 0) {
    stop("No `id_vars` present in `community`")
  }

  community <- identify_richness_designator(community)

  community %>%
    dplyr::group_by_at(c(id_vars, "species_designator")) %>%
    dplyr::summarize(
      total_abundance = dplyr::n(),
      total_biomass = sum(.data$individual_mass),
      total_metabolic_rate = sum(.data$individual_bmr),
      total_richness = length(unique(.data$richnessSpecies)),
      mean_individual_mass = mean(.data$individual_mass),
      sd_individual_mass = sd(.data$individual_mass),
      mean_metabolic_rate = mean(.data$individual_bmr),
      sd_metabolic_rate = sd(.data$individual_bmr)
    ) %>%
    dplyr::ungroup()

}


#' Identify the column to use to compute species richness
#'
#' @param community result of [community_generate]
#'
#' @return `community` having identified the best-guess column for species richness
#' @keywords internal
#'
#' @importFrom dplyr mutate
identify_richness_designator <- function(community) {

  if(!(any("aou" %in% colnames(community),
           "sim_species_id" %in% colnames(community),
           all(c("genus", "species") %in% colnames(community)),
           all(c("mean_size", "sd_size") %in% colnames(community))))) {

    community <- community %>%
      dplyr::mutate(
        richnessSpecies = NA,
        species_designator = "none_identified"
      )

    message("No identifiable species designator to calculate species richness!")
    return(community)
  }

  if("aou" %in% colnames(community)) {
    if(!anyNA(community$aou)) {
      community <- community %>%
        dplyr::mutate(
          richnessSpecies = .data$aou,
          species_designator = "aou"
        )
      return(community)
    }
  }

  if(all(c("genus", "species") %in% colnames(community))) {
    if(!anyNA(community$genus) && !anyNA(community$species)) {
      community <- community %>%
        dplyr::mutate(
          richnessSpecies = paste0(.data$genus, .data$species),
          species_designator = "scientificName"
        )
      return(community)
    }
  }

  if("sim_species_id" %in% colnames(community)) {
    if(!anyNA(community$sim_species_id)) {
      community <- community %>%
        dplyr::mutate(
          richnessSpecies = .data$sim_species_id,
          species_designator = "sim_species_id"
        )
      return(community)
    }
  }

  community <- community %>%
    dplyr::mutate(
      richnessSpecies = paste(.data$mean_size, .data$sd_size, sep = "_"),
      species_designator = "sim_parameters"
    )

  return(community)

}

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
#' @importFrom stats sd
pop_summarize <- function(population) {

  summarize_vars <- c("individual_mass", "individual_bmr")

  id_vars <- colnames(population)[ which(!(colnames(population) %in% summarize_vars))]

  if(nrow(unique(population[,id_vars])) > 1) {
    warning("`population` data frame contains multiple id groups; population-wide summary may not work as expected!")
  }

  # population %>%
  #   dplyr::group_by_at(id_vars) %>%
  #   dplyr::summarize(population_abundance = dplyr::n(),
  #                    population_biomass = sum(.data$individual_mass),
  #                    population_metabolic_rate = sum(.data$individual_bmr),
  #                    population_mean_size = mean(.data$individual_mass),
  #                    population_sd_size = sd(.data$individual_mass),
  #                    population_mean_bmr = mean(.data$individual_bmr),
  #                    population_sd_bmr = sd(.data$individual_bmr)) %>%
  #   dplyr::ungroup()

  unique_ids <- population[ , id_vars]
  unique_ids <- unique(unique_ids)

  out_data <- unique_ids
  out_data$population_abundance <- NA
  out_data$population_biomass <- NA
  out_data$population_metabolic_rate <- NA
  out_data$population_mean_size <- NA
  out_data$population_sd_size <- NA
  out_data$population_mean_bmr <- NA
  out_data$population_sd_bmr <- NA

  for(i in 1:nrow(unique_ids)) {

    this_id <- unique_ids[i, ]

    cnames <- colnames(unique_ids)

    this_pop <- population

    for(j in 1:length(cnames)) {

      this_col <- this_pop[ , cnames[j]]
      this_value <- unique_ids[i, cnames[j]]

      this_match <- (this_col == this_value)

      this_pop <- population[ which(is.na(this_match) | this_match), ]
    }

    out_data$population_abundance[i] <- nrow(this_pop)
    out_data$population_biomass[i] <- sum(this_pop$individual_mass)
    out_data$population_metabolic_rate[i] <- sum(this_pop$individual_bmr)
    out_data$population_mean_size[i] <- mean(this_pop$individual_mass)
    out_data$population_sd_size[i] <- sd(this_pop$individual_mass)
    out_data$population_mean_bmr[i] <- mean(this_pop$individual_bmr)
    out_data$population_sd_bmr[i] <- sd(this_pop$individual_bmr)

  }

  out_data
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
                    species = c("countrynum", "statenum", "route", "rpid", "aou","sim_species_id", "scientific_name", "mean_size", "sd_size"),
                    species_and_year = c("routedataid", "countrynum", "statenum", "route", "rpid", "year", "aou", "sim_species_id", "scientific_name",  "mean_size", "sd_size"),
                    custom = id_vars)

  if(level == "custom" && is.null(id_vars)) {
    stop("Set custom `id_vars` using `id_vars` argument")
  }

  id_vars <- id_vars[ which(id_vars %in% colnames(community))]

  if(length(id_vars) == 0) {
    stop("No `id_vars` present in `community`")
  }

  community <- identify_richness_designator(community)
  #
  #   community %>%
  #     dplyr::group_by_at(c(id_vars, "species_designator")) %>%
  #     dplyr::summarize(
  #       total_abundance = dplyr::n(),
  #       total_biomass = sum(.data$individual_mass),
  #       total_metabolic_rate = sum(.data$individual_bmr),
  #       total_richness = length(unique(.data$richnessSpecies)),
  #       mean_individual_mass = mean(.data$individual_mass),
  #       sd_individual_mass = sd(.data$individual_mass),
  #       mean_metabolic_rate = mean(.data$individual_bmr),
  #       sd_metabolic_rate = sd(.data$individual_bmr)
  #     ) %>%
  #     dplyr::ungroup()

  unique_designators <- community[ , c(id_vars, "species_designator")]
  unique_designators <- unique(unique_designators)

  out_data <- unique_designators

  out_data$total_abundance <- NA
  out_data$total_biomass <- NA
  out_data$total_metabolic_rate <- NA
  out_data$total_richness <- NA
  out_data$mean_individual_mass <- NA
  out_data$sd_individual_mass <- NA
  out_data$mean_metabolic_rate <- NA
  out_data$sd_metabolic_rate <- NA

  for(i in 1:nrow(unique_designators)) {

    this_subset <- community
    cnames <- colnames(unique_designators)

    for(j in 1:length(cnames)) {
      this_col <- this_subset[ , cnames[j]]
      this_value <- unique_designators[i, cnames[j]]
      this_match <- which(this_col == this_value)
      this_subset <- this_subset[this_match, ]
    }

    out_data$total_abundance[i] <- nrow(this_subset)
    out_data$total_biomass[i] <- sum(this_subset$individual_mass)
    out_data$total_metabolic_rate[i] <- sum(this_subset$individual_bmr)
    out_data$total_richness[i] <- length(unique(this_subset$richnessSpecies))
    out_data$mean_individual_mass[i] <- mean(this_subset$individual_mass)
    out_data$sd_individual_mass[i] <- sd(this_subset$individual_mass)
    out_data$mean_metabolic_rate[i] <- mean(this_subset$individual_bmr)
    out_data$sd_metabolic_rate[i] <- sd(this_subset$individual_bmr)

  }

  return(out_data)
}


#' Identify the column to use to compute species richness
#'
#' @param community result of [community_generate]
#'
#' @return `community` having identified the best-guess column for species richness
#' @keywords internal
#'
identify_richness_designator <- function(community) {

  if(!(any("aou" %in% colnames(community),
           "sim_species_id" %in% colnames(community),
           "scientific_name" %in% colnames(community),
           all(c("mean_size", "sd_size") %in% colnames(community))))) {

    #     community <- community %>%
    #       dplyr::mutate(
    #         richnessSpecies = NA,
    #         species_designator = "none_identified"
    #       )

    community$richnessSpecies <- NA
    community$species_designator <- "none_identified"

    message("No identifiable species designator to calculate species richness!")
    return(community)
  }

  if("aou" %in% colnames(community)) {
    if(!anyNA(community$aou)) {
      # community <- community %>%
      #   dplyr::mutate(
      #     richnessSpecies = .data$aou,
      #     species_designator = "aou"
      #   )

      community$richnessSpecies <- community$aou
      community$species_designator <- "aou"

      return(community)
    }
  }

  if("scientific_name" %in% colnames(community)) {
    if(!anyNA(community$scientific_name)) {
      # community <- community %>%
      #   dplyr::mutate(
      #     richnessSpecies = paste0(.data$genus, .data$species),
      #     species_designator = "scientificName"
      #   )
      community$richnessSpecies <- community$scientific_name
      community$species_designator <- "scientificName"
      return(community)
    }
  }

  if("sim_species_id" %in% colnames(community)) {
    if(!anyNA(community$sim_species_id)) {
      # community <- community %>%
      #   dplyr::mutate(
      #     richnessSpecies = .data$sim_species_id,
      #     species_designator = "sim_species_id"
      #   )
      community$richnessSpecies <- community$sim_species_id
      community$species_designator <- "sim_species_id"
      return(community)
    }
  }

  # community <- community %>%
  #   dplyr::mutate(
  #     richnessSpecies = paste(.data$mean_size, .data$sd_size, sep = "_"),
  #     species_designator = "sim_parameters"
  #   )
  community$richnessSpecies <- paste(community$mean_size, community$sd_size, sep = "_")
  community$species_designator <- "sim_parameters"
  return(community)

}

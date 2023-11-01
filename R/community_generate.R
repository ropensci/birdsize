#' Simulate individual measurements for many populations
#'
#' For a community (i.e. a collection of populations of different species, or of the same species at different points in time or locations, etc), simulate individual-level size and metabolic rate measurements.
#'
#' @param community_data_table dataframe containing at least one of `AOU`, `scientific_name`, or `mean_size` and a column for species abundances
#' @param abundance_column_name character, the name of the column with species abundances. Defaults to "speciestotal".
#' @return a dataframe one row per individual, all columns from `community_data_table`, and additional columns for species attributes.
#'
#' Specifically:
#'
#' * `AOU`: the AOU, if provided
#' *  `sim_species_id`: the `sim_species_id` if provided
#' * `genus`: the genus associated with the AOU if provided, or the genus if provided
#' *  `species`: the species associated with the AOU if provided, or the species if provided
#' *  `individual_mass`: the simulated body mass (in grams) for this individual
#' *  `individual_bmr`: the simulated basal metabolic rate for this individual
#' *  `mean_size`: the mean body mass for this species (i.e. the parameter used for simulation)
#' *  `sd_size`: the standard deviation of body mass for this species (i.e. the parameter used for simulation)
#' *  `abundance`: the number of individuals simulated of this species (i.e. parameter used for simulation)
#' *  `sd_method`: the method for finding the standard deviation for body mass for this species
#' *  `scientific_name`: the scientific name
#' @export
#'
#' @examples
#'
#' demo_community <- community_generate(demo_route_clean)
#' head(demo_community)

community_generate <- function(community_data_table, abundance_column_name = "speciestotal") {

  colnames(community_data_table) <- tolower(colnames(community_data_table))
  colnames(community_data_table)[ which(colnames(community_data_table) == "aou")] <- "AOU"

  community_vars <- colnames(community_data_table)

  # Check that the necessary variables are provided

  contains_AOU <- "AOU" %in% community_vars
  contains_scientific_name <- "scientific_name" %in% community_vars
  contains_mean <- "mean_size" %in% community_vars
  contains_abundance <- abundance_column_name %in% community_vars

  if(!contains_abundance) {
    stop("abundance column is required. If the name is not `speciestotal` specify using the `abundance_column_name` argument")
  }

  if(!(contains_AOU | contains_mean | contains_scientific_name)) {
    stop("At least one of `AOU`, `scientific_name`, or `mean_size` is required")
  }

  # Identify ID/grouping columns and columns to pass to sim fxns.

  # community_data_table <- community_data_table %>%
  #   dplyr::mutate(rejoining_id = dplyr::row_number(),
  #                 abundance = .data[[abundance_column_name]])

  community_data_table$rejoining_id <- 1:nrow(community_data_table)
  abundance_values <- as.matrix(community_data_table[ , abundance_column_name])
  abundance_values <- as.vector(abundance_values[,1])
  community_data_table$abundance = abundance_values

  community_vars_mod <- colnames(community_data_table)

  possible_sim_vars <- c("abundance", "AOU", "mean_size", "sd_size", "sim_species_id", "scientific_name")

  id_vars <- c(community_vars_mod[ which(!(community_vars_mod %in% possible_sim_vars))])

  sim_vars <- c(community_vars_mod[ which(community_vars_mod %in% possible_sim_vars)])

  # # For the cols to pass in, add NA columns for any of the variables that the sim fxns can use that aren't included
  na_vars <- possible_sim_vars[ which(!(possible_sim_vars %in% community_vars_mod))]

  na_table <- matrix(nrow = nrow(community_data_table), ncol = length(na_vars))
  na_table <-  as.data.frame(na_table)
  colnames(na_table) <- na_vars

  # Split into 2 tables, one with ID cols and one for the cols to pass in.
  ids_table <- as.data.frame(community_data_table[,id_vars])
  colnames(ids_table) <- id_vars


  sim_vars_table <- community_data_table[ , c(sim_vars, "rejoining_id")]
  sim_vars_table <-  cbind(sim_vars_table, na_table)

  # Draw populations
  # populations <- purrr::pmap_dfr(sim_vars_table,
  #                                pop_generate,
  #                                .id = "rejoining_id") %>%
  #   dplyr::mutate(rejoining_id = as.numeric(.data$rejoining_id))

  pop_generate_rejoining <- function(this_id, sim_vars_table) {

    this_row <- sim_vars_table[ sim_vars_table$rejoining_id == this_id, ]

    this_population <- pop_generate(abundance = this_row$abundance[1],
                                    AOU = this_row$AOU[1],
                                    scientific_name = this_row$scientific_name[1],
                                    mean_size = this_row$mean_size[1],
                                    sd_size = this_row$sd_size[1],
                                    sim_species_id = this_row$sim_species_id[1])


    this_population$rejoining_id = this_id

    this_population

  }

  populations_list <- apply(as.matrix(sim_vars_table$rejoining_id), MARGIN = 1, FUN = pop_generate_rejoining, sim_vars_table = sim_vars_table)

  populations <- do.call("rbind", populations_list)

  # community <- suppressMessages(dplyr::left_join(ids_table, populations) %>% dplyr::select(-.data$rejoining_id))

  community <- merge(ids_table, populations, by = "rejoining_id") # here is where it goes from 300 to 900 rows
  community <- community[ , -which(colnames(community) == "rejoining_id")]


  return(community)

}



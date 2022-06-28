#' Prepare community data for sim fxns
#'
#' @param community_data_table dataframe containing at least EITHER `aou` or `mean` and a column for species abundances
#' @param abundance_column_name character, the name of the column with species abundances. Defaults to "speciestotal"
#'
#' @return list of two dataframes: $ids_table contains all columns in community_data_table not passed to sim functions, and $sim_vars_table contains columns to pass to the sim functions.
#'
#' @importFrom dplyr mutate
#' @export
#' @examples
#' community_data <- new_hartford_raw %>%
#' dplyr::filter(year == 1994) %>%
#' filter_bbs_survey()
#'
#' prepare_community(community_data)
prepare_community <- function(community_data_table, abundance_column_name = "speciestotal") {

  colnames(community_data_table) <- tolower(colnames(community_data_table))

  community_vars <- colnames(community_data_table)

  # Check that the necessary variables are provided

  contains_aou <- "aou" %in% community_vars
  contains_mean <- "mean_size" %in% community_vars
  contains_abundance <- abundance_column_name %in% community_vars

  if(!contains_abundance) {
    warning("abundance column is required. If the name is not `speciestotal` specify using the `abundance_column_name` argument")
  }

  if(!(contains_aou | contains_mean)) {
    warning("At least one of `aou` or `mean_size` is required")
  }

  # Identify ID/grouping columns and columns to pass to sim fxns.

  community_data_table <- community_data_table %>%
    dplyr::mutate(rejoining_id = dplyr::row_number(),
                  abundance = .data[[abundance_column_name]])

  community_vars_mod <- colnames(community_data_table)

  possible_sim_vars <- c("abundance", "aou", "mean_size", "sd_size")

  id_vars <- c(community_vars_mod[ which(!(community_vars_mod %in% possible_sim_vars))])

  sim_vars <- c(community_vars_mod[ which(community_vars_mod %in% possible_sim_vars)])

  # For the cols to pass in, add NA columns for any of the variables that the sim fxns can use that aren't included
  na_vars <- possible_sim_vars[ which(!(possible_sim_vars %in% community_vars_mod))]

  na_table <- matrix(nrow = nrow(community_data_table), ncol = length(na_vars)) %>%
    as.data.frame()
  colnames(na_table) <- na_vars

  # Split into 2 tables, one with ID cols and one for the cols to pass in.
  ids_table <- community_data_table[,id_vars]

  sim_vars_table <- community_data_table[ ,sim_vars] %>%
    cbind(na_table)

  return(list(ids_table = ids_table,
              sim_vars_table = sim_vars_table))
}

#' Generate samples community-wide
#'
#' @param community_tables result of [prepare_community]
#'
#' @return dataframe
#' @export
#' @importFrom purrr pmap_dfr
#' @importFrom dplyr mutate left_join
#'
#' @examples
#' community_data <- new_hartford_raw %>%
#' dplyr::filter(year == 1994) %>%
#' filter_bbs_survey() %>%
#' prepare_community()
#'
#' community_generate(community_data)

community_generate <- function(community_tables) {

  populations <- purrr::pmap_dfr(community_tables$sim_vars_table,
                                 pop_generate,
                                 .id = "rejoining_id") %>%
    dplyr::mutate(rejoining_id = as.numeric(.data$rejoining_id))

  community <- dplyr::left_join(community_tables$ids_table, populations)

  return(community)

}

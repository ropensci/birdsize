#' Get SD parameters from linear model
#'
#' @param raw_size_data raw size data
#'
#' @return list of slope and intercept from lm
#'
#'
#' @importFrom dplyr filter mutate
#' @importFrom rlang .data
#' @importFrom stats lm
get_sd_parameters <- function(raw_size_data) {

  sp_for_sd <- dplyr::filter(raw_size_data,
                             !is.na(.data$sd)) %>%
    dplyr::mutate(mass = as.numeric(.data$mass),
                  sd = as.numeric(.data$sd)) %>%
    dplyr::mutate(var = .data$sd^2) %>%
    dplyr::mutate(log_m = log(.data$mass),
                  log_var = log(.data$var))

  sd_fit <- stats::lm(sp_for_sd, formula = log_var ~ log_m)

  intercept <- exp(sd_fit$coefficients[[1]])
  slope <- sd_fit$coefficient[[2]]

  return(list(intercept = intercept,
              slope = slope))

}


#' Estimate SD given mean and optional pars
#'
#' @param sp_mean mean to estimate from
#' @param pars as list of slope, intercept
#'
#' @return estimated sd
#'
#'
estimate_sd <- function(sp_mean, pars) {


  if(is.list(pars)) {

    fitted_sd = sqrt(pars$intercept * (sp_mean ^ pars$slope))

  } else {

    fitted_sd = sqrt(.0055 * (sp_mean ^ 1.98))
  }

  return(fitted_sd)

}

#' Clean raw size data
#'
#' Updates names of species whose names have changed since 2010.
#'
#' @param raw_size_data raw size data
#'
#' @return cleaned data
#'
#'
#' @importFrom dplyr select mutate filter bind_rows
#' @importFrom rlang .data
clean_sp_size_data <- function(raw_size_data) {

  colnames(raw_size_data)[1] <- "species_id"

  sp_clean <- raw_size_data %>%
    dplyr::select(-.data$english_common_name, -.data$sporder, -.data$family) %>%
    dplyr::mutate(mass = as.numeric(.data$mass))

  name_change <- dplyr::filter(sp_clean, .data$not_in_dunning == 1)

  sp_clean <- dplyr::filter(sp_clean, is.na(.data$not_in_dunning)) %>%
    dplyr::mutate(added_flag = NA)

  for(i in 1:nrow(name_change)) {

    if(!is.na(name_change$close_subspecies[i])) {
      matched_rows <- dplyr::filter(sp_clean,
                                    .data$genus == name_change$close_genus[i],
                                    .data$species == name_change$close_species[i],
                                    .data$subspecies == name_change$close_subspecies[i])
    } else {
      matched_rows <- dplyr::filter(sp_clean,
                                    .data$genus == name_change$close_genus[i],
                                    .data$species == name_change$close_species[i])
    }

    sp_to_add <- matched_rows %>%
      dplyr:: mutate(species_id = name_change$species_id[i],
                     id = name_change$id[i],
                     added_flag = 1)

    sp_clean <- dplyr::bind_rows(sp_clean, sp_to_add)

  }

  return(sp_clean)
}


#' Add estimates for SDs
#'
#' @param clean_size_data cleaned data
#' @param sd_pars parameters as list of slope, intercept
#'
#' @return clean_size_data with filled in sds + column to flag if an estimate was added
#'
#'
add_estimated_sds <- function(clean_size_data, sd_pars) {

  clean_size_data$estimated_sd <- FALSE

  for(i in 1:nrow(clean_size_data)) {

    if(is.na(clean_size_data$sd[i])) {
      clean_size_data$estimated_sd[i] =  TRUE
      clean_size_data$sd[i] = estimate_sd(clean_size_data$mass[i], pars = sd_pars)
    } else {
      clean_size_data$estimated_sd[i] = FALSE
    }

  }

  return(clean_size_data)

}

#' Get species' mean size and sd
#'
#' @param sd_dat Dat with estimated sds
#'
#' @return Summarized to species mean size and sd
#'
#'
#' @importFrom dplyr group_by summarize ungroup
#' @importFrom rlang .data
get_sp_mean_size <- function(sd_dat) {

  sp_means <- sd_dat %>%
    dplyr::group_by(.data$species_id, .data$genus, .data$species) %>%
    dplyr::summarize(mean_mass = mean(.data$mass),
                     mean_sd = mean(.data$sd, na.rm = F),
                     contains_estimates = any(.data$estimated_sd)) %>%
    dplyr::ungroup()


}


test_that("error catching works", {

  bbs_data <- new_hartford_raw %>%
    filter_bbs_survey()

  no_aou <- bbs_data %>%
    dplyr::select(-aou)

  expect_error(community_generate(no_aou), regexp = "At least one of `aou`, `genus` and `species`, or `mean_size` is required")

  no_abundance <- bbs_data %>%
    dplyr::select(-speciestotal)

  expect_error(community_generate(no_abundance), regexp = "abundance column is required. If the name is not `speciestotal` specify using the `abundance_column_name` argument")

  misnamed_abundance <- bbs_data %>%
    dplyr::rename(abund = speciestotal)

  expect_error(community_generate(misnamed_abundance), regexp = "abundance column is required. If the name is not `speciestotal` specify using the `abundance_column_name` argument")


})
test_that("simulation from AOU works", {

  bbs_data <- new_hartford_raw %>%
    filter_bbs_survey()

  short_bbs_data <- bbs_data %>%
    dplyr::filter(year == 2019)

  set.seed(22)
  bbs_data_sims <- community_generate(short_bbs_data)

  expect_true(ncol(bbs_data_sims) == 23)
  expect_true(nrow(bbs_data_sims) == sum(short_bbs_data$speciestotal))
  expect_false(anyNA(bbs_data_sims))
  expect_true(all(round(bbs_data_sims$individual_mass[1:5]) == c(5824, 7147, 121, 120, 119)))


  })

test_that("simulation from AOU works with nonstandard abund name", {

  bbs_data <- new_hartford_raw %>%
    filter_bbs_survey()

  short_bbs_data <- bbs_data %>%
    dplyr::filter(year == 2019) %>%
    dplyr::rename(abund = speciestotal)

  set.seed(22)
  bbs_data_sims <- community_generate(short_bbs_data, abundance_column_name = "abund")

  expect_true(ncol(bbs_data_sims) == 23)
  expect_true(nrow(bbs_data_sims) == sum(short_bbs_data$abund))
  expect_false(anyNA(bbs_data_sims))
  expect_true(all(round(bbs_data_sims$individual_mass[1:5]) == c(5824, 7147, 121, 120, 119)))
  expect_true(all(bbs_data_sims$sd_method == "AOU lookup"))

})

test_that("simulation from species name works", {

  bbs_data <- new_hartford_raw %>%
    filter_bbs_survey()

  short_bbs_data <- bbs_data %>%
    dplyr::filter(year == 2019) %>%
    dplyr::left_join(dplyr::select(birdsize::sd_table, aou, genus, species)) %>%
    dplyr::select(-aou)

  set.seed(22)
  bbs_data_sims <- community_generate(short_bbs_data)

  expect_true(ncol(bbs_data_sims) == 23)
  expect_true(nrow(bbs_data_sims) == sum(short_bbs_data$speciestotal))
  expect_false(anyNA(bbs_data_sims))
  expect_true(all(round(bbs_data_sims$individual_mass[1:5]) == c(5824, 7147, 121, 120, 119)))
  expect_true(all(bbs_data_sims$sd_method == "Scientific name lookup"))


})



test_that("simulation from mean size works", {

  bbs_data <- new_hartford_raw %>%
    filter_bbs_survey()

  short_bbs_data <- bbs_data %>%
    dplyr::filter(year == 2019) %>%
    dplyr::left_join(dplyr::select(birdsize::sd_table, aou, mean_mass)) %>%
    dplyr::select(-aou) %>%
    dplyr::rename(mean_size = mean_mass)

  set.seed(22)
  bbs_data_sims <- community_generate(short_bbs_data)

  expect_true(ncol(bbs_data_sims) == 23)
  expect_true(nrow(bbs_data_sims) == sum(short_bbs_data$speciestotal))
  expect_true(all(is.na(bbs_data_sims$aou)))
  expect_true(all(is.na(bbs_data_sims$species)))
  expect_true(all(is.na(bbs_data_sims$genus)))
  expect_true(all(round(bbs_data_sims$individual_mass[1:5]) == c(5824, 7147, 127, 121, 117)))
  expect_true(all(bbs_data_sims$sd_method == "SD estimated from mean"))

})


test_that("simulation from mean and sd size works", {

  bbs_data <- new_hartford_raw %>%
    filter_bbs_survey()

  short_bbs_data <- bbs_data %>%
    dplyr::filter(year == 2019) %>%
    dplyr::left_join(dplyr::select(birdsize::sd_table, aou, mean_mass, mean_sd)) %>%
    dplyr::select(-aou) %>%
    dplyr::rename(mean_size = mean_mass,
                  sd_size = mean_sd)

  set.seed(22)
  bbs_data_sims <- community_generate(short_bbs_data)

  expect_true(ncol(bbs_data_sims) == 23)
  expect_true(nrow(bbs_data_sims) == sum(short_bbs_data$speciestotal))
  expect_true(all(is.na(bbs_data_sims$aou)))
  expect_true(all(is.na(bbs_data_sims$species)))
  expect_true(all(is.na(bbs_data_sims$genus)))
  expect_true(all(round(bbs_data_sims$individual_mass[1:5]) == c(5824, 7147, 121, 120, 119)))
  expect_true(all(bbs_data_sims$sd_method == "Mean and SD provided"))

})


test_that("simulation from toy df works", {

  toy_df <- data.frame(
    speciestotal = c(10, 10, 5, 5, 5),
    mean_size = c(100, 50, 45, 20, 10),
    sim_species_id = c(1:5)
  )

  set.seed(22)
  toy_sims <- community_generate(toy_df)

  expect_true(ncol(toy_sims) == 10)
  expect_true(nrow(toy_sims) == sum(toy_df$speciestotal))
  expect_true(all(is.na(toy_sims$aou)))
  expect_true(all(is.na(toy_sims$species)))
  expect_true(all(is.na(toy_sims$genus)))
  expect_false(any(is.na(toy_sims$sim_species_id)))
  expect_true(all(round(toy_sims$individual_mass[1:5]) == c(96, 118, 107, 102, 99)))
  expect_true(all(toy_sims$sd_method == "SD estimated from mean"))

})

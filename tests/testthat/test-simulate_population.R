test_that("simulate_population errors work", {

  expect_error(simulate_population(species_mean = 100, species_sd = 10), regexp = "`species_abundance` must be provided")

  expect_error(simulate_population(species_abundance = "10", species_mean = 100, species_sd = 10), regexp = "`species_abundance` must be numeric")

  expect_error(simulate_population(species_abundance = 10.5, species_mean = 100, species_sd = 10), regexp = "`species_abundance` must be a whole number")

  expect_error(simulate_population(species_abundance = 10), regexp = "Either `species_mean` or `species_code` must be provided.")

  expect_error(simulate_population(species_abundance = 10, species_code = "abc"), regexp = "`species_code` is invalid.")

  expect_error(simulate_population(species_abundance = 10, species_code = 1000), regexp = "`species_code` is invalid.")

  expect_warning(simulate_population(species_abundance = 10, species_mean = 10, species_sd = 2, species_code = 1420), regexp = "Both `species_code` and `species_mean` are provided; using `species_mean` and overwriting `species_code` to NA.")

})


test_that("simulate_population works given mean and sd", {

  set.seed(22)

  a_population <- simulate_population(species_abundance = 100, species_mean = 10, species_sd = 2)

  expect_true(is.na(a_population$species_code[1]))
  expect_true(all(a_population$species_mean_mass == 10))
  expect_true(all(a_population$species_sd_mass == 2))
  expect_true(all(a_population$species_abundance == 100))
  expect_true(all(a_population$simulation_method == "mean and sd provided"))
  expect_true(all(round(a_population$individual_mass)[1:5] == c(9, 15, 12, 11, 10)))

})


test_that("simulate_population works given only mean", {


  set.seed(22)

  a_population <- simulate_population(species_abundance = 100, species_mean = 10)

  expect_true(is.na(a_population$species_code[1]))
  expect_true(all(a_population$species_mean_mass == 10))
  expect_true(all(a_population$species_sd_mass == estimate_sd(10)))
  expect_true(all(a_population$species_abundance == 100))
  expect_true(all(a_population$simulation_method == "sd estimated from mean provided"))
  expect_true(all(round(a_population$individual_mass)[1:5] == c(10, 12, 11, 10, 10)))


  # Here including a check that, given a different seed, we get the same metadata but different simulated values.

  set.seed(13)

  a_population <- simulate_population(species_abundance = 100, species_mean = 10)

  expect_true(is.na(a_population$species_code[1]))
  expect_true(all(a_population$species_mean_mass == 10))
  expect_true(all(a_population$species_sd_mass == estimate_sd(10)))
  expect_true(all(a_population$species_abundance == 100))
  expect_false(all(round(a_population$individual_mass)[1:5] == c(10, 12, 11, 10, 10)))

})


test_that("simulate_population works given species code", {

  set.seed(22)

  a_population <- simulate_population(species_abundance = 100, species_code = 1420)

  this_pars <- dplyr::filter(sd_table, species_id == 1420)

  expect_true(all(a_population$species_code == 1420))
  expect_true(all(a_population$species_mean_mass == this_pars$mean_mass))
  expect_true(all(a_population$species_sd_mass == this_pars$mean_sd))
  expect_true(all(a_population$species_abundance == 100))
  expect_true(all(a_population$simulation_method == "species code provided"))
  expect_true(all(round(a_population$individual_mass)[1:5] == c(11, 14, 13, 12, 12)))

})


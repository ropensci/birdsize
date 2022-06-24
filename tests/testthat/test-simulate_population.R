test_that("pop_generate errors work", {
  expect_error(pop_generate(mean_size = 100, sd_size = 10), regexp = "`species_abundance` must be provided")

  expect_error(pop_generate(abundance = "10", mean_size = 100, sd_size = 10), regexp = "`species_abundance` must be numeric")

  expect_error(pop_generate(abundance = 10.5, mean_size = 100, sd_size = 10), regexp = "`species_abundance` must be a whole number")

  expect_error(pop_generate(abundance = 10))

  expect_error(pop_generate(abundance = 10, aou = "abc"), regexp = "`species_code` is invalid.")

  expect_error(pop_generate(abundance = 10, aou = 1000), regexp = "`species_code` is invalid.")
})


test_that("pop_generate works given mean and sd", {
  set.seed(22)

  a_population <- pop_generate(abundance = 100, mean_size = 10, sd_size = 2)

  expect_true(is.na(a_population$aou[1]))
  expect_true(all(a_population$species_mean_mass == 10))
  expect_true(all(a_population$species_sd_mass == 2))
  expect_true(all(a_population$abundance == 100))
  expect_true(all(a_population$simulation_method == "mean and sd provided"))
  expect_true(all(round(a_population$individual_mass)[1:5] == c(9, 15, 12, 11, 10)))
})


test_that("pop_generate works given only mean", {
  set.seed(22)

  a_population <- pop_generate(abundance = 100, mean_size = 10)

  expect_true(is.na(a_population$aou[1]))
  expect_true(all(a_population$species_mean_mass == 10))
  expect_true(all(a_population$species_sd_mass == birdsize:::species_estimate_sd(10)))
  expect_true(all(a_population$abundance == 100))
  expect_true(all(a_population$simulation_method == "sd estimated from mean provided"))
  expect_true(all(round(a_population$individual_mass)[1:5] == c(10, 12, 11, 10, 10)))


  # Here including a check that, given a different seed, we get the same metadata but different simulated values.

  set.seed(13)

  a_population <- pop_generate(abundance = 100, mean_size = 10)

  expect_true(is.na(a_population$aou[1]))
  expect_true(all(a_population$species_mean_mass == 10))
  expect_true(all(a_population$species_sd_mass == birdsize:::species_estimate_sd(10)))
  expect_true(all(a_population$abundance == 100))
  expect_false(all(round(a_population$individual_mass)[1:5] == c(10, 12, 11, 10, 10)))
})


test_that("pop_generate works given species code", {
  set.seed(22)

  a_population <- pop_generate(abundance = 100, aou = 2940)

  this_pars <- dplyr::filter(sd_table, aou == 2940)

  expect_true(all(a_population$aou == 2940))
  expect_true(all(a_population$species_mean_mass == this_pars$mean_mass))
  expect_true(all(a_population$species_sd_mass == this_pars$mean_sd))
  expect_true(all(a_population$abundance == 100))
  expect_true(all(a_population$simulation_method == "species code provided"))
  expect_true(all(round(a_population$individual_mass)[1:5] == c(159, 202, 181, 171, 163)))
})



test_that("pop_generate works given species code *and* species mean", {
  set.seed(22)

  a_population <- pop_generate(abundance = 100, aou = 6340, mean_size = 50)

  this_pars <- dplyr::filter(sd_table, aou == 6340)

  expect_true(all(a_population$aou == 6340))
  expect_true(all(a_population$species_mean_mass == this_pars$mean_mass))
  expect_true(all(a_population$species_sd_mass == this_pars$mean_sd))
  expect_true(all(a_population$abundance == 100))
  expect_true(all(a_population$simulation_method == "species code provided"))
  expect_true(all(round(a_population$individual_mass)[1:5] == c(12, 16, 14, 13, 13)))
  expect_true(mean(a_population$individual_mass) < 15)
})

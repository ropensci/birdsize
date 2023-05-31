test_that("ind_draw errors work", {
  expect_error(ind_draw(species_mean = 10, species_abundance = 100), regexp = "`species_sd` must be provided")

  expect_error(ind_draw(species_sd = 10, species_abundance = 100), regexp = "`species_mean` must be provided")

  expect_error(ind_draw(species_sd = 10, species_mean = 100), regexp = "`species_abundance` must be provided")

  expect_error(ind_draw(species_abundance = 10.5, species_sd = 10, species_mean = 100), regexp = "`species_abundance` must be a whole number")

})
test_that("ind_draw works given toy inputs", {
  spmean <- 100
  spsd <- 6
  spabund <- 100

  set.seed(22)
  spind <- ind_draw(spmean, spsd, spabund)

  rounded_spind <- round(spind)

  expect_true(all(rounded_spind[1:5] == c(97, 115, 106, 102, 99)))
})


test_that("ind_draw works given near zero inputs", {
  spmean <- 2
  spsd <- 1
  spabund <- 100

  set.seed(22)

  spind <- ind_draw(spmean, spsd, spabund)

  rounded_spind <- round(spind)

  expect_false(min(spind) < 1)

  expect_true(all(rounded_spind[1:5] == c(1, 4, 3, 2, 2)))
})

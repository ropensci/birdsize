test_that("spID lookup works", {

  # Look up parameters for a species that does exist
  existing_pars <- lookup_species_pars(1420)

  expect_identical(existing_pars, dplyr::filter(sd_table, species_id == 1420))

  # You should get an error if you try to look up parameters for a species that doesn't exist
  expect_error(lookup_species_pars(3.14), regexp = "`species_code` is invalid.")
  expect_error(lookup_species_pars(100000), regexp = "`species_code` is invalid.")

})

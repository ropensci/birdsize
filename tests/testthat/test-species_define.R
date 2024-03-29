test_that("spID lookup works", {
  # Look up parameters for a species that does exist
  existing_pars <- species_lookup(2930)
  row.names(existing_pars) <- NULL

  comparison_pars <- sd_table[sd_table$AOU == 2930, ]
  row.names(comparison_pars) <- NULL

  expect_identical(existing_pars, comparison_pars)

  # You should get an error if you try to look up parameters for a species that doesn't exist
  expect_error(species_lookup(3.14), regexp = "`AOU` is invalid.")
  expect_error(species_lookup(100000), regexp = "`AOU` is invalid.")
})


test_that("genus species lookup works", {
  # Look up parameters for a species that does exist
  existing_pars <- species_lookup(scientific_name = "selasphorus calliope")
  row.names(existing_pars) <- NULL

  comparison_pars <- sd_table[sd_table$AOU == 4360, ]
  row.names(comparison_pars) <- NULL

  expect_identical(existing_pars, comparison_pars)

  # Case doesn't matter
  existing_pars <- species_lookup(scientific_name = "SELASPHORUS cAlliOpe")

  # You should get an error if you try to look up parameters for a species that doesn't exist
  expect_error(species_lookup(scientific_name = "frumious bandersnatch"), regexp = "Scientific name is invalid.")
})

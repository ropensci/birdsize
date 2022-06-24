test_that("raw_masses has expected properties", {
  raw_masses <- raw_masses

  expect_true(nrow(raw_masses) == 928)
  expect_true(ncol(raw_masses) == 19)

  expect_true(sum(is.na(raw_masses$sd)) == 353)

  expect_true(sum(is.na(raw_masses$mass)) == 17)
})

test_that("resolving taxonomic changes works as expected", {
  cleaned_dat <- birdsize:::clean_sp_size_data(raw_masses)

  expect_true(nrow(cleaned_dat) == 1249)
  expect_true(ncol(cleaned_dat) == 17)

  raw_no_changes <- dplyr::filter(raw_masses, is.na(not_in_dunning)) %>%
    dplyr::select(-english_common_name, -sporder, -family)
  cleaned_no_changes <- dplyr::filter(cleaned_dat, is.na(added_flag)) %>%
    dplyr::select(-added_flag)

  expect_identical(raw_no_changes, cleaned_no_changes)
})

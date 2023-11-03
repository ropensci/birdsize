test_that("raw_masses has expected properties", {
  # raw_masses <- raw_masses

  expect_true(nrow(raw_masses) == 928)
  expect_true(ncol(raw_masses) == 19)

  expect_true(sum(is.na(raw_masses$sd)) == 353)

  expect_true(sum(is.na(raw_masses$mass)) == 17)
})

test_that("resolving taxonomic changes works as expected", {
  cleaned_dat <- birdsize:::clean_sp_size_data(raw_masses)

  expect_true(nrow(cleaned_dat) == 1249)
  expect_true(ncol(cleaned_dat) == 17)

  raw_no_changes <- raw_masses[is.na(raw_masses$not_in_dunning), ]
  keep_columns <- which(!(colnames(raw_no_changes) %in% c("english_common_name", "sporder", "family")))
  raw_no_changes <- raw_no_changes[, keep_columns]


  cleaned_no_changes <- cleaned_dat[is.na(cleaned_dat$added_flag), ]
  cleaned_no_changes <- cleaned_no_changes[, which(colnames(cleaned_no_changes) != "added_flag")]
  row.names(cleaned_no_changes) <- as.integer(row.names(cleaned_no_changes))

  expect_identical(raw_no_changes, cleaned_no_changes)
})

test_that("sd_table is up to date", {
  generated_sd_table <- birdsize:::generate_sd_table(raw_masses)
  row.names(generated_sd_table) <- NULL

  included_sd_table <- sd_table
  row.names(included_sd_table) <- NULL

  expect_equal(included_sd_table, generated_sd_table)
})

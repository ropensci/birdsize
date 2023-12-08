test_that("filter bbs data works", {
  bad_bbs_data <- demo_route_raw[, colnames(demo_route_raw) != "AOU"]

  expect_error(filter_bbs_survey(bad_bbs_data), regexp = "`AOU` column is required!")

  raw_bbs_data <- demo_route_raw

  bad_species <- which(raw_bbs_data$AOU %in% birdsize::unidentified_species$AOU |
    raw_bbs_data$AOU %in% birdsize::nontarget_species$AOU)

  clean_bbs_data <- filter_bbs_survey(raw_bbs_data)

  expect_true(nrow(raw_bbs_data) - nrow(clean_bbs_data) == length(bad_species))


  expect_true(all(raw_bbs_data[-bad_species, ] == clean_bbs_data))
})

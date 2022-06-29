test_that("filter bbs data works", {


  bad_bbs_data <- new_hartford_raw %>%
    dplyr::select(-aou)

  expect_error(filter_bbs_survey(bad_bbs_data), regexp = "`aou` column is required!")

  raw_bbs_data <- new_hartford_raw

  bad_species <- which(raw_bbs_data$aou %in% birdsize::unidentified_species$aou |
                         raw_bbs_data$aou %in% birdsize::nontarget_species$aou)

  clean_bbs_data <- raw_bbs_data %>%
    filter_bbs_survey()

  expect_true(nrow(raw_bbs_data) - nrow(clean_bbs_data) == length(bad_species))


  expect_true(all(raw_bbs_data[-bad_species,] == clean_bbs_data))



  })


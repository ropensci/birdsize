test_that("estimating bmr works", {


  expect_equal(round(individual_metabolic_rate(10)), 54)


})

test_that("bmr is returned with populations", {

  a_population <- pop_generate(10, mean_size= 20)

  expect_true("individual_bmr" %in% colnames(a_population))

  expect_true(all(a_population$individual_bmr == individual_metabolic_rate(a_population$individual_mass)))

})


test_that("bmr is returned with communities", {


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


  expect_true("individual_bmr" %in% colnames(bbs_data_sims))

  expect_true(all(bbs_data_sims$individual_bmr == individual_metabolic_rate(bbs_data_sims$individual_mass)))

})

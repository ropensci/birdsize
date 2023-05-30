test_that("pop_summarize works", {

  a_synthetic_population <- pop_generate(10, mean_size = 10, sd_size = .1)

  a_synthetic_population_summary <- pop_summarize(a_synthetic_population)

  expect_true(all(dim(a_synthetic_population_summary) == c(1, 14)))
  expect_true(a_synthetic_population_summary$abundance[1] == 10)
  expect_true(anyNA(a_synthetic_population_summary))

  an_aou_population <- pop_generate(10, aou = 4730)
  an_aou_population_summary <- pop_summarize(an_aou_population)


  expect_true(all(dim(an_aou_population_summary) == c(1, 14)))
  expect_true(an_aou_population_summary$abundance[1] == 10)
  expect_true(an_aou_population_summary$aou[1] == 4730)
  expect_false(anyNA(an_aou_population_summary))

})

test_that("community_summary error catching works", {


  a_demo_route <- demo_route_raw %>%
    filter_bbs_survey() %>%
    dplyr::filter(year %in% c(1994, 2022))

  set.seed(22)

  # No body size columns
  expect_error(community_summarize(a_demo_route), regexp = "`community` is missing columns for body size and/or metabolic rate")

  # No id_var columns
  a_demo_community <- community_generate(a_demo_route)

  no_id_cols <-a_demo_community %>%
    dplyr::select(-c("record_id", "routedataid", "countrynum", "statenum", "route", "rpid", "year"))

  expect_error(community_summarize(no_id_cols), regexp = "No `id_vars` present in `community")

  # Incorrect custom columns
  expect_error(community_summarize(a_demo_community, level = "custom", id_vars = "nonexistent"), regexp = "No `id_vars` present in `community")

  # Custom columns not provided
  expect_error(community_summarize(a_demo_community, level = "custom"), regexp = "Set custom `id_vars` using `id_vars` argument")

  # No unique species ids
  no_spid_cols <-a_demo_community %>%
    dplyr::select(-c("aou", "sim_species_id", "scientific_name", "mean_size", "sd_size", "abundance"))

  expect_message(community_summarize(no_spid_cols), regexp = "No identifiable species designator to calculate species richness!")

  na_spid_cols <-a_demo_community %>%
    dplyr::mutate(aou = NA, sim_species_id = NA, scientific_name = NA)

  na_spid_cols_summary <- community_summarize(na_spid_cols, level = "year")

  expect_true(nrow(na_spid_cols_summary) == 2)


  na_spid_cols_summary <- community_summarize(na_spid_cols, level = "species")

  expect_true(nrow(na_spid_cols_summary) == 26)

})

test_that("community_summary works", {

  a_demo_route <- demo_route_raw %>%
    filter_bbs_survey()

  set.seed(22)

  a_demo_community <- community_generate(a_demo_route)

  demo_annual_summary <- community_summarize(a_demo_community)

  expect_true(nrow(demo_annual_summary) == length(unique(a_demo_community$year)))

  demo_species_annual_summary <- community_summarize(a_demo_community, level = "species_and_year")

  expect_true(nrow(demo_species_annual_summary) == sum(demo_annual_summary$total_richness))
  expect_true(all(sort(unique(demo_species_annual_summary$aou)) == sort(unique(a_demo_community$aou))))

  demo_species_summary <- community_summarize(a_demo_community, level = "species")

  expect_true(nrow(demo_species_summary) == length(unique(a_demo_community$aou)))
  expect_true(all(demo_species_summary$total_richness == 1))

  a_demo_community$genus <- apply(as.matrix(a_demo_community$scientific_name), 1,
                                  FUN = function(x) return(unlist(strsplit(x, " "))[[1]]))

  demo_genus_summary <- community_summarize(a_demo_community, level = "custom", id_vars = c("year", "genus"))

  expect_true(nrow(demo_genus_summary) == 29 * length(unique(a_demo_community$genus)))
  expect_false(all(demo_genus_summary$total_richness == 1))


})

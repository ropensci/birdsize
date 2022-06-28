## code to prepare `new_hartford_clean` dataset goes here

new_hartford_raw <- new_hartford_raw

new_hartford_clean <- new_hartford_raw %>%
  filter_bbs_survey() %>%
  dplyr::filter(year == 1994)

usethis::use_data(new_hartford_clean, overwrite = TRUE)

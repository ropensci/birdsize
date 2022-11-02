## code to prepare `demo_route_clean` dataset goes here

demo_route_raw <- demo_route_raw

demo_route_clean <- demo_route_raw %>%
  filter_bbs_survey() %>%
  dplyr::filter(year == 1994)

usethis::use_data(demo_route_clean, overwrite = TRUE)

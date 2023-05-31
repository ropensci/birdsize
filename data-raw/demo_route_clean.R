## code to prepare `demo_route_clean` dataset goes here

demo_route_raw <- demo_route_raw

demo_route_clean <- demo_route_raw
demo_route_clean <-  filter_bbs_survey(demo_route_clean)
demo_route_clean <- demo_route_clean[ which(demo_route_clean$year == 1994), ]

usethis::use_data(demo_route_clean, overwrite = TRUE)

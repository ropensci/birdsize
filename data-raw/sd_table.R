## code to prepare `sd_table` dataset goes here

# To generate the `sd_table`, begin with the `raw_masses` data table (included in `bbssize`).

raw_size_data <- raw_masses

# Then run `generate_sd_table`. See `?generate_sd_table` and/or `View(generate_sd_table)` for documentation and source code.

sd_table1 <- birdsize:::generate_sd_table(raw_size_data)

usethis::use_data(sd_table, overwrite = TRUE)

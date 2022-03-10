## code to prepare `sd_table` dataset goes here

raw_size_dat = raw_masses
clean_size_dat = (clean_sp_size_data(raw_size_dat))


fitted_pars = (get_sd_parameters(raw_size_dat))


sd_size_dat = (add_estimated_sds(clean_size_data = clean_size_dat,
                                 sd_pars = fitted_pars))

sp_mean_size_dat = (get_sp_mean_size(sd_size_dat))

sd_table = sp_mean_size_dat

usethis::use_data(sd_table, overwrite = TRUE)

library(dplyr)

raw_masses_orig <- read.csv(here::here("update_species", "raw_masses_orig.csv"))
bbs_species_table <- read.csv(here::here("update_species", "bbs_species_table.csv"))

# Filter bbs species table

is_unidentified <- function(names) {
  names[names == "auratus auratus x auratus cafer"] = "auratus auratus"
  grepl("sp\\.| x |\\/", names)
}

bbs_species_table <- bbs_species_table %>%
  dplyr::filter(!is_unidentified(.data$species)) %>%
  dplyr::filter(.data$aou > 2880) %>%
  dplyr::filter(.data$aou < 3650 | .data$aou > 3810) %>%
  dplyr::filter(.data$aou < 3900 | .data$aou > 3910) %>%
  dplyr::filter(.data$aou < 4160 | .data$aou > 4210) %>%
  dplyr::filter(.data$aou != 7010)

# Find records in the bbs_species_table with AOUs not already in raw_masses_orig:

bbs_species_no_raw <- bbs_species_table %>%
  left_join(mutate(select(raw_masses_orig, aou), in_raw = T)) %>%
  filter(is.na(in_raw)) %>%
  select(-in_raw)


# Append those rows to raw_masses

bbs_species_append <- bbs_species_no_raw %>%
  select(-french_common_name, -spanish_common_name) %>%
  bind_rows(raw_masses_orig)

write.csv(bbs_species_append, here::here("update_species", "masses_to_update.csv"), row.names = F)

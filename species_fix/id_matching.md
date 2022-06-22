ID matching
================
Renata Diaz
2022-06-22

Iterate over tables in MATSS to get species_tables

``` r
#
# matssdatafiles <- list.files("../../Datasets/breed-bird-survey-prepped/", full.names = T, pattern = ".RDS")
#
# sptables <- list()
#
# for(i in 1:length(matssdatafiles)) {
#
#   this_matss <- readRDS(matssdatafiles[i])
#   sptables[[i]] <- this_matss$metadata$species_table
# }
#
# all_sptables <- bind_rows(sptables) %>%
#   distinct()
#
# colnames(all_sptables)

# saveRDS(all_sptables, file = here::here("species_fix", "all_MATSS_species.rds"))
```

``` r
all_MATSS_species <- readRDS(file =here::here("species_fix", "all_MATSS_species.RDS"))

raw_masses <- raw_masses

colnames(all_MATSS_species)
```

    ## [1] "species_id"          "id"                  "english_common_name"
    ## [4] "french_common_name"  "spanish_common_name" "sporder"            
    ## [7] "family"              "genus"               "species"

``` r
colnames(raw_masses)
```

    ##  [1] "species_id"          "english_common_name" "sporder"            
    ##  [4] "family"              "genus"               "species"            
    ##  [7] "mass"                "sd"                  "sex"                
    ## [10] "subspecies"          "location"            "name_mismatch"      
    ## [13] "name_notes"          "not_in_dunning"      "close_genus"        
    ## [16] "close_species"       "close_subspecies"    "close_species_notes"

``` r
sum(raw_masses$species_id %in% all_MATSS_species$species_id) # raw_masses$species_id == MATSS$species_id
```

    ## [1] 897

``` r
bbs_db <- dbConnect(RSQLite::SQLite(), '../../retriever_data/bbs.sqlite')
species <- dplyr::tbl(bbs_db, "breed_bird_survey_species")

colnames(species)
```

    ## [1] "species_id"          "aou"                 "english_common_name"
    ## [4] "french_common_name"  "spanish_common_name" "sporder"            
    ## [7] "family"              "genus"               "species"

``` r
retriever_ids <- as.data.frame(species)
```

# Compare retriever to MATSS

``` r
colnames(retriever_ids)
```

    ## [1] "species_id"          "aou"                 "english_common_name"
    ## [4] "french_common_name"  "spanish_common_name" "sporder"            
    ## [7] "family"              "genus"               "species"

``` r
colnames(all_MATSS_species)
```

    ## [1] "species_id"          "id"                  "english_common_name"
    ## [4] "french_common_name"  "spanish_common_name" "sporder"            
    ## [7] "family"              "genus"               "species"

``` r
length(unique(all_MATSS_species$species_id))
```

    ## [1] 421

``` r
sum(unique(all_MATSS_species$species_id) %in% retriever_ids$species_id) # species_id values overlap but don't all match
```

    ## [1] 327

``` r
species_id_matches <- left_join(all_MATSS_species, retriever_ids, by = c("species_id")) %>%
  mutate(genus_match = genus.x == genus.y,
         sp_match = species.x == species.y,
         common_name_match = english_common_name.x == english_common_name.y)

species_id_matches %>%
  select(genus_match, sp_match, common_name_match) %>%
  mutate(n = 1) %>%
  colSums(na.rm =T)
```

    ##       genus_match          sp_match common_name_match                 n 
    ##               235               168               168               421

Species IDs overlap but don’t key to the same species :scream:

MATSS `id` might be `paste0("sp", aou)`

``` r
head(all_MATSS_species)
```

    ##   species_id     id                         english_common_name
    ## 1        109 sp2980                               Spruce Grouse
    ## 2        110 sp3010                            Willow Ptarmigan
    ## 3        629 sp3310                            Northern Harrier
    ## 4        743 sp4010              American Three-toed Woodpecker
    ## 5        744 sp4000                     Black-backed Woodpecker
    ## 6        757 sp4123 (unid. Red/Yellow Shafted) Northern Flicker
    ##                      french_common_name    spanish_common_name         sporder
    ## 1                      Tétras du Canada Falcipennis canadensis     Galliformes
    ## 2                   Lagopède des saules        Lagopus lagopus     Galliformes
    ## 3                     Busard des marais       Circus hudsonius Accipitriformes
    ## 4                        Pic à dos rayé      Picoides dorsalis      Piciformes
    ## 5                        Pic à dos noir      Picoides arcticus      Piciformes
    ## 6 Pic flamboyant (groupe non identifié)       Colaptes auratus      Piciformes
    ##         family       genus    species
    ## 1  Phasianidae Falcipennis canadensis
    ## 2  Phasianidae     Lagopus    lagopus
    ## 3 Accipitridae      Circus  hudsonius
    ## 4      Picidae    Picoides   dorsalis
    ## 5      Picidae    Picoides   arcticus
    ## 6      Picidae    Colaptes    auratus

``` r
head(retriever_ids)
```

    ##   species_id  aou          english_common_name           french_common_name
    ## 1          6 1770 Black-bellied Whistling-Duck    Dendrocygne à ventre noir
    ## 2          7 1780       Fulvous Whistling-Duck            Dendrocygne fauve
    ## 3          8 1760                Emperor Goose                 Oie empereur
    ## 4          9 1690                   Snow Goose               Oie des neiges
    ## 5         10 1691      (Blue Goose) Snow Goose Oie des neiges (forme bleue)
    ## 6         11 1700                 Ross's Goose                  Oie de Ross
    ##              spanish_common_name      sporder   family       genus
    ## 1         Dendrocygna autumnalis Anseriformes Anatidae Dendrocygna
    ## 2            Dendrocygna bicolor Anseriformes Anatidae Dendrocygna
    ## 3                Anser canagicus Anseriformes Anatidae       Anser
    ## 4             Anser caerulescens Anseriformes Anatidae       Anser
    ## 5 Anser caerulescens (blue form) Anseriformes Anatidae       Anser
    ## 6                   Anser rossii Anseriformes Anatidae       Anser
    ##                    species
    ## 1               autumnalis
    ## 2                  bicolor
    ## 3                canagicus
    ## 4             caerulescens
    ## 5 caerulescens (blue form)
    ## 6                   rossii

``` r
all_MATSS_species <- all_MATSS_species %>%
  mutate(aou = as.numeric(sub("sp", "", id)))


length(unique(all_MATSS_species$aou))
```

    ## [1] 421

``` r
sum(unique(all_MATSS_species$aou) %in% retriever_ids$aou) # this looks promising
```

    ## [1] 421

``` r
aou_matches <- left_join(all_MATSS_species, retriever_ids, by = c("aou")) %>%
  mutate(genus_match = genus.x == genus.y,
         sp_match = species.x == species.y,
         common_name_match = english_common_name.x == english_common_name.y) %>%
  group_by_all() %>%
  mutate(all_match = sum(genus_match, sp_match, common_name_match, na.rm = T))

aou_not_match <- filter(aou_matches, all_match < 3)

aou_not_match
```

    ## # A tibble: 8 × 22
    ## # Groups:   species_id.x, id, english_common_name.x, french_common_name.x,
    ## #   spanish_common_name.x, sporder.x, family.x, genus.x, species.x, aou,
    ## #   species_id.y, english_common_name.y, french_common_name.y,
    ## #   spanish_common_name.y, sporder.y, family.y, genus.y, species.y,
    ## #   genus_match, sp_match, common_name_match [8]
    ##   species_id.x id     english_common_name.x    french_common_n… spanish_common_…
    ##          <int> <chr>  <chr>                    <chr>            <chr>           
    ## 1         1396 sp6470 Tennessee Warbler        Paruline obscure Oreothlypis per…
    ## 2         1397 sp6460 Orange-crowned Warbler   Paruline verdât… Oreothlypis cel…
    ## 3         1400 sp6450 Nashville Warbler        Paruline à joue… Oreothlypis ruf…
    ## 4         1401 sp6440 Virginia's Warbler       Paruline de Vir… Oreothlypis vir…
    ## 5          144 sp3200 Common Ground-Dove       Colombe à queue… Columbina passe…
    ## 6         1399 sp6430 Lucy's Warbler           Paruline de Lucy Oreothlypis luc…
    ## 7          146 sp3201 Ruddy Ground-Dove        Colombe rousse   Columbina talpa…
    ## 8          224 sp4270 Blue-throated Hummingbi… Colibri à gorge… Lampornis cleme…
    ## # … with 17 more variables: sporder.x <chr>, family.x <chr>, genus.x <chr>,
    ## #   species.x <chr>, aou <dbl>, species_id.y <int>,
    ## #   english_common_name.y <chr>, french_common_name.y <chr>,
    ## #   spanish_common_name.y <chr>, sporder.y <chr>, family.y <chr>,
    ## #   genus.y <chr>, species.y <chr>, genus_match <lgl>, sp_match <lgl>,
    ## #   common_name_match <lgl>, all_match <int>

The not-matches are: - 3 common name mismatches

``` r
# So I can fix raw_masses to have an AOU column by joining it with MATSS species IDs.

raw_masses_aou <- left_join(raw_masses, all_MATSS_species)
```

    ## Joining, by = c("species_id", "english_common_name", "sporder", "family",
    ## "genus", "species")

``` r
sum(is.na(raw_masses_aou$aou))
```

    ## [1] 8

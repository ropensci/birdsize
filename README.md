# birdsize


<!-- badges: start -->
[![Codecov test coverage](https://codecov.io/gh/diazrenata/birdsize/branch/main/graph/badge.svg)](https://codecov.io/gh/diazrenata/birdsize?branch=main)


[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->


R package to generate estimated body size distributions for populations or communities of birds, given either species ID or species' mean body size. Designed to work naturally with the North American Breeding Bird Survey, or with any dataset of bird species, abundance, and/or mean size data.

The core functions in `birdsize` apply at 3 levels of organization: species, population, and community.

The `species_*` functions take information about a real or hypothetical species and generates the parameters necessary to simulate body size distributions for that species.

The `population_*` functions use species-level parameters and abundances (population sizes) to simulate individual body size and basal metabolic rate measurements to make up populations of that species, and calculate population-wide summary statistics. 

The `community_*` functions generate population-level estimates for numerous populations (e.g. populations of different species, or populations of the same species at different points in time or different sampling locations), and calculate summary statistics with flexible grouping structures.


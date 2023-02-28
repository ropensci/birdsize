# birdsize


<!-- badges: start -->
[![Codecov test coverage](https://codecov.io/gh/diazrenata/birdsize/branch/main/graph/badge.svg)](https://codecov.io/gh/diazrenata/birdsize?branch=main)


[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

[![pkgcheck](https://github.com/diazrenata/birdsize/workflows/pkgcheck/badge.svg)](https://github.com/diazrenata/birdsize/actions?query=workflow%3Apkgcheck)

[![Status at rOpenSci Software Peer Review](https://badges.ropensci.org/577_status.svg)](https://github.com/ropensci/software-review/issues/577)
<!-- badges: end -->

## Package summary

`birdsize` simulates size measurements for populations or communities of birds. Because avian populuation monitoring often relies on auditory or visual methods, and therefore does not provide information about individual body *size*, it is challenging to conduct large-scale analyses of trends in biomass, energy use, community body size structure, or other, similar patterns for these species. `birdsize` solves this problem by using species' traits to generate size estimates for birds based on species ID or user-specified parameters. It is designed to interface naturally with data downloaded from the [North American Breeding Bird Survey](https://www.pwrc.usgs.gov/bbs/), or to work with other datasets (including synthetic data) as long as they include *population sizes* and either *species identity* (for species found in the Breeding Bird Survey) or *species mean, and optionally standard deviation, body size* (for other species, including hypothetical or simulated species).  

The core functions in `birdsize` apply at 3 levels of organization: species, population, and community. The `community_*` functions generate population-level estimates for numerous populations (e.g. populations of different species, or populations of the same species at different points in time or different sampling locations), and calculate summary statistics with flexible grouping structures. The `population_*` functions use species-level parameters and abundances (population sizes) to simulate individual body size and basal metabolic rate measurements to make up populations of that species, and calculate population-wide summary statistics. The `species_*` functions take information about a real or hypothetical species and generates the parameters necessary to simulate body size distributions for that species.

For most users, the [community](https://diazrenata.github.io/birdsize/articles/community.html) vignette will provide a high-level overview of using `birdsize` to simulate and summarize community properties. The [bbs-data](https://diazrenata.github.io/birdsize/articles/bbs-data.html) vignette illustrates how to access and work with data from the Breeding Bird Survey. The [populations](https://diazrenata.github.io/birdsize/articles/populations.html) and [species](https://diazrenata.github.io/birdsize/articles/species.html) vignettes provide more detail on using these functions and may be especially useful for working with birds not in the included set of species. Finally, the size estimates in `birdsize` use a scaling relationship between the mean and standard deviation of body size for some species, which is further illustrated in the [scaling](https://diazrenata.github.io/birdsize/articles/scaling.html) vignette.


## Installation

To install the in-development version, use `remotes` or `devtools`:

```
remotes::install_github('diazrenata/birdsize')
```

or 

```
devtools::install_github('diazrenata/birdsize')
```

## Basic use cases

For an illustration of the core workflow in `birdsize`, see the  [community](https://diazrenata.github.io/birdsize/articles/community.html) vignette.


## Citation

Diaz, Renata M. (2023). birdsize: Estimate Avian Body Size
  Distributions. GitHub. https://github.com/diazrenata/birdsize 

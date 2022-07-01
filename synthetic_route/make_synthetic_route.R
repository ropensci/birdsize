library(birdsize)
library(dplyr)

set.seed(22)

toy_route_species <- sample(species$aou, size = 40)

toy_route_abunds <- list()

for(i in 1:length(toy_route_species)) {

  this_abund = rpois(29, lambda = sample(100, 1))
  this_abund_df <- data.frame(
    year = c(1994:2022),
    aou = toy_route_species[i],
    speciestotal = this_abund)


  stops_dfs <- list()
  for(j in 1:29) {
    these_stops <- rmultinom(1, size = this_abund[j], prob = c(.2, .2, .2, .2, .2))

    stops_dfs[[j]] <- data.frame(
      count10 = these_stops[1],
      count20 = these_stops[2],
      count30 = these_stops[3],
      count40 = these_stops[4],
      count50 = these_stops[5],
      speciestotal = this_abund[j],
      stoptotal = sum(these_stops > 0),
      year = this_abund_df$year[j]
    )

  }

  stops_dfs <- bind_rows(stops_dfs)

  toy_route_abunds[[i]] <- left_join(this_abund_df,
                                     stops_dfs)


}


toy_route_abunds <- bind_rows(toy_route_abunds)

toy_route <- toy_route_abunds %>%
  mutate(
    record_id = 900000:(900000 + nrow(toy_route_abunds) - 1),
    countrynum = 900,
    statenum = 99,
    route = 1,
    rpid = 101
  ) %>%
  mutate(routedataid = paste(countrynum, statenum, route, rpid, year, sep = ""))

toy_route <- toy_route[ colnames(new_hartford_raw)]


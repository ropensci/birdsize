# This is a test that directly downloads the States.zip file from ScienceBase and filters it to extract a route to ensure that the community* functions work on data as they come raw from the BBS data releases.
# Skip it on CI so as to not overwhelm ScienceBase with queries.

test_that("direct download works", {

  skip_on_ci()
  skip_on_os("mac")

  temp <- tempfile()
  temp2 <- tempfile()
  temp3 <- tempfile()

  download.file("https://www.sciencebase.gov/catalog/file/get/5ea04e9a82cefae35a129d65?f=__disk__38%2F0e%2F1d%2F380e1dd98a48aa48b9cf2efa25f74e07ebc797f8", temp)
  unzip(zipfile = temp, exdir = temp2)
  unzip(zipfile = file.path(temp2, "States/Connect.zip"), exdir= temp3)
  data <- read.csv(file.path(temp3, "Connect.csv"), stringsAsFactors = F)

  unlink(c(temp, temp2, temp3))

  new_hartford_route <- data %>%
    dplyr::filter(Route == 102)

  expect_true(any(new_hartford_route$AOU %in% nontarget_species$AOU))
  expect_false(any(new_hartford_route$AOU %in% unidentified_species$AOU))

  new_hartford_route_clean <- new_hartford_route %>%
    filter_bbs_survey()
  short_bbs_data <- new_hartford_route_clean %>%
    dplyr::filter(year == 2019)

  set.seed(22)
  bbs_data_sims <- community_generate(short_bbs_data)

  # expect_true(ncol(bbs_data_sims) == 23)
  expect_true(nrow(bbs_data_sims) == sum(short_bbs_data$speciestotal))
  expect_false(anyNA(bbs_data_sims))
  expect_true(all(round(bbs_data_sims$individual_mass[1:5]) == c(5824, 7147, 121, 120, 119)))
})

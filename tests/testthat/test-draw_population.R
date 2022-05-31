test_that("draw_population works given toy inputs", {

  spmean <- 100
  spsd <- 6
  spabund <- 100

  set.seed(22)
  spind <- draw_population(spmean, spsd, spabund)

  rounded_spind <- round(spind)

  expect_true(all(rounded_spind[1:5] == c(97, 115, 106, 102, 99)))

})


test_that("draw_population works given near zero inputs", {

  spmean <- 2
  spsd <- 2
  spabund <- 100

  set.seed(22)

  spind <- draw_population(spmean, spsd, spabund)

  rounded_spind <- round(spind)

  expect_false(min(spind) < 0)

  expect_true(all(rounded_spind[1:5] == c(1, 7, 4, 3, 2)))


})

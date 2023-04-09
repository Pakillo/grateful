test_that("get_pkgs_info works", {
  info <- get_pkgs_info(pkgs = c("renv", "remotes", "dplyr", "ggplot2"))
  expect_identical(info$pkg, c("remotes", "renv", "tidyverse"))
  expect_identical(info$citekeys, list("remotes", "renv", "tidyverse"))
})

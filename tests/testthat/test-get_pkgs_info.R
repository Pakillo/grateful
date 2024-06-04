test_that("get_pkgs_info works", {
  info <- get_pkgs_info(pkgs = c("renv", "remotes", "dplyr", "ggplot2", "knitr"),
                        out.dir = tempdir())
  expect_identical(info$pkg, c("knitr", "remotes", "renv", "tidyverse"))
  expect_identical(info$citekeys,
                   list(knitr = c("knitr2024", "knitr2015", "knitr2014"),
                        remotes = "remotes",
                        renv = "renv",
                        tidyverse = "tidyverse"))
})

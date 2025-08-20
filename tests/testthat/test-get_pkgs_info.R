test_that("get_pkgs_info works", {

  info <- get_pkgs_info(pkgs = c("renv", "grateful", "utils"),
                        out.dir = tempdir())
  expect_identical(info$pkg, c("grateful", "renv", "utils"))
  expect_identical(info$version,
                   as.character(
                     c(utils::packageVersion("grateful"),
                       utils::packageVersion("renv"),
                       utils::packageVersion("utils"))
                   ))
  expect_identical(info$citekeys[1], list(grateful = "grateful"))


  # using tidyverse
  info <- get_pkgs_info(pkgs = c("renv", "dplyr", "grateful", "ggplot2", "utils"),
                        out.dir = tempdir())
  expect_identical(info$pkg, c("grateful", "renv", "tidyverse", "utils"))

})


test_that("get_pkgs_info produces warning if skip.missing = TRUE", {

  expect_warning(get_pkgs_info(pkgs = c("renv", "grateful", "utils"),
                               out.dir = tempdir(),
                               skip.missing = TRUE))


})

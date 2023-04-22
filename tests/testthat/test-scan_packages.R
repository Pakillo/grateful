test_that("scan_packages return correct output", {

  out <- scan_packages(pkgs = c("grateful", "renv", "utils", "dplyr", "tidyverse"))

  ref <- data.frame(pkg = c("grateful", "renv", "tidyverse", "utils"),
                    version = as.character(
                      c(utils::packageVersion("grateful"),
                        utils::packageVersion("renv"),
                        "2.0.0",
                        utils::packageVersion("utils"))),
                    row.names = NULL)

  expect_equal(out, ref)

})


#chatGPT

pkgs <- c("knitr", "remotes", "renv", "grateful")

# run the function
pkgs.df <- scan_packages(pkgs = pkgs)


test_that("returns a data frame with two columns", {

  # check the result
  expect_true(is.data.frame(pkgs.df))
  expect_true("pkg" %in% names(pkgs.df))
  expect_true("version" %in% names(pkgs.df))

})


test_that("returns a data frame with package names and versions", {

  # check the result
  expect_true(all(pkgs %in% pkgs.df$pkg))
  expect_true(length(pkgs.df$version) == length(pkgs))

})


test_that("returns all package dependencies when dependencies = TRUE", {

  # this test is slow...
  skip_on_cran()
  skip_on_ci()

  # run the function
  pkgs.df <- scan_packages(pkgs = "knitr", dependencies = TRUE)

  # check the result
  expect_identical(pkgs.df$pkg, c("evaluate", "highr", "knitr", "xfun", "yaml"))

})


test_that("returns session package names when argument pkgs is 'Session'", {

  # run the function
  pkgs.df <- scan_packages(pkgs = "Session", omit = NULL)

  # check the result
  expect_true(all(names(utils::sessionInfo()$otherPkgs) %in% pkgs.df$pkg))

})

test_that("removes tidyverse packages when cite.tidyverse = TRUE", {

  pkgs <- c("tidyverse", "ggplot2", "dplyr", "dplyr")

  # run the function
  pkgs.df <- scan_packages(pkgs = pkgs)

  # check the result
  expect_true(pkgs.df$pkg == "tidyverse")

  # tidyverse not included
  pkgs <- c("ggplot2", "dplyr", "dplyr")

  # run the function
  pkgs.df <- scan_packages(pkgs = pkgs)

  # check the result
  expect_true(pkgs.df$pkg == "tidyverse")

})

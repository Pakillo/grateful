
test_that("scan_packages returns error if wrong arguments provided", {

  expect_error(scan_packages(pkgs = NULL))
  expect_error(scan_packages(pkgs = TRUE))
  expect_error(scan_packages(pkgs = "renv", omit = FALSE))
  expect_error(scan_packages(pkgs = "renv", cite.tidyverse = NULL))
  expect_error(scan_packages(pkgs = "renv", dependencies = NULL))

})

test_that("scan_packages return correct output", {

  out <- scan_packages(pkgs = c("renv", "utils", "grateful"))

  ref <- data.frame(pkg = c("grateful", "renv", "utils"),
                    version = as.character(
                      c(utils::packageVersion("grateful"),
                        utils::packageVersion("renv"),
                        utils::packageVersion("utils"))),
                    row.names = NULL)

  expect_equal(out, ref)

})


#chatGPT

pkgs <- c("utils", "renv", "grateful")

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

  # this test may be slow...
  # also note dependencies might change, breaking the test
  skip_on_cran()
  skip_on_ci()

  # run the function
  pkgs.df <- scan_packages(pkgs = "grateful", dependencies = TRUE)

  # check the result
  expect_identical(pkgs.df$pkg,
                   c("R6", "base64enc", "bslib", "cachem", "digest", "evaluate",
                     "fastmap", "fontawesome", "fs", "glue", "grateful",
                     "highr", "htmltools", "jquerylib", "knitr", "lifecycle",
                     "memoise", "mime", "rappdirs", "remotes", "renv",
                     "rmarkdown", "sass", "tidyverse", "tinytex", "xfun", "yaml")
                   )

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

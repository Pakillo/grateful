
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
pkgs.df <- scan_packages(pkgs = pkgs)


test_that("returns a data frame with two columns", {

  expect_true(is.data.frame(pkgs.df))
  expect_true("pkg" %in% names(pkgs.df))
  expect_true("version" %in% names(pkgs.df))

})


test_that("returns a data frame with package names and versions", {

  expect_true(all(pkgs %in% pkgs.df$pkg))
  expect_true(length(pkgs.df$version) == length(pkgs))

})


test_that("returns all package dependencies when dependencies = TRUE", {

  # this test may be slow...
  # also note dependencies might change, breaking the test
  skip_on_cran()
  skip_if_offline()

  pkgs.df <- scan_packages(pkgs = "grateful", dependencies = TRUE)

  expect_identical(pkgs.df$pkg,
                   c("R6", "base64enc", "bslib", "cachem", "digest", "evaluate",
                     "fastmap", "fontawesome", "fs", "glue", "grateful",
                     "highr", "htmltools", "jquerylib", "knitr", "lifecycle",
                     "memoise", "mime", "rappdirs", "remotes", "renv",
                     "rmarkdown", "sass", "tidyverse", "tinytex", "xfun", "yaml")
                   )

})


test_that("returns session package names when argument pkgs is 'Session'", {

  pkgs.df <- scan_packages(pkgs = "Session", omit = NULL)
  expect_true(all(names(utils::sessionInfo()$otherPkgs) %in% pkgs.df$pkg))

})


# test_that("returns session package names when argument pkgs is 'All'", {
#
#   skip_on_cran()
#
#   pkgs.df <- scan_packages(pkgs = "All", omit = NULL)
#   expect_equal(pkgs.df$pkg,
#                c("badger", "base", "desc", "grateful", "knitr", "mgcv", "pkgdown",
#                  "remotes", "renv", "rmarkdown", "testthat", "tidyverse", "visreg"))
#
# })


test_that("packages are omitted", {

  pkgs.df <- scan_packages(pkgs = "Session", omit = "grateful")
  expect_equal(pkgs.df$pkg, c("base", "testthat"))

})


test_that("removes tidyverse packages when cite.tidyverse = TRUE", {

  pkgs <- c("tidyverse", "ggplot2", "dplyr", "dplyr")
  pkgs.df <- scan_packages(pkgs = pkgs)
  expect_true(pkgs.df$pkg == "tidyverse")

  # tidyverse not included
  pkgs <- c("ggplot2", "dplyr", "dplyr")
  pkgs.df <- scan_packages(pkgs = pkgs)
  expect_true(pkgs.df$pkg == "tidyverse")

})




test_that("packages are omitted", {

  pkgs.df <- scan_packages(pkgs = "Session", omit = "grateful")
  expect_equal(pkgs.df$pkg, c("base", "testthat"))

})


test_that("Package dependencies from DESCRIPTION are returned correctly", {

  # constructive::construct(pkgs.df)

  skip_on_cran()
  skip_if_offline()

  desc <- tempfile()
  download.file("https://raw.githubusercontent.com/Pakillo/grateful/refs/heads/master/DESCRIPTION",
                destfile = desc, quiet = TRUE, mode = "wb")

  pkgs.df <- scan_packages(pkgs = c("Depends"), desc.path = desc)
  expect_equal(pkgs.df, data.frame(pkg = "base", version = ">= 3.0.0"))

  pkgs.df <- scan_packages(pkgs = c("Imports"), desc.path = desc)
  expect_equal(pkgs.df,
               data.frame(
                 pkg = c("desc", "knitr", "remotes", "renv", "rmarkdown",
                         "rstudioapi", "utils"),
                 version = NA_character_
               ))

  pkgs.df <- scan_packages(pkgs = c("Suggests"), desc.path = desc)
  expect_equal(pkgs.df,
               data.frame(pkg = c("curl", "testthat"), version = c(NA, ">= 3.0.0")))

  pkgs.df <- scan_packages(pkgs = c("LinkingTo"), desc.path = desc)
  expect_equal(pkgs.df, data.frame(pkg = character(0), version = character(0)))

  pkgs.df <- scan_packages(pkgs = c("Imports", "Suggests"), desc.path = desc)
  expect_equal(pkgs.df,
               data.frame(
                 pkg = c("curl", "desc", "knitr", "remotes", "renv", "rmarkdown",
                         "rstudioapi", "testthat", "utils"),
                 version = rep(c(NA, ">= 3.0.0", NA), c(7L, 1L, 1L))
               ))

  pkgs.df <- scan_packages(pkgs = c("Depends", "Imports", "Suggests", "LinkingTo"),
                           desc.path = desc)
  expect_equal(pkgs.df,
               data.frame(
                 pkg = c("base", "curl", "desc", "knitr", "remotes", "renv",
                         "rmarkdown", "rstudioapi", "testthat", "utils"),
                 version = rep(rep(c(">= 3.0.0", NA), 2), c(1L, 7L, 1L, 1L))
               ))

})



test_that("scan_packages produces warning if skip.missing = TRUE", {

  expect_warning(scan_packages(pkgs = c("renv", "grateful", "utils"),
                               out.dir = tempdir(),
                               skip.missing = TRUE))


})


test_that("scan_packages produces correct output if skip.missing = TRUE", {

  out <- suppressWarnings(scan_packages(pkgs = c("renv", "grateful", "fakepkg", "utils"),
                               out.dir = tempdir(),
                               skip.missing = TRUE))

  ref <- data.frame(pkg = c("grateful", "renv", "utils"),
                    version = as.character(
                      c(utils::packageVersion("grateful"),
                        utils::packageVersion("renv"),
                        utils::packageVersion("utils"))),
                    row.names = NULL)

  expect_equal(data.frame(out, row.names = NULL), ref)


})

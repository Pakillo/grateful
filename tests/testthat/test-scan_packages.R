test_that("scan_packages return correct output", {

  out <- scan_packages(pkgs = c("grateful", "renv", "utils", "dplyr", "tidyverse"))

  ref <- data.frame(pkg = c("grateful", "renv", "tidyverse", "utils"),
                    version = as.character(
                      c(utils::packageVersion("grateful"),
                        utils::packageVersion("renv"),
                        "1.3.1",
                        utils::packageVersion("utils"))),
                    row.names = NULL)

  expect_equal(out, ref)

})

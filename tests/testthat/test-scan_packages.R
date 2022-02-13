test_that("scan_packages return correct output", {

  out <- scan_packages(pkgs = c("grateful", "renv", "utils"))

  ref <- data.frame(pkg = c("grateful", "renv", "utils"),
                    version = as.character(
                      c(utils::packageVersion("grateful"),
                        utils::packageVersion("renv"),
                        utils::packageVersion("utils"))),
                    row.names = NULL)

  expect_equal(out, ref)

})

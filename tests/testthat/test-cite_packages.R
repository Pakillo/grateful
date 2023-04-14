test_that("cite_packages returns correct citekeys", {

  expect_identical(cite_packages(output = "citekeys",
                                 pkgs = c("remotes", "renv"),
                                 out.dir = tempdir()),
                   c("remotes", "renv"))
})


test_that("cite_packages returns correct table", {

  tabla <- cite_packages(output = "table",
                         pkgs = c("remotes", "renv"),
                         out.dir = tempdir())
  expect_true(nrow(tabla) == 2)
  expect_identical(names(tabla), c("Package", "Version", "Citation"))
  expect_identical(tabla$Package, c("remotes", "renv"))
  expect_identical(tabla$Citation, list("@remotes", "@renv"))

})


test_that("cite_packages returns correct paragraph", {

  skip_on_cran()
  skip_on_ci()

  para <- cite_packages(output = "paragraph",
                        pkgs = c("remotes", "renv"),
                        out.dir = tempdir())
  expect_identical(para,
                   structure("We used the following R packages: remotes v. 2.4.2 [@remotes], renv v. 0.17.3 [@renv].",
                             class = "knit_asis",
                             knit_cacheable = NA))


  para <- cite_packages(output = "paragraph",
                        pkgs = "Session",
                        out.dir = tempdir())
  expect_identical(para,
                   structure("We used R version 4.2.3 [@base] and the following R packages: testthat v. 3.1.7 [@testthat].",
                             class = "knit_asis",
                             knit_cacheable = NA))

})




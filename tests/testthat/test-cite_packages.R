test_that("providing wrong arguments return error", {

  expect_error(cite_packages(out.dir = NULL))
  expect_error(cite_packages(out.dir = tempdir(), out.file = "test",
                             bib.file = "test"))

})

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

  para <- cite_packages(output = "paragraph",
                        pkgs = c("grateful"),
                        out.dir = tempdir())
  expect_identical(para,
                   structure(paste0("We used the following R packages: grateful v. ",
                                    utils::packageVersion("grateful"), " [@grateful]."),
                             class = "knit_asis",
                             knit_cacheable = NA))


  para <- cite_packages(output = "paragraph",
                        pkgs = "Session",
                        out.dir = tempdir())
  expect_identical(para,
                   structure(paste0("We used R version ",
                                    R.version$major, ".", R.version$minor,
                                    " [@base] and the following R packages: testthat v. ",
                                    utils::packageVersion("testthat"), " [@testthat]."),
                             class = "knit_asis",
                             knit_cacheable = NA))

  ### passive voice

  para <- cite_packages(output = "paragraph",
                        pkgs = c("grateful"),
                        out.dir = tempdir(),
                        passive.voice = TRUE)

  expect_identical(para,
                   structure(paste0("This work was completed with the following R packages: grateful v. ",
                                    utils::packageVersion("grateful"), " [@grateful]."),
                             class = "knit_asis",
                             knit_cacheable = NA))

  para <- cite_packages(output = "paragraph",
                        pkgs = "Session",
                        out.dir = tempdir(),
                        passive.voice = TRUE)

  expect_identical(para,
                   structure(paste0("This work was completed using R version ",
                                    R.version$major, ".", R.version$minor,
                                    " [@base] with the following R packages: testthat v. ",
                                    utils::packageVersion("testthat"), " [@testthat]."),
                             class = "knit_asis",
                             knit_cacheable = NA))

})


test_that("cite_packages returns correct Rmd", {

  skip_on_cran()
  skip_on_ci()

  cite <- cite_packages(
    output = "file",
    out.dir = tempdir(),
    out.format = "Rmd",
    pkgs = "grateful")

  rmd.file <- readLines(cite)
  #dput(rmd.file)

  expect_equal(cite, file.path(tempdir(), "grateful-report.Rmd"))

  expect_equal(rmd.file,
               c("---",
                 "title: \"`grateful` citation report\"",
                 "bibliography: grateful-refs.bib",
                 "#csl: null.csl",
                 "---",
                 "",
                 "## R packages used",
                 "",
                 "|Package  |Version |Citation  |",
                 "|:--------|:-------|:---------|",
                 paste0("|grateful |", utils::packageVersion("grateful"),"   |@grateful |"),
                 "",
                 "**You can paste this paragraph directly in your report:**",
                 "",
                 paste0("We used the following R packages: grateful v. ",
                        utils::packageVersion("grateful"), " [@grateful]."),
                 "",
                 "## Package citations",
                 ""))




})

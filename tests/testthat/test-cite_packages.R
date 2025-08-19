test_that("providing wrong arguments return error", {

  expect_error(cite_packages(out.dir = NULL))
  expect_error(cite_packages(out.dir = tempdir(), out.file = "test",
                             bib.file = "test"))

})

test_that("cite_packages returns correct citekeys", {

  expect_identical(cite_packages(output = "citekeys",
                                 pkgs = c("grateful"),
                                 out.dir = tempdir()),
                   c("grateful"))
})


test_that("cite_packages returns correct table", {

  tabla <- cite_packages(output = "table",
                         pkgs = c("grateful", "remotes", "renv", "knitr",
                                  "dplyr", "utils", "tidyverse"),
                         out.dir = tempdir())
  expect_true(nrow(tabla) == 6)
  expect_identical(names(tabla), c("Package", "Version", "Citation"))
  expect_identical(tabla$Package, c("grateful", "knitr", "remotes", "renv", "tidyverse", "utils"))
  expect_identical(tabla$Version[1:3],
                   as.character(
                     c(utils::packageVersion("grateful"),
                       utils::packageVersion("knitr"),
                       utils::packageVersion("remotes"))
                   ))
  expect_identical(tabla$Citation[1],
                   list(grateful = "@grateful"))

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
                   structure(paste0("We used R v. ",
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
                   structure(paste0("This work was completed using the following R packages: grateful v. ",
                                    utils::packageVersion("grateful"), " [@grateful]."),
                             class = "knit_asis",
                             knit_cacheable = NA))

  para <- cite_packages(output = "paragraph",
                        pkgs = "Session",
                        out.dir = tempdir(),
                        passive.voice = TRUE)

  expect_identical(para,
                   structure(paste0("This work was completed using R v. ",
                                    R.version$major, ".", R.version$minor,
                                    " [@base] and the following R packages: testthat v. ",
                                    utils::packageVersion("testthat"), " [@testthat]."),
                             class = "knit_asis",
                             knit_cacheable = NA))


  skip_on_ci()
  skip_if_offline()
  desc <- tempfile()
  download.file("https://raw.githubusercontent.com/Pakillo/grateful/refs/heads/master/DESCRIPTION",
                        destfile = desc, quiet = TRUE, mode = "wb")
  para <- cite_packages(output = "paragraph",
                        pkgs = c("Depends", "Imports", "Suggests"),
                        desc.path = desc,
                        out.dir = tempdir())
  expect_identical(para,
                   structure("We used R v. >= 3.0.0 [@base] and the following R packages: curl [@curl], desc [@desc], knitr [@knitr2014; @knitr2015; @knitr2025], remotes [@remotes], renv [@renv], rmarkdown [@rmarkdown2018; @rmarkdown2020; @rmarkdown2024], rstudioapi [@rstudioapi], testthat v. >= 3.0.0 [@testthat], utils [@utils].", class = "knit_asis", knit_cacheable = NA))


})


test_that("cite_packages returns correct paragraph with customised text", {

  skip_on_cran()

  para <- cite_packages(output = "paragraph",
                        pkgs = c("grateful"),
                        out.dir = tempdir(),
                        text.start = "En este trabajo utilizamos",
                        text.pkgs = "los siguientes paquetes")
  expect_identical(para,
                   structure(paste0("En este trabajo utilizamos los siguientes paquetes: grateful v. ",
                                    utils::packageVersion("grateful"), " [@grateful]."),
                             class = "knit_asis",
                             knit_cacheable = NA))


  para <- cite_packages(output = "paragraph",
                        pkgs = "Session",
                        out.dir = tempdir(),
                        text.start = "En este trabajo utilizamos",
                        text.pkgs = "y los siguientes paquetes")
  expect_identical(para,
                   structure(paste0("En este trabajo utilizamos R v. ",
                                    R.version$major, ".", R.version$minor,
                                    " [@base] y los siguientes paquetes: testthat v. ",
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


test_that("get_citations returns error if wrong arguments provided", {
  expect_error(get_citations(pkgs = NULL, out.dir = tempdir()))
  expect_error(get_citations(pkgs = "renv"))
  expect_error(get_citations(pkgs = "renv", out.dir = tempdir(), bib.file = NA))
  expect_error(get_citations(pkgs = NULL, out.dir = tempdir(), include.RStudio = NULL))

})


test_that("get_citations works", {
  citkeys <- get_citations(c("knitr", "tidyverse"), out.dir = tempdir())
  expect_identical(citkeys, c("knitr2023", "knitr2015", "knitr2014", "tidyverse"))
})

# test_that("get_citations adds Rstudio citation if asked", {
#   skip_on_ci()
#   skip_on_cran()
#   citkeys <- get_citations(c("renv"), include.RStudio = TRUE, out.dir = tempdir())
#   expect_identical(citkeys, c("renv", "rstudio"))
# })

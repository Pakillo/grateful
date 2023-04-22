
test_that("out.dir is provided", {
  expect_error(get_citations(pkgs = "renv"))

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

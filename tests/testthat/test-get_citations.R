test_that("get_citations works", {
  citkeys <- get_citations(c("knitr", "tidyverse"))
  expect_identical(citkeys, c("knitr2023", "knitr2015", "knitr2014", "tidyverse"))
})

# test_that("get_citations adds Rstudio citation if asked", {
#   citkeys <- get_citations(c("knitr", "tidyverse"), include.RStudio = TRUE)
#   expect_identical(citkeys, c("knitr2023", "knitr2015", "knitr2014", "tidyverse", "rstudio"))
# })

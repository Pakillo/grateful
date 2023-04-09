

# Define test cases for the `fix_title()` function
#chatGPT

test_that("Test fix_title() function", {

  # Test case 1: Test for a simple title string
  title1 <- 'title = {This is a simple title}'
  expected_title1 <- 'title = {This is a simple title}'
  expect_equal(fix_title(title1), expected_title1)

  # Test case 2: Test for a package name starting the title
  title2 <- 'title = {package_name: This is a title with a package name}'
  expected_title2 <- 'title = {{package_name}: This is a title with a package name}'
  expect_equal(fix_title(title2), expected_title2)

  # Test case 3: Test for "R" in the title
  title3 <- 'title = {This is a title with r in it}'
  expected_title3 <- 'title = {This is a title with {R} in it}'
  expect_equal(fix_title(title3), expected_title3)

  # Test case 4: Test for multiple capitalization in title
  title4 <- 'title = {this is a TeSt: string test with 2 CapiTalizaTions}'
  expected_title4 <- 'title = {this is a TeSt: string test with 2 CapiTalizaTions}'
  expect_equal(fix_title(title4), expected_title4)

  # # Test case 5: Test for double quotes in the title
  # title5 <- 'title = {"This is a title with double quotes in it"}'
  # expected_title5 <- 'title = {``{This is a title with double quotes in it}\'\''
  # expect_equal(fix_title(title5), expected_title5)
  #
  # # Test case 6: Test for special characters in the title
  # title6 <- 'title = {This is a title with special characters !@#$%^&*()_+} and "quotes"}'
  # expected_title6 <- 'title = {This is a title with special characters !@#$%^&*()_+} and ``{quotes}\'\'}'
  # expect_equal(fix_title(title6), expected_title6)

})


test_that("Test get_citation_and_citekey function", {

  skip_on_ci()
  skip_on_cran()

  # package version and year may change
  expect_identical(get_citation_and_citekey("grateful"),
                   structure(c("@Manual{grateful,",
                               title = "title = {{grateful}: Facilitate citation of R packages},",
                               author = "  author = {{Francisco Rodríguez-Sánchez} and {Connor P. Jackson} and {Shaurita D. Hutchins}},",
                               note = "  note = {R package version 0.1.12},",
                               year = "  year = {2023},",
                               url = "  url = {https://github.com/Pakillo/grateful},",
                               "}"),
                             class = "Bibtex"))


  expect_identical(get_citation_and_citekey("knitr"),
                   structure(c("@Manual{knitr2023,",
                               title = "title = {{knitr}: A General-Purpose Package for Dynamic Report Generation in R},",
                               author = "  author = {Yihui Xie},",
                               year = "  year = {2023},",
                               note = "  note = {R package version 1.42},",
                               url = "  url = {https://yihui.org/knitr/},",
                               "}",
                               "",
                               "@Book{knitr2015,",
                               title = "  title = {Dynamic Documents with {R} and knitr},",
                               author = "  author = {Yihui Xie},",
                               publisher = "  publisher = {Chapman and Hall/CRC},",
                               address = "  address = {Boca Raton, Florida},",
                               year = "  year = {2015},",
                               edition = "  edition = {2nd},",
                               note = "  note = {ISBN 978-1498716963},",
                               url = "  url = {https://yihui.org/knitr/},", "}",
                               "",
                               "@InCollection{knitr2014,",
                               booktitle = "  booktitle = {Implementing Reproducible Computational Research},",
                               editor = "  editor = {Victoria Stodden and Friedrich Leisch and Roger D. Peng},",
                               title = "title = {{knitr}: A Comprehensive Tool for Reproducible Research in {R}},",
                               author = "  author = {Yihui Xie},",
                               publisher = "  publisher = {Chapman and Hall/CRC},",
                               year = "  year = {2014},",
                               note = "  note = {ISBN 978-1466561595},",
                               "}"),
                             class = "Bibtex"))


})

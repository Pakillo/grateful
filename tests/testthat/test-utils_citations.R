

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

  skip_on_cran()

  # note package version and year may change
  expect_identical(get_citation_and_citekey("grateful", skip.missing = FALSE),
                   structure(c("@Manual{grateful,",
                               title = "title = {{grateful}: Facilitate citation of {R} packages},",
                               author = "  author = {Francisco Rodriguez-Sanchez and Connor P. Jackson},",
                               year = "  year = {2025},",
                               url = "  url = {https://pakillo.github.io/grateful/},",
                               "}"),
                             class = "Bibtex"))

})


test_that("Test get_citation_and_citekey when skip.missing = TRUE", {

  skip_on_cran()

  # note package version and year may change
  expect_identical(get_citation_and_citekey("grateful", skip.missing = TRUE),
                   structure(c("@Manual{grateful,",
                               title = "title = {{grateful}: Facilitate citation of {R} packages},",
                               author = "  author = {Francisco Rodriguez-Sanchez and Connor P. Jackson},",
                               year = "  year = {2025},",
                               url = "  url = {https://pakillo.github.io/grateful/},",
                               "}"),
                             class = "Bibtex"))

  expect_warning(get_citation_and_citekey("fakepkg", skip.missing = TRUE))
  expect_null(suppressWarnings(get_citation_and_citekey("fakepkg", skip.missing = TRUE)))

})

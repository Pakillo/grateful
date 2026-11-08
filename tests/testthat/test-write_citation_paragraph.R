test_that("only R is cited if there are no extra packages", {

  df <- data.frame(pkg = "base", version = "4.6.2", citekeys = "base")
  expect_equal(write_citation_paragraph(df),
               "We used R v. 4.6.2 [@base].")
})

test_that("citation paragraph is well formatted", {

  df <- data.frame(pkg = c("base", "grateful"), version = c("4.6.2", "0.3.1"), citekeys = c("base", "grateful"))
  expect_equal(write_citation_paragraph(df),
               "We used R v. 4.6.2 [@base] and the following R packages: grateful v. 0.3.1 [@grateful].")
})

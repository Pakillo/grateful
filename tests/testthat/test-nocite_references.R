test_that("nocite_references works", {
  citekeys <- cite_packages(output = "citekeys", out.dir = tempdir(), pkgs = "grateful")
  out <- nocite_references(citekeys)
  expect_equal(out,
               structure("---\nnocite: |\n\t @grateful \n...",
                         class = "knit_asis",
                         knit_cacheable = NA))
})

test_that("NULL arguments return error", {
  expect_error(render_citations())
  expect_error(render_citations(Rmd.file = "test"))
  expect_error(render_citations(out.dir = tempdir()))
})


test_that("render_citations returns a report", {

  skip_on_cran()
  skip_on_ci()

  pkgs <- get_pkgs_info(pkgs = "grateful", out.dir = tempdir())
  rmd <- create_rmd(pkgs.df = pkgs, out.dir = tempdir(), out.format = "Rmd")

  #html
  rendcit <- render_citations(Rmd.file = rmd, out.dir = tempdir())
  expect_equal(rendcit, file.path(tempdir(), "grateful-report.html"))
  expect_true(file.exists(file.path(tempdir(), "grateful-report.html")))

  #docx
  rendcit <- render_citations(Rmd.file = rmd, out.dir = tempdir(), out.format = "docx")
  expect_equal(rendcit, file.path(tempdir(), "grateful-report.docx"))
  expect_true(file.exists(file.path(tempdir(), "grateful-report.docx")))

  #pdf
  rendcit <- render_citations(Rmd.file = rmd, out.dir = tempdir(), out.format = "pdf")
  expect_equal(rendcit, file.path(tempdir(), "grateful-report.pdf"))
  expect_true(file.exists(file.path(tempdir(), "grateful-report.pdf")))

  #md
  rendcit <- render_citations(Rmd.file = rmd, out.dir = tempdir(), out.format = "md")
  expect_equal(rendcit, file.path(tempdir(), "grateful-report.md"))
  expect_true(file.exists(file.path(tempdir(), "grateful-report.md")))

})

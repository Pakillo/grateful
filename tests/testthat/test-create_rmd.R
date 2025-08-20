test_that("NULL arguments return error", {
  expect_error(create_rmd())
  expect_error(create_rmd(pkgs.df = get_pkgs_info(pkgs = "renv", out.dir = tempdir())))
  expect_error(create_rmd(out.dir = tempdir()))
})


test_that("create_rmd produces correct Rmd", {

  skip_on_cran()
  # skip_on_ci()

  pkgs <- get_pkgs_info(pkgs = "grateful", out.dir = tempdir())
  rmd <- create_rmd(pkgs.df = pkgs, out.dir = tempdir(), out.format = "Rmd")
  rmd.file <- readLines(rmd)
  #dput(rmd.file)

  expect_equal(rmd, file.path(tempdir(), "grateful-report.Rmd"))
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



test_that("csl is downloaded if needed", {
  skip_on_cran()
  pkgs <- get_pkgs_info(pkgs = "grateful", out.dir = tempdir())
  rmd <- create_rmd(pkgs.df = pkgs, out.dir = tempdir(), out.format = "Rmd",
                    csl = "peerj")
  expect_true(file.exists(file.path(tempdir(), "peerj.csl")))

})


test_that("rendered report is produced", {
  skip_on_cran()
  # skip_on_ci()
  pkgs <- get_pkgs_info(pkgs = "grateful", out.dir = tempdir())
  rmd <- create_rmd(pkgs.df = pkgs, out.dir = tempdir(), out.format = "html")
  expect_true(file.exists(file.path(tempdir(), "grateful-report.html")))
  expect_true(!file.exists(file.path(tempdir(), "grateful-report.Rmd")))

})

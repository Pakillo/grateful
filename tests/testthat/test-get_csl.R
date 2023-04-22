test_that("arguments are provided", {
  expect_error(get_csl())
  expect_error(get_csl(name = "peerj"))
  expect_error(get_csl(out.dir = tempdir()))
})

test_that("get_csl works", {
  skip_on_ci()
  skip_on_cran()
  csl <- get_csl("peerj", out.dir = tempdir())
  expect_equal(csl, file.path(tempdir(), "peerj.csl"))
  expect_true(file.exists(file.path(tempdir(), "peerj.csl")))
})

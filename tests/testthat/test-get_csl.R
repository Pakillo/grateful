test_that("arguments are provided", {
  expect_error(get_csl())
  expect_error(get_csl(name = "peerj"))
  expect_error(get_csl(out.dir = tempdir()))
  expect_error(get_csl(out.dir = tempdir(), name = "non-existent-journal"))
})

test_that("get_csl works", {
  skip_if_offline()
  skip_on_cran()

  # style available on root folder of the official styles repo
  csl <- get_csl("peerj", out.dir = tempdir())
  expect_equal(csl, file.path(tempdir(), "peerj.csl"))
  expect_true(file.exists(file.path(tempdir(), "peerj.csl")))

  # style hosted on the 'dependent' folder in the official styles repo
  csl <- get_csl("journal-of-ecology", out.dir = tempdir())
  expect_equal(csl, file.path(tempdir(), "journal-of-ecology.csl"))
  expect_true(file.exists(file.path(tempdir(), "journal-of-ecology.csl")))
})

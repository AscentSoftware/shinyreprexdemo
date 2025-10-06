test_that("Repro is able to work with given character string", {
  expect_identical(shinyrepro::repro("test"), "test")
})

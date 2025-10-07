test_that("Repro is able to work with given character string", {
  expect_s7_class(shinyrepro::repro("test"), Repro)
})

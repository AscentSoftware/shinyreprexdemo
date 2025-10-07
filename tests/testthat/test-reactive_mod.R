test_that("UI is generated with valid ID", {
  expect_s3_class(reactiveTabUI("reactive"), "shiny.tag.list")
})

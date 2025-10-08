test_that("Able to create tab UI with simple title and description", {
  module_server <- function(id) {
    shiny::moduleServer(id, function(input, output, session) {
      output$this <- renderText(input$hello)
    })
  }

  ui <- repro_tab_ui(
    id = "test",
    title = "Module title",
    description = "Module description",
    server_fn = module_server
  )

  expect_s3_class(ui, "shiny.tag.list")
})

test_that("Able to create tab UI with filters", {
  module_server <- function(id) {
    shiny::moduleServer(id, function(input, output, session) {
      output$this <- renderText(input$hello)
    })
  }

  ui <- repro_tab_ui(
    id = "test",
    title = "Module title",
    description = "Module description",
    server_fn = module_server,
    filters = tagList(
      textInput("hello", "Dummy Input")
    )
  )

  expect_s3_class(ui, "shiny.tag.list")
})

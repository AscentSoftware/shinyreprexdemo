#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'
#' @import data.table
#' @import shiny
#'
#' @noRd
app_ui <- function(request) {
  tagList(
    add_external_resources(),
    fluidPage(
      h1("Shiny Repro Example"),
      tabsetPanel(
        selected = "Input",
        tabPanel("Reactive", reactiveTabUI("reactive")),
        tabPanel("Input", inputTabUI("input"))
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @noRd
add_external_resources <- function() {
  addResourcePath("www", app_sys("app/www"))

  tags$head(
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "Shiny Repro Example"
    )
  )
}

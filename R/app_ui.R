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
    bslib::page_fluid(
      title = "Shiny Repro Explorer",
      class = "min-vh-100 bg-body p-4 p-lg-5",
      div(
        class = "mb-3 mb-lg-3",
        h1("Shiny Repro Explorer"),
        tags$p(
          class = "text-muted",
          "Interactive demonstration of modular Shiny application design patterns.",
          "Each module showcases reusable components with reproducible code."
        )
      ),
      bslib::navset_tab(
        bslib::nav_panel("Reactive", reactiveTabUI("reactive")),
        bslib::nav_panel("Input", inputTabUI("input")),
        bslib::nav_panel("Bind Event", bindTabUI("bind")),
        bslib::nav_panel("Reactive Val", reactiveValTabUI("reactiveVal")),
        bslib::nav_panel("Reactive Values", reactiveValuesTabUI("reactiveValues")),
        bslib::nav_panel("Passed Reactive", passedReactiveTabUI("passed_reactive")),
        bslib::nav_panel("Multi Level", multiLevelModuleUI("multi_module")),
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

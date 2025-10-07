#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'
#' @noRd
app_server <- function(input, output, session) {
  react_adsl <- reactiveTabServer("reactive")

  inputTabServer("input")

  reactiveValTabServer("reactiveVal")

  reactiveValuesTabServer("reactiveValues")

  passedReactiveTabServer("passed_reactive", adsl = react_adsl)

  multiLevelModuleServer("multi_module")
}

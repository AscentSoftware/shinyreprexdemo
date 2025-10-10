#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'
#' @noRd
app_server <- function(input, output, session) {
  react_adsl <- reactiveTabServer("reactive")

  inputTabServer("input")

  bindTabServer("bind")

  reactiveValTabServer("reactiveVal")

  reactiveValuesTabServer("reactiveValues")

  passedReactiveTabServer("passed_reactive", adsl = react_adsl)

  ifelseTabServer("ifelse")

  multiLevelModuleServer("multi_module")
}

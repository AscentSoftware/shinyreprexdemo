#' @details
#' \code{passedReactiveTabUI} - A reactive from another module being used in the selected module
#'
#' @rdname repro_modules
passedReactiveTabUI <- function(id) {
  repro_tab_ui(
    id = id,
    title = "Reactive Input Argument",
    description = paste(
      "Taking a reactive object sent as an argument into the module,",
      "and using in the summary calculation. In this example, adsl has",
      "come from the 'Reactive' tab."
    ),
    server_fn = passedReactiveTabServer,
  )
}

#' @rdname repro_modules
#' @noRd
passedReactiveTabServer <- function(id, adsl) {
  moduleServer(id, function(input, output, session) {
    table_code <- reactive({
      dat <- dtlg::summary_table(
        dt = adsl(),
        target = "AGE",
        treat = "TRT01A",
        target_name = attr(adsl()$AGE, "label")
      )

      reactable::reactable(
        dat,
        defaultColDef = reactable::colDef(html = TRUE)
      )
    })

    output$code <- highlighter::renderHighlighter({
      highlighter::highlighter(shinyrepro::repro(table_code))
    })
    output$table <- reactable::renderReactable(table_code())
  })
}

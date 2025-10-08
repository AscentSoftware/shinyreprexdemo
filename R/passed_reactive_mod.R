#' @rdname passed_reactive_mod
#' @noRd
passedReactiveTabUI <- function(id) {
  repro_tab_ui(
    id = id,
    title = "Reactive Input Argument",
    description = paste(
      "Taking a reactive object sent as an argument into the module,",
      "and using in the summary calculation."
    ),
    server_fn = passedReactiveTabServer,
  )
}

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

    output$code <- shinyrepro::renderRepro(table_code)

    output$table <- reactable::renderReactable(table_code())
  })
}

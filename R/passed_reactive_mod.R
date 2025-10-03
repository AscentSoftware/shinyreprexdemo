passedReactiveTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    h3("Reactive Input Argument"),
    p("Taking a reactive object sent as an argument into the module, and using in the summary calculation."),
    fluidRow(
      column(
        width = 6,
        highlighter::highlighterOutput(ns("code")),
        reactable::reactableOutput(ns("table"))
      ),
      column(
        width = 6,
        h4("Module Code"),
        highlighter::highlighter(
          paste(format(passedReactiveTabServer, width = 80), collapse = "\n")
        )
      )
    )
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

    output$code <- highlighter::renderHighlighter(
      highlighter::highlighter(repro(table_code)@script)
    )

    output$table <- reactable::renderReactable(table_code())
  })
}

utils::globalVariables("COUNTRY")

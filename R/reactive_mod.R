reactiveTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    h3("Extracting Dataset from Reactive"),
    p("Taking the value of an input value in a reactive, and using in the summary calculation."),
    fluidRow(
      column(
        width = 6,
        shinyrepro::reproOutput(ns("code")),
        reactable::reactableOutput(ns("table"))
      ),
      column(
        width = 6,
        h4("Module Code"),
        highlighter::highlighter(
          paste(format(reactiveTabServer, width = 80), collapse = "\n")
        )
      )
    )
  )
}

reactiveTabServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    adsl <- reactive(data.table(dtlg::adsl)[COUNTRY == "USA"])

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

    output$code <- shinyrepro::renderRepro(shinyrepro::repro(table_code)@script)

    output$table <- reactable::renderReactable(table_code())

    adsl
  })
}

utils::globalVariables("COUNTRY")

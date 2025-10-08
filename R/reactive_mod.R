reactiveTabUI <- function(id) {
  repro_tab_ui(
    id = id,
    title = "Extracting Dataset from Reactive",
    description = "Taking the value of an input value in a reactive, and using in the summary calculation.",
    server_fn = reactiveTabServer
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

    output$code <- shinyrepro::renderRepro(table_code)

    output$table <- reactable::renderReactable(table_code())

    adsl
  })
}

utils::globalVariables("COUNTRY")

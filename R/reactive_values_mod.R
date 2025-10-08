reactiveValuesTabUI <- function(id) {
  ns <- NS(id)

  repro_tab_ui(
    id = id,
    title = "Extracting Dataset from Reactive Values",
    description = paste(
      "Assigning an input to an object within reactiveValues,",
      "then using that value in the summary calculation."
    ),
    server_fn = reactiveValuesTabServer,
    filters = selectizeInput(
      ns("summary_vars"),
      "Select Summary Variables",
      purrr::set_names(names(ADSL_FILTER_VARS), ADSL_FILTER_VARS),
      multiple = TRUE,
      options = list(dropdownParent = "body")
    )
  )
}

reactiveValuesTabServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    rv <- reactiveValues(summary_vars = NULL)

    observe(rv$summary_vars <- input$summary_vars)

    table_code <- reactive({
      req(rv$summary_vars)

      adsl <- data.table(dtlg::adsl)
      dat <- dtlg::summary_table(
        dt = adsl,
        target = rv$summary_vars,
        treat = "TRT01A",
        target_name = vapply(rv$summary_vars, \(x) attr(adsl[[x]], "label"), character(1L))
      )

      reactable::reactable(
        dat,
        defaultColDef = reactable::colDef(html = TRUE)
      )
    })

    output$code <- highlighter::renderHighlighter({
      req(rv$summary_vars)
      highlighter::highlighter(shinyrepro::repro(table_code)@script)
    })

    output$table <- reactable::renderReactable(table_code())
  })
}

reactiveValTabUI <- function(id) {
  ns <- NS(id)

  repro_tab_ui(
    id = id,
    title = "Extracting Dataset from Reactive Val",
    description = "Assigning an input to a reactiveVal, then using that value in the summary calculation.",
    server_fn = reactiveValTabServer,
    filters = selectizeInput(
      ns("summary_vars"),
      "Select Summary Variables",
      purrr::set_names(names(ADSL_FILTER_VARS), ADSL_FILTER_VARS),
      multiple = TRUE,
      options = list(dropdownParent = "body")
    )
  )
}

reactiveValTabServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    summary_vars <- reactiveVal(NULL)

    observe(summary_vars(input$summary_vars))

    table_code <- reactive({
      req(summary_vars())

      adsl <- data.table(dtlg::adsl)
      dat <- dtlg::summary_table(
        dt = adsl,
        target = summary_vars(),
        treat = "TRT01A",
        target_name = vapply(summary_vars(), \(x) attr(adsl[[x]], "label"), character(1L))
      )

      reactable::reactable(
        dat,
        defaultColDef = reactable::colDef(html = TRUE)
      )
    })

    output$code <- highlighter::renderHighlighter({
      req(summary_vars())
      highlighter::highlighter(shinyrepro::repro(table_code)@script)
    })

    output$table <- reactable::renderReactable(table_code())
  })
}

inputTabUI <- function(id) {
  ns <- NS(id)

  repro_tab_ui(
    id = id,
    title = "Extracting Shiny Input",
    description = "Taking the value of a Shiny input, and using in the summary calculation.",
    server_fn = inputTabServer,
    filters = selectizeInput(
      ns("summary_var"),
      "Select Summary Variable",
      purrr::set_names(names(ADSL_FILTER_VARS), ADSL_FILTER_VARS),
      options = list(dropdownParent = "body")
    )
  )
}

inputTabServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    table_code <- reactive({
      dat <- dtlg::summary_table(
        dt = dtlg::adsl,
        target = input$summary_var,
        treat = "TRT01A",
        target_name = attr(dtlg::adsl[[input$summary_var]], "label")
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

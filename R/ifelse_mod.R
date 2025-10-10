ifelseTabUI <- function(id) {
  ns <- NS(id)

  repro_tab_ui(
    id = id,
    title = "If/Else Segment",
    description = "Only keeping the code within an if/else block that is executed in the reactive",
    server_fn = ifelseTabServer,
    filters = selectizeInput(
      ns("summary_var"),
      "Select Summary Variable",
      purrr::set_names(names(ADSL_FILTER_VARS), ADSL_FILTER_VARS),
      options = list(dropdownParent = "body")
    )
  )
}

ifelseTabServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    is_numeric_var <- reactive(is.numeric(dtlg::adsl[[input$summary_var]]))
    table_code <- reactive({
      if (FALSE) {
        # Placeholder to show if ... else if ... else
      } else if (is_numeric_var()) {
        dat <- dtlg::calc_desc(
          dt = dtlg::adsl,
          target = input$summary_var,
          treat = "TRT01P",
          target_name = attr(dtlg::adsl[[input$summary_var]], "label")
        )
      } else {
        dat <- dtlg::calc_counts(
          dt = dtlg::adsl,
          target = input$summary_var,
          treat = "TRT01A",
          target_name = attr(dtlg::adsl[[input$summary_var]], "label")
        )
      }

      reactable::reactable(
        dat[[1]],
        defaultColDef = reactable::colDef(html = TRUE)
      )
    })

    output$code <- highlighter::renderHighlighter({
      highlighter::highlighter(shinyrepro::repro(table_code))
    })

    output$table <- reactable::renderReactable(table_code())
  })
}

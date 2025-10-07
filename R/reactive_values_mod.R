reactiveValuesTabUI <- function(id) {
  ns <- NS(id)

  non_date_vars <- dtlg::adsl |>
    purrr::discard(inherits, what = c("Date", "POSIXct")) |>
    purrr::map(purrr::attr_getter("label"))

  tagList(
    h3("Extracting Dataset from Reactive Values"),
    p("Taking the value of a stored object within a reactiveValues, and using in the summary calculation."),
    fluidRow(
      column(
        width = 6,
        selectInput(
          ns("summary_vars"),
          "Select Summary Variable",
          purrr::set_names(names(non_date_vars), non_date_vars),
          multiple = TRUE
        ),
        highlighter::highlighterOutput(ns("code")),
        reactable::reactableOutput(ns("table"))
      ),
      column(
        width = 6,
        h4("Module Code"),
        highlighter::highlighter(
          paste(format(reactiveValTabServer, width = 80), collapse = "\n")
        )
      )
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

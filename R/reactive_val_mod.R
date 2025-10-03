reactiveValTabUI <- function(id) {
  ns <- NS(id)

  non_date_vars <- dtlg::adsl |>
    purrr::discard(inherits, what = c("Date", "POSIXct")) |>
    purrr::map(purrr::attr_getter("label"))

  tagList(
    h3("Extracting Dataset from Reactive Val"),
    p("Taking the value of an input value in a reactiveVal, and using in the summary calculation."),
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
      highlighter::highlighter(repro(table_code)@script)
    })

    output$table <- reactable::renderReactable(table_code())
  })
}

inputTabUI <- function(id) {
  ns <- NS(id)

  non_date_vars <- dtlg::adsl |>
    purrr::discard(inherits, what = c("Date", "POSIXct")) |>
    purrr::map(purrr::attr_getter("label"))

  tagList(
    h3("Extracting Shiny Input"),
    p("Taking the value of a Shiny input, and using in the summary calculation."),
    fluidRow(
      column(
        width = 6,
        selectInput(
          ns("summary_var"),
          "Select Summary Variable",
          purrr::set_names(names(non_date_vars), non_date_vars)
        ),
        highlighter::highlighterOutput(ns("code")),
        reactable::reactableOutput(ns("table"))
      ),
      column(
        width = 6,
        h4("Module Code"),
        highlighter::highlighter(
          paste(format(inputTabServer), collapse = "\n")
        )
      )
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

    output$code <- highlighter::renderHighlighter(
      highlighter::highlighter(shinyrepro::repro(table_code)@script)
    )

    output$table <- reactable::renderReactable(table_code())
  })
}

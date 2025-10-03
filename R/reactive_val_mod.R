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
          paste(format(reactiveValTabServer, width = 80), collapse = "\n")
        )
      )
    )
  )
}

#' @import ggplot2
reactiveValTabServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    summary_var <- reactiveVal(NULL)

    observe(summary_var(input$summary_var))

    table_code <- reactive({
      req(summary_var())

      adsl <- data.table(dtlg::adsl)
      dat <- dtlg::calc_stats(
        dt = adsl,
        target = summary_var(),
        treat = "TRT01A",
        target_name = attr(adsl[[summary_var()]], "label")
      )

      reactable::reactable(
        dat[[1]],
        defaultColDef = reactable::colDef(html = TRUE)
      )
    })

    output$code <- highlighter::renderHighlighter(
      highlighter::highlighter(repro(table_code)@script)
    )

    output$table <- reactable::renderReactable(table_code())
  })
}

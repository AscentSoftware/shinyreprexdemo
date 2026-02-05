#' @details
#' \code{bindTabUI} - \code{\link[shiny]{bindEvent}} and \code{\link[shiny]{bindCache}} being used within a reactive
#'
#' @rdname repro_modules
bindTabUI <- function(id) {
  ns <- NS(id)

  repro_tab_ui(
    id = id,
    title = "Ignoring bindEvent",
    description = "Extracting the reactive from a given bindCache and bindEvent to get correct code.",
    server_fn = bindTabServer,
    filters = selectizeInput(
      ns("summary_var"),
      "Select Summary Variable",
      purrr::set_names(names(ADSL_FILTER_VARS), ADSL_FILTER_VARS),
      options = list(dropdownParent = "body")
    )
  )
}

#' @rdname repro_modules
#' @noRd
bindTabServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    summary_var <- reactive({
      input$summary_var
    }) |>
      bindEvent(input$summary_var)

    table_code <- reactive({
      dat <- dtlg::summary_table(
        dt = dtlg::adsl,
        target = summary_var(),
        treat = "TRT01A",
        target_name = attr(dtlg::adsl[[summary_var()]], "label")
      )

      reactable::reactable(
        dat,
        defaultColDef = reactable::colDef(html = TRUE)
      )
    }) |>
      bindCache(summary_var()) |>
      bindEvent(summary_var())

    output$code <- highlighter::renderHighlighter({
      highlighter::highlighter(shinyreprex::reprex_reactive(table_code))
    })

    output$table <- reactable::renderReactable(table_code())
  })
}

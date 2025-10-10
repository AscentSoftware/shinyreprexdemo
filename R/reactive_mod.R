#' Reproducible Code Modules
#'
#' @description
#' A series of modules that are used to show how the reproducing of Shiny code works.
#'
#' @param id An ID string that identifies the namespace of the UI and server components.
#'
#' @details
#' \code{reactiveTabUI} - A reactive object being passed into another reactive object
#'
#' @rdname repro_modules
reactiveTabUI <- function(id) {
  repro_tab_ui(
    id = id,
    title = "Extracting Dataset from Reactive",
    description = "Taking the value of an input value in a reactive, and using in the summary calculation.",
    server_fn = reactiveTabServer
  )
}

#' @rdname repro_modules
#' @noRd
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

    output$code <- highlighter::renderHighlighter({
      highlighter::highlighter(shinyrepro::repro(table_code))
    })

    output$table <- reactable::renderReactable(table_code())

    adsl
  })
}

utils::globalVariables("COUNTRY")

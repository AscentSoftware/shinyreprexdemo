multiLevelModuleUI <- function(id) {
  ns <- NS(id)

  repro_tab_ui(
    id = id,
    title = "Multiple Level Module",
    description = paste(
      "Passing reactive values from parent to child module, returning the",
      "result to the parent module to evaluate the code generated."
    ),
    server_fn = multiLevelModuleServer,
    filters = tagList(
      selectizeInput(
        ns("adam"),
        "ADaM dataset",
        names(getNamespaceInfo("dtlg", "lazydata")),
        selected = "adsl",
        options = list(dropdownParent = "body")
      ),
      selectizeInput(
        ns("summary_var"),
        "Select Summary Variable",
        purrr::set_names(names(ADSL_FILTER_VARS), ADSL_FILTER_VARS),
        options = list(dropdownParent = "body")
      )
    )
  )
}

#' @importFrom utils data
#' @noRd
multiLevelModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    data(list = names(getNamespaceInfo("dtlg", "lazydata")), package = "dtlg")

    adam <- reactive({
      dat <- get(input$adam, envir = asNamespace("dtlg"))
      data.table::data.table(dat)
    })

    observe({
      non_date_vars <- adam() |>
        purrr::discard(inherits, what = c("Date", "POSIXct")) |>
        purrr::map(purrr::attr_getter("label"))

      updateSelectInput(
        "summary_var",
        "Select Summary Variable",
        purrr::set_names(names(non_date_vars), non_date_vars),
        session = session
      )
    }) |>
      bindEvent(input$adam)

    tbl <- lowerLevelModuleServer(
      id = "sub_module",
      adam = adam,
      summary_var = reactive(input$summary_var)
    )

    output$code <- shinyrepro::renderRepro(tbl)

    output$table <- reactable::renderReactable(tbl())
  })
}

lowerLevelModuleServer <- function(id, adam, summary_var) {
  moduleServer(id, function(input, output, session) {
    reactive({
      dat <- dtlg::summary_table(
        dt = adam(),
        target = summary_var(),
        treat = "TRT01A",
        target_name = attr(adam()[[summary_var()]], "label")
      )

      reactable::reactable(
        dat,
        defaultColDef = reactable::colDef(html = TRUE)
      )
    })
  })
}

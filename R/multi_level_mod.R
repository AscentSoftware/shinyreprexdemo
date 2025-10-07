multiLevelModuleUI <- function(id) {
  ns <- NS(id)

  non_date_vars <- dtlg::adsl |>
    purrr::discard(inherits, what = c("Date", "POSIXct")) |>
    purrr::map(purrr::attr_getter("label"))

  tagList(
    h3("Multiple Level Module"),
    p("Taking a reactive object sent as an argument into the module, and using in the summary calculation."),
    fluidRow(
      column(
        width = 6,
        selectInput(
          ns("adam"),
          "ADaM dataset",
          names(getNamespaceInfo("dtlg", "lazydata")),
          selected = "adsl"
        ),
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
          paste(format(multiLevelModuleServer, width = 80), collapse = "\n")
        )
      )
    )
  )
}

multiLevelModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    data(list = names(getNamespaceInfo("dtlg", "lazydata")), package = "dtlg", envir = environment())

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

    output$code <- highlighter::renderHighlighter({
      highlighter::highlighter(repro(tbl)@script)
    })

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

#' Reproducible Tab Module
#'
#' @description
#' A generic module that can show reproducible code in the left hand side with
#' the module code in the right hand side.
#'
#' @param id Namespace ID to be used to communicate between UI and Server
#' @param title Title to be given to the tab
#' @param description Description to be given to the tab
#' @param server_fn Function expression that is being used for the server
#' @param filters An optional list of filters that are used in the module
#'
#' @examplesIf interactive()
#' repro_tab_ui(
#'   id = "reactive",
#'   title = "Reactive Value",
#'   description = "Taking a reactive value into the expression",
#'   server_fn = reactiveTabServer
#' )
#'
#' @export
repro_tab_ui <- function(id, title, description, server_fn, filters = NULL) {
  ns <- NS(id)

  tagList(
    h2(class = "mt-4", title),
    tags$p(class = "text-muted", description),
    shiny::fluidRow(
      div(
        class = "col-12 col-lg-7",
        if (length(filters) > 0L) {
          bslib::card(
            bslib::card_header("Parameters"),
            bslib::card_body(filters)
          )
        },
        bslib::card(
          bslib::card_header(
            class = "d-flex flex-row justify-content-between",
            div(
              "Generated Code",
              tags$p(class = "mb-0 text-muted", "View the R code used to generate this table")
            ),
            tags$button(
              class = "btn btn-secondary btn-sm",
              type = "button",
              `data-bs-toggle` = "collapse",
              `data-bs-target` = paste0("#", ns("code_body")),
              "Show Code"
            )
          ),
          bslib::card_body(
            id = ns("code_body"),
            class = "collapse",
            shinyrepro::reproOutput(ns("code"))
          )
        ),
        bslib::card(
          bslib::card_header("Data Output"),
          bslib::card_body(reactable::reactableOutput(ns("table")))
        )
      ),
      div(
        class = "col-12 col-lg-5",
        bslib::card(
          bslib::card_header("Module Code"),
          bslib::card_body(
            highlighter::highlighter(
              paste(
                styler::style_text(
                  deparse(
                    server_fn,
                    control = "all"
                  )
                ),
                collapse = "\n"
              )
            )
          )
        )
      )
    )
  )
}

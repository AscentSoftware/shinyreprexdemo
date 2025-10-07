#' Reproducible Tab Module
#'
#' @description
#' A generic module that can show reproducible code in the left hand side with
#' the module code in the right hand side.
#'
#' @param id
#' @param title
#' @param description
#' @param server_fn
#' @param filters
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

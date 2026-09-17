#' Lockfile Download Module
#'
#' @description
#' A module that is included in the navbar dropdown that allows the application user
#' to download the lockfile of the relevant packages of the reproducible reactives.
#'
#' @param id An ID string that identifies the namespace of the UI and server components.
#'
#' @rdname lockfile_module
lockfileUI <- function(id) {
  ns <- NS(id)

  bslib::nav_item(
    downloadLink(outputId = ns("dwnld_lock"), "Download lockfile")
  )
}

#' @rdname lockfile_module
lockfileServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$dwnld_lock <- downloadHandler(
      filename = function() "renv.lock",
      content = function(file) {
        withProgress(message = "Resolving package versions", {
          shinyreprex::reprex_lockfile(lockfile = file)
        })
      }
    )
  })
}

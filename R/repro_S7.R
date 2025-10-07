#' Reproduce Code
#'
#' @param code Code chunks found in a given expression
#' @param packages Packages found in the function calls in the code and/or pre-requisites
#' @param prerequesites Code chunks used to generate reactive objects found in the code
#'
#' @importFrom styler style_text
#'
#' @rdname repro_s7
#' @export
Repro <- S7::new_class(
  name = "Repro",
  properties = list(
    code = S7::new_property(
      S7::class_list,
      default = list(),
      setter = function(self, value) {
        if (!length(value) && length(self@code)) return(self)

        self@code <- c(self@code, value)
        self
      }
    ),

    packages = S7::new_property(
      S7::class_character,
      default = character(),
      setter = function(self, value) {
        if (!length(value) && length(self@packages)) return(self)

        self@packages <- unique(c(self@packages, value))
        self
      }
    ),

    prerequesites = S7::new_property(
      S7::class_list,
      default = list(),
      setter = function(self, value) {
        if (!length(value) && length(self@prerequesites)) return(self)

        if (length(self@prerequesites) == 0L || !names(value) %in% names(self@prerequesites)) {
          self@prerequesites <- c(self@prerequesites, value)
        }
        self
      }
    ),

    script = S7::new_property(
      getter = function(self) {
        pkg_calls <- if (length(self@packages)) c(paste0("library(", self@packages, ")"), "") else NULL

        prereq_calls <- self@prerequesites |>
          unlist(recursive = FALSE, use.names = FALSE) |>
          purrr::map(deparse) |>
          unlist()

        code_calls <- self@code |>
          purrr::map(deparse) |>
          unlist()

        c(pkg_calls, prereq_calls, code_calls) |>
          styler::style_text() |>
          paste(collapse = "\n")
      }
    )
  )
)

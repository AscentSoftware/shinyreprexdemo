#' Reproduce Code
#'
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
        pkgs <- paste0("library(", self@packages, ")")
        pre_reqs <- unlist(self@prerequesites, recursive = FALSE, use.names = FALSE)

        paste(c(pkgs, "", as.character(pre_reqs), as.character(self@code))) |>
          formatR::tidy_source(text = _, output = FALSE) |>
          purrr::pluck("text.tidy") |>
          paste(collapse = "\n")
      }
    )
  )
)

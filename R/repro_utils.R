is_reactive_call <- function(x, env = rlang::caller_env()) {
  rlang::is_call(x) && length(rlang::call_args(x)) == 0 && rlang::call_name(x) %in% names(env)
}

is_subset_call <- function(x) {
  rlang::is_call(x, c("$", "[", "[["))
}

is_input_call <- function(x) {
  rlang::is_call(x, "$") && identical(as.character(x[[2]]), "input")
}

#' Get Call Package Name
#'
#' @noRd
get_pkg_name <- function(x, base_pkgs = rownames(installed.packages(priority = "base"))) {
  pkg_name <- tryCatch(
    x |> rlang::call_name() |> get() |> environment() |> getNamespaceName() |> unname(),
    error = \(e) NULL
  )

  if (is.null(pkg_name) || pkg_name %in% base_pkgs) {
    NULL
  } else {
    pkg_name
  }
}


#' @export
repro <- function(x, env = rlang::caller_env()) {
  UseMethod("repro")
}

#' @export
repro.default <- function(x, ...) {
  x
}

#' @export
repro.reactiveExpr <- function(x, env = rlang::caller_env()) {
  observer <- attr(x, "observable", exact = TRUE)
  reactive_body <- rlang::fn_body(observer$.origFunc)
  reactive_exprs <- as.list(reactive_body)[-1]

  # browser()
  lapply(reactive_exprs, \(x) repro(x, env = env))

  as.character(reactive_exprs)
}

#' @importFrom rlang !!!
#' @export
repro.call <- function(x, env = rlang::caller_env()) {
  # if (length(rlang::call_args(x)) == 0) browser()
  eval_args <- lapply(rlang::call_args(x), \(x) repro(x, env = env))
  rlang::call2(rlang::call_name(x), !!!eval_args)
}

#' Reproduce Code
#'
#' @param x Reactive object
#' @param env The environment the
#' @param ... Additional arguments passed to methods
#'
#' @export
repro <- function(x, ..., env = rlang::caller_env()) {
  UseMethod("repro")
}

#' @export
repro.default <- function(x, ..., env = rlang::caller_env()) {
  if (inherits(x, "<-")) repro.call(x, env = env) else x
}

#' @export
repro.reactiveExpr <- function(x, ..., init = TRUE, env = rlang::caller_env()) {
  observer <- attr(x, "observable", exact = TRUE)
  reactive_body <- rlang::fn_body(observer$.origFunc)
  reactive_exprs <- as.list(reactive_body)[-1]

  module_env <- rlang::env_parent(env = environment(observer$.origFunc))
  reactive_calls <- lapply(reactive_exprs, \(x) repro(x, env = module_env))

  pre_assigns <- purrr::map(reactive_calls, purrr::attr_getter("pre_assigns")) |>
    purrr::discard(is.null) |>
    unlist(recursive = FALSE)

  if (length(pre_assigns) == 0L) {
    reactive_calls
  } else if (init) {
    c(pre_assigns, reactive_calls)
  } else {
    structure(reactive_calls, pre_assigns = pre_assigns)
  }
}

#' @importFrom rlang !!!
#' @export
repro.call <- function(x, ..., env = rlang::caller_env()) {
  pre_assigns <- NULL
  if (is.null(rlang::call_name(x))) return(x)

  if (is_input_call(x)) {
    eval_call <- eval(x, envir = env)
  } else if (is_reactive_call(x, env)) {
    eval_args <- repro(env[[rlang::call_name(x)]], init = FALSE)
    eval_call <- rlang::call2("<-", as.symbol(rlang::call_name(x)), !!!eval_args)
  } else {
    reactive_calls <- vapply(rlang::call_args(x), is_reactive_call, env = env, logical(1L))
    eval_args <- lapply(rlang::call_args(x), \(x) repro(x, init = FALSE, env = env))
    if (any(reactive_calls)) {
      pre_reactive_calls <- unname(eval_args[reactive_calls])
      eval_args[reactive_calls] <- lapply(pre_reactive_calls, \(y) rlang::call_args(y)[[1L]])
      pre_assigns <- pre_reactive_calls
    }

    pkg <- if (rlang::is_call(x[[1]], "::")) as.character(x[[1]][[2]]) else NULL
    eval_call <- rlang::call2(rlang::call_name(x), !!!eval_args, .ns = pkg)

    eval_pre_assigns <- purrr::map(eval_args, purrr::attr_getter("pre_assigns")) |>
      purrr::discard(is.null) |>
      unlist(recursive = FALSE)
    if (length(eval_pre_assigns) > 0) pre_assigns <- c(pre_assigns, eval_pre_assigns)
  }

  if (length(pre_assigns) == 0L) eval_call else structure(eval_call, pre_assigns = pre_assigns)
}

is_reactive_call <- function(x, env = rlang::caller_env()) {
  rlang::is_call(x) && length(rlang::call_args(x)) == 0 && rlang::call_name(x) %in% names(env)
}

is_input_call <- function(x) {
  rlang::is_call(x, "$") && identical(as.character(x[[2]]), "input")
}

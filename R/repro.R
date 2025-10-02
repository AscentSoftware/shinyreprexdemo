#' Reproduce Code
#'
#' @export
repro_s7 <- S7::new_generic(
  name = "repro",
  dispatch_args = "x",
  fun = function(x, ..., env = rlang::caller_env()) S7::S7_dispatch()
)

S7::method(repro_s7, S7::class_any) <- function(x, ..., env = rlang::caller_env()) {
  x
}

S7::method(repro_s7, class_reactive) <- function(x, ..., repro_code = Repro, init = TRUE, env = rlang::caller_env()) {
  observer <- attr(x, "observable", exact = TRUE)
  reactive_body <- rlang::fn_body(observer$.origFunc)
  reactive_exprs <- as.list(reactive_body)[-1]

  module_env <- rlang::env_parent(env = environment(observer$.origFunc))
  reactive_calls <- lapply(reactive_exprs, \(x) repro_s7(x, repro_code = repro_code, env = module_env))

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

S7::method(repro_s7, class_calls) <- function(x, ..., repro_code = Repro, env = rlang::caller_env()) {
  pre_assigns <- NULL
  if (is.null(rlang::call_name(x))) return(x)

  if (is_input_call(x)) {
    eval_call <- eval(x, envir = env)
  } else if (is_reactive_call(x, env)) {
    eval_args <- repro_s7(env[[rlang::call_name(x)]], repro_code = repro_code, init = FALSE)
    eval_call <- rlang::call2("<-", as.symbol(rlang::call_name(x)), !!!eval_args)
  } else {
    reactive_calls <- vapply(rlang::call_args(x), is_reactive_call, env = env, logical(1L))
    eval_args <- lapply(rlang::call_args(x), \(x) repro_s7(x, repro_code = repro_code, init = FALSE, env = env))
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

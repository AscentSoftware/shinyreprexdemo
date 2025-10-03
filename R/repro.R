#' Reproduce Code
#'
#' @export
repro <- S7::new_generic(
  name = "repro",
  dispatch_args = "x",
  fun = function(x, ..., env = rlang::caller_env()) S7::S7_dispatch()
)

#' Generic Method for Reproducing Code
#'
#' @description
#' Standard response is to return the called object
#'
#' @noRd
S7::method(repro, S7::class_any) <- function(x, ..., repro_code = Repro(), env = rlang::caller_env()) {
  repro_code@code <- x
  repro_code
}

#' Reproducing Code for Reactive Object
#'
#' @noRd
S7::method(repro, class_reactive) <- function(x, ..., repro_code = Repro(), env = rlang::caller_env()) {
  observer <- attr(x, "observable", exact = TRUE)
  reactive_body <- rlang::fn_body(observer$.origFunc)
  reactive_exprs <- as.list(reactive_body)[-1]

  module_env <- rlang::env_parent(env = environment(observer$.origFunc))
  for (reactive_expr in reactive_exprs) {
    repro_code <- repro(reactive_expr, repro_code = repro_code, env = module_env)
  }

  repro_code
}

#' Reproducing Code for Call Object
#'
#' @noRd
S7::method(repro, class_calls) <- function(x, ..., repro_code = Repro(), env = rlang::caller_env()) {
  if (rlang::is_call(x[[1]], "::")) {
    pkg <- pkg_name <- as.character(x[[1]][[2]])
  } else {
    pkg <- NULL
    pkg_name <- get_pkg_name(x)
  }

  if (is.null(rlang::call_name(x))) {
    eval_call <- x
  } else if (is_input_call(x)) {
    eval_call <- eval(x, envir = env)
  } else if (is_reactive_val_call(x, env)) {
    reactive_val <- eval(x, envir = env)
    eval_call <- rlang::call2("<-", as.symbol(rlang::call_name(x)), reactive_val)
  } else if (is_reactive_call(x, env)) {
    repro_call <- repro(env[[rlang::call_name(x)]])
    repro_code@packages <- repro_call@packages
    eval_call <- rlang::call2("<-", as.symbol(rlang::call_name(x)), !!!repro_call@code)
  } else {
    reactive_calls <- vapply(rlang::call_args(x), is_reactive_call, env = env, logical(1L))
    repro_args <- lapply(rlang::call_args(x), \(x) repro(x, env = env))
    eval_args <- purrr::map(repro_args, "code") |> unlist(recursive = FALSE)

    if (any(reactive_calls)) {
      pre_reactive_calls <- unname(repro_args[reactive_calls])

      pre_req_args <- purrr::map(pre_reactive_calls, \(y) rlang::call_args(y@code[[1]])[[1]])
      repro_code@prerequesites <- purrr::set_names(
        purrr::map(pre_reactive_calls, "code"),
        pre_req_args
      )

      eval_args[reactive_calls] <- pre_req_args
    } else {
      repro_code@prerequesites <- purrr::map(repro_args, "prerequesites") |>
        purrr::discard(identical, list()) |>
        unlist(recursive = FALSE)
    }

    eval_call <- rlang::call2(rlang::call_name(x), !!!eval_args, .ns = pkg)
    repro_code@packages <- purrr::map(repro_args, "packages") |> unlist()
  }

  repro_code@packages <- pkg_name
  repro_code@code <- eval_call
  repro_code
}

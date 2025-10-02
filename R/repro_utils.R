is_reactive_call <- function(x, env = rlang::caller_env()) {
  rlang::is_call(x) && length(rlang::call_args(x)) == 0 && rlang::call_name(x) %in% names(env)
}

is_subset_call <- function(x) {
  rlang::is_call(x, c("$", "[", "[["))
}

is_input_call <- function(x) {
  rlang::is_call(x, "$") && identical(as.character(x[[2]]), "input")
}

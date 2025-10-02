#' Reproduce Code
#'
#' @export
Repro <- S7::new_class(
  name = "Repro",
  properties = list(
    code = S7::class_list,
    packages = S7::class_character,
    prerequesites = S7::class_list
  )
)

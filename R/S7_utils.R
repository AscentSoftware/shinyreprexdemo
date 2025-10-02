#' Custom S7 Classes
#'
#' @description
#' Additional classes to include in S7 to use in `repro` methods
#'
#' @noRd
class_reactive <- S7::new_S3_class("reactiveExpr")
class_assign <- S7::new_S3_class("<-")

class_calls <- S7::new_union(S7::class_call, class_assign)

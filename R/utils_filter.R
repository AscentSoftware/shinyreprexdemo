ADSL_FILTER_VARS <- dtlg::adsl |>
  purrr::discard(inherits, what = c("Date", "POSIXct")) |>
  purrr::map(purrr::attr_getter("label"))

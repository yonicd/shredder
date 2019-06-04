#' @inherit purrr::'%>%'
#' @importFrom purrr %>%
#' @name %>%
#' @rdname pipe
#' @export
NULL

#' @importFrom purrr %||%
#' @name %||%
#' @rdname pipe
#' @export
NULL

pars_env <- new.env()

#' @importFrom checkmate assert checkClass
check_stanfit <- function(x){
  checkmate::assert(
    checkmate::checkClass(x, "stanfit")
  )
}

#' @importFrom checkmate assert checkClass
check_brms <- function(x){
  checkmate::assert(
    checkmate::checkClass(x, "brms")
  )
}
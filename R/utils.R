#' Pipe operator imported from purrr
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom purrr %>%
#' @usage lhs \%>\% rhs
NULL

#' @importFrom purrr %||%
#' @name %||%
#' @rdname pipe
#' @usage x \%||\% y
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
    checkmate::checkClass(x, "brmsfit")
  )
}

pars_regex <- function(x){
  x <- gsub('\\[','\\\\[',x)
  x <- gsub('\\]','\\\\]',x)
  x
}

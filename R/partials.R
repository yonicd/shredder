grep_pars <- function (this, universe, ...) {
  grep(this, universe, ...)
}

#' @title Partial match functions for stanfit objects
#' @description Partial match functions used in stan_select
#' @param match character, pattern to search for
#' @param ignore.case logical to ignore the case, Default: TRUE
#' @return character
#' @rdname stan_select_partials
#' @export 
#' @importFrom rlang is_string
stan_contains <- function (match, ignore.case = TRUE) {
  
  pars <- fit@sim$pars_oi
  stopifnot(rlang::is_string(match), nchar(match) > 0)
  if (ignore.case) {
    pars <- tolower(pars)
    match <- tolower(match)
  }
  
  grep_pars(match, pars,value=TRUE)
}

#' @export
#' @rdname stan_select_partials
stan_starts_with <- function (match, ignore.case = TRUE) {
  
  pars <- fit@sim$pars_oi
  stopifnot(rlang::is_string(match), nchar(match) > 0)
  if (ignore.case) {
    pars <- tolower(pars)
    match <- tolower(match)
  }
  
  grep_pars(sprintf('^%s',match), pars,value=TRUE)
}

#' @export
#' @rdname stan_select_partials
stan_ends_with <- function (match, ignore.case = TRUE) {
  
  pars <- fit@sim$pars_oi
  stopifnot(rlang::is_string(match), nchar(match) > 0)
  if (ignore.case) {
    pars <- tolower(pars)
    match <- tolower(match)
  }
  
  grep_pars(sprintf('%s$',match), pars,value=TRUE)
}
grep_pars <- function (this, universe, ...) {
  grep(this, universe, ...)
}

#' @title Access stored pars for stan partials
#' @description Access pars currently stored that [stan_partials][shredder::stan_partials] use.
#' @return character
#' @rdname peek_pars
#' @export 
peek_pars <- function(){
  pars_env$pars
}

#' @title Partial match functions for stanfit objects
#' @description Partial match functions used in [stan_select][shredder::stan_select]
#' @param match character, pattern to search for
#' @param ignore.case logical to ignore the case, Default: TRUE
#' @param pars list of pars to search in, Default: peek_pars()
#' @examples 
#' rats <- rats_example()
#' 
#' rats%>%
#'   stan_names()
#' 
#' rats%>%
#'   stan_select(stan_contains('sq'))
#' 
#' rats%>%
#'   stan_select(mu_alpha, stan_contains('sq'))
#'   
#' rats%>%
#'   stan_select(stan_starts_with('mu'))
#'
#' rats%>%
#'   stan_select(stan_starts_with('mu'),stan_contains('sq'))
#'   
#'   
#' rats%>%
#'   stan_select(stan_ends_with('0'))
#' 
#' # free form regex in contains   
#' rats%>%
#'   stan_select(stan_contains('sq|mu'))
#' 
#' 
#' @return character
#' @rdname stan_partials
#' @family subsetting
#' @export 
#' @importFrom rlang is_string
stan_contains <- function (match, ignore.case = TRUE,pars = peek_pars()) {
  
  stopifnot(rlang::is_string(match), nchar(match) > 0)
  if (ignore.case) {
    pars <- tolower(pars)
    match <- tolower(match)
  }
  
  grep_pars(match, pars,value=TRUE)
}

#' @export
#' @rdname stan_partials
stan_starts_with <- function (match, ignore.case = TRUE,pars = peek_pars()) {
  
  stopifnot(rlang::is_string(match), nchar(match) > 0)
  if (ignore.case) {
    pars <- tolower(pars)
    match <- tolower(match)
  }
  
  grep_pars(sprintf('^%s',match), pars,value=TRUE)
}

#' @export
#' @rdname stan_partials
stan_ends_with <- function (match, ignore.case = TRUE,pars = peek_pars()) {
  
  stopifnot(rlang::is_string(match), nchar(match) > 0)
  if (ignore.case) {
    pars <- tolower(pars)
    match <- tolower(match)
  }
  
  grep_pars(sprintf('%s$',match), pars,value=TRUE)
}
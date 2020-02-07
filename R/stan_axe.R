#' @title Remove elements from stanfit object
#' @description Safely remove large elements from stanfit objects that are not needed for postprocessing.
#' @param object stanfit
#' @param what name of attribute to remove, Default: c("summary", "fit_instance", "stanmodel")
#' @details 
#' 
#' shredder can remove three elements in the `stanfit` object 
#' - The cached fit summary stored in fit@`.MISC`$summary
#' - The cached cpp object stored in fit@.MISC$stan_fit_instance
#' - The stanmodel stored in fit@stanmodel
#' 
#' @return stanfit
#' @rdname stan_axe
#' @family utility
#' @export 
#' @importFrom utils getFromNamespace
stan_axe <- function(object, what = c('summary','fit_instance','stanmodel')){
  what <- match.arg(what,c('summary','fit_instance','stanmodel'))
  utils::getFromNamespace(sprintf('clear_%s',what),asNamespace('shredder'))(object)
}

clear_summary <- function(object){
  check_stanfit(object)
  if(exists('summary',envir = object@`.MISC`))
    rm('summary',envir = object@`.MISC`)
  
  object
}

clear_fit_instance <- function(object){
  
  check_stanfit(object)
  if(exists('stan_fit_instance',envir = object@`.MISC`))
    rm('stan_fit_instance',envir = object@`.MISC`)
  
  object
}

clear_stanmodel <- function(object){
  
  check_stanfit(object)
  attr(object,'stanmodel') <- NULL
  object
  
}
#' @title The Par Names of a Stanfit Object
#' @description Functions to get the names of a stanfit object.
#' @param x a stanfit object
#' @param expand logical, if TRUE par names are returned including dimesnion 
#'   indicies (fnames_oi), Default: FALSE
#' @examples 
#' \donttest{
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%stan_names()
#' 
#' rats%>%stan_names(expand = TRUE)
#' }
#' @return character
#' @rdname stan_names
#' @family utility
#' @export 
stan_names <- function(x,expand = FALSE){
  UseMethod('stan_names',x)
}

#' @export 
stan_names.brmsfit <- function(x,expand = FALSE){
  stan_names(x$fit,expand=expand)
}

#' @export 
stan_names.stanfit <- function(x,expand = FALSE){
  
  if(expand){
    
    x@sim$fnames_oi
    
  }else{
    
    # This is a problem sometimes
    #x@sim$pars_oi
    
    unique(gsub('\\[(.*?)$','',x@sim$fnames_oi))
  }
}
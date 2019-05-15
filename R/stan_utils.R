#' @importFrom purrr map
stan_subset <- function(x,idx){
  
  x <- purrr::map(x,.f=function(y,idx) y[idx],idx=idx)
  
  obj <- attr(x,"sampler_params")
  sub_obj <- purrr::map(obj,.f=function(y,idx) y[idx],idx=idx)
  attr(x,"sampler_params") <- sub_obj

  x
  
}

#' @importFrom purrr map
stan_trim_postwarm <- function(x,idx){
  
  purrr::map(x,.f = function(y,idx) y[idx] , idx = idx)
  
}

#' @title The Par Names of a Stanfit Object
#' @description Functions to get the names of a stanfit object.
#' @param x a stanfit object
#' @param expand logical, if TRUE par names are returned including dimesnion 
#'   indicies (fnames_oi), Default: FALSE
#' @examples 
#' rats <- rats_example()
#' 
#' rats%>%stan_names()
#' 
#' rats%>%stan_names(expand = TRUE)
#' 
#' @return character
#' @rdname stan_names
#' @family utility
#' @export 
stan_names <- function(x,expand = FALSE){
  
  check_stanfit(x)
  
  if(expand){
    
    x@sim$fnames_oi
    
  }else{
    
    x@sim$pars_oi
    
  }
}

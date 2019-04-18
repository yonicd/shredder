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
  purrr::map(x,.f = function(y,idx) y[idx] , idx=idx)
}

#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param object PARAM_DESCRIPTION
#' @param size PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[purrr]{map}}
#' @rdname stan_sample_n
#' @export 
#' @importFrom purrr map
stan_sample_n <- function(object,size){
  
  warm_x <- seq_len(object@sim$warmup)
  iter_x <- seq_len(object@sim$iter)[-warm_x]
  
  
  samp <- sample(iter_x,size=size)
  
  inits_x <- samp - length(warm_x)
  
  samp <- c(warm_x,samp) 
  
  object@sim$iter <- length(samp)
  object@stan_args <- purrr::map(object@stan_args,.f=function(x,i){
    x$iter <- i
    x
  },i = object@sim$iter)
  
  object@inits <- purrr::map(object@inits,stan_trim_postwarm,idx=inits_x)
  object@sim$permutation <- purrr::map(object@sim$permutation,.f = function(y,idx) y[idx] , idx=inits_x)
  
  object@sim$samples <- purrr::map(object@sim$samples,stan_subset,idx=samp)
  object@sim$n_save <- rep(object@sim$iter,length(object@sim$n_save))
  
  object
  
}

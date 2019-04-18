#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param object PARAM_DESCRIPTION
#' @param ... PARAM_DESCRIPTION
#' @param inc_warmup PARAM_DESCRIPTION, Default: TRUE
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
#' @rdname stan_slice
#' @export 
#' @importFrom purrr map
stan_slice <- function(object,..., inc_warmup = TRUE){
  
  dots <- list(...)[[1]]
  
  if(inc_warmup){
    
    warm_x <- seq_len(object@sim$warmup)
    iter_x <- seq_len(object@sim$iter)[-warm_x]
    inits_x <- iter_x[dots] - length(warm_x)
    samp <- c(warm_x,iter_x[dots])
    object@sim$iter <- length(samp)
    
  }else{
    
    warm_x <- seq_len(object@sim$warmup)
    iter_x <- seq_len(object@sim$iter)[-warm_x]
    inits_x <- iter_x[dots] - length(warm_x)
    samp <- iter_x[dots]
    
    object@sim$iter <- length(samp)
    object@sim$warmup <- 0
    object@sim$warmup2 <- rep(object@sim$warmup,object@sim$chains)
  }
  
  
  object@stan_args <- purrr::map(object@stan_args,.f=function(x,i,inc_warmup){
    x$iter <- i
    
    if(!inc_warmup)
      x$warmup <- 0
    
    x
  },i = object@sim$iter,inc_warmup = inc_warmup)
  
  object@inits <- purrr::map(object@inits,stan_trim_postwarm,idx=inits_x)
  object@sim$permutation <- purrr::map(object@sim$permutation,.f = function(y,idx) y[idx] , idx=inits_x)
  
  object@sim$samples <- purrr::map(object@sim$samples,stan_subset,idx=samp)
  object@sim$n_save <- rep(object@sim$iter,length(object@sim$n_save))
  
  object
  
}

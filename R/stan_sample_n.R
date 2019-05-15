#' @title Sample n post-warumps samples from a stanfit object
#' @description This is a wrapper around sample.int() to make it easy to select
#'  random samples from each parameter in a stanfit object.
#' @param object stanfit object
#' @param size numeric, for [shredder][stan_sample_n] size of sample, for 
#'   [shredder][stan_frac] fraction of samples to sample.
#' @return stanfit
#' @examples 
#' set.seed(123)
#' 
#' rats <- rats_example()
#' 
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_sample_n(30)
#'   
#' @seealso 
#'  [map][purrr::map]
#' @rdname stan_sample
#' @family filtering
#' @export 
#' @importFrom purrr map
stan_sample_n <- function(object,size){
  
  check_stanfit(object)
  
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

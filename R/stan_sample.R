#' @title Sample n post-warumps samples from a stanfit object
#' @description This is a wrapper around sample() to make it easy to select
#'  random samples from each parameter in a stanfit object.
#' @param object stanfit object
#' @param size numeric, for [shredder][stan_sample_n] size of sample, for 
#'   [shredder][stan_sample_frac] fraction of samples to sample.
#' @param weight, a vector of probability weights for obtaining the elements of
#'  the vector being sampled.
#' @param inc_warmup logical, include warmup in output, Default: TRUE
#' @return stanfit
#' @examples 
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_sample_n(30)
#'   
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_sample_frac(0.5)
#'
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_sample_n(30,inc_warmup = FALSE)
#'
#' @rdname stan_sample
#' @family filtering
#' @export 
stan_sample_n <- function(object, size, weight = NULL, inc_warmup = TRUE){
  
  check_stanfit(object)
  object <- clear_summary(object)
  
  warm_x <- seq_len(object@sim$warmup)
  iter_x <- seq_len(object@sim$iter)[-warm_x]
  
  samp <- sample(iter_x,size = size, prob = weight)
  
  stan_sample(object, samp, warm_x, inc_warmup)
  
}

#' @rdname stan_sample
#' @export
stan_sample_frac <- function(object, size, weight = NULL, inc_warmup = TRUE){
  
  check_stanfit(object)
  object <- clear_summary(object)
  
  warm_x <- seq_len(object@sim$warmup)
  iter_x <- seq_len(object@sim$iter)[-warm_x]
  
  samp <- sample(iter_x, size = floor(size*length(iter_x)), prob = weight)
  
  stan_sample(object, samp, warm_x, inc_warmup)
  
}

#' @importFrom purrr map
stan_sample <- function(object, samp, warm_x, inc_warmup){
  
  inits_x <- samp - length(warm_x)
  
  object@sim$iter  <- length(samp)
  
  if(inc_warmup){
    
    samp    <- c(warm_x,samp)
    object@sim$iter <- length(samp)
    
  }else{
    
    object@sim$iter <- length(samp)
    object@sim$warmup <- 0
    object@sim$warmup2 <- rep(object@sim$warmup,object@sim$chains)
    
  }
  
  object@stan_args <- purrr::map(object@stan_args,
                                 .f=function(x,i,inc_warmup){
                                   x$iter <- i
                                   
                                   if(!inc_warmup)
                                     x$warmup <- 0
                                   
                                   x
                                   },
                                 i = object@sim$iter,
                                 inc_warmup = inc_warmup)
  
  object@inits           <- purrr::map(object@inits,stan_trim_postwarm,idx=inits_x)
  
  object <- reset_perm(object,inits_x)
  
  object@sim$samples     <- purrr::map(object@sim$samples,stan_subset,idx=samp)
  object@sim$n_save      <- rep(object@sim$iter,length(object@sim$n_save))
  
  object
  
}

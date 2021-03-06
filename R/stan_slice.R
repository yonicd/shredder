#' @title Choose post-warumps samples by position
#' @description Choose post-warumps samples by their ordinal 
#' position from each parameter in a stanfit object
#' @param object stanfit object
#' @param ... Integer samples values
#' @param inc_warmup logical, include warmup in output, Default: TRUE
#' @return stanfit object
#' @examples 
#' \donttest{
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_slice(1:30)
#' 
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_slice(1:30,inc_warmup = FALSE)
#' }
#' @rdname stan_slice
#' @family filtering
#' @export 
#' @importFrom purrr map
stan_slice <- function(object,..., inc_warmup = TRUE){
  UseMethod('stan_slice',object)
}

#' @export 
stan_slice.brmsfit <- function(object,..., inc_warmup = TRUE){
  object$fit <- stan_slice(object$fit,...,inc_warmup = inc_warmup)
  object
}

#' @export 
stan_slice.stanfit <- function(object,..., inc_warmup = TRUE){
  
  object <- clear_summary(object)
  
  dots_list <- list(...)
  
  if(!length(dots_list)){
    return(object)  
  }
  
  dots <- dots_list[[1]]
  
  warm_x <- seq_len(object@sim$warmup)
  iter_x <- seq_len(object@sim$iter)[-warm_x]
  inits_x <- iter_x[dots] - length(warm_x)
  
  check_dots <- which(length(iter_x)>=dots)
  
  if(length(check_dots)!=length(dots)){
    warning('some indicies not in sample indicies of object, truncating the intersection')
    dots <- dots[check_dots]
  }
  
  if(inc_warmup){

    samp <- c(warm_x,iter_x[dots])
    object@sim$iter <- length(samp)
    
  }else{
    
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
  
  object <- reset_perm(object,inits_x)

  object@sim$samples <- purrr::map(object@sim$samples,stan_subset,idx=samp)
  object@sim$n_save <- rep(object@sim$iter,length(object@sim$n_save))

  object
  
}


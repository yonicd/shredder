#' @title Return object with specific chains
#' @description Use stan_retain() to choose chains to retain.
#' @param object stanfit object
#' @param chains numeric, chains to retain, Default: 1
#' @return stanfit object
#' @examples 
#' \donttest{
#' rats <- rats_example(nCores = 1)
#' 
#' #retain first chain only
#' rats%>%
#'   stan_retain()
#'   
#' #retain chains 1 and 3
#' rats%>%
#'   stan_retain(c(1,3))
#'  }
#' @rdname stan_retain
#' @family utility
#' @export 
stan_retain <- function(object,chains = 1){
  UseMethod('stan_retain',object)
}

#' @export 
stan_retain.brmsfit <- function(object, chains = 1){
  object$fit <- stan_retain(object$fit, chains = chains)
  object
}

#' @export 
stan_retain.stanfit <- function(object, chains = 1){
  
  on.exit({clear_summary(object)},add = TRUE)

  if(is.null(chains))
    return(object)
    
  if(all(chain_ids(object) %in% chains))
    return(object)
  
  if(any(!(chains %in% chain_ids(object)))){
    stop(sprintf(
      'Invalid chains "%s", expected "%s"',
      paste0(chains,collapse = ', '), 
      paste0(chain_ids(object),collapse = ', ')
    ),
    call. = FALSE)
  }
    
  
  object@sim$samples <- object@sim$samples[chains]
  object@sim$chains <- length(chains)
  object@sim$n_save <- object@sim$n_save[chains]
  object@sim$warmup2 <- object@sim$warmup2[chains]
  object@sim$permutation <- object@sim$permutation[chains]
  object@inits <- object@inits[chains]
  object@stan_args <- object@stan_args[chains]
  
  object
}
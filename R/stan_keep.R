#' @title Return object with specific chains
#' @description Use stan_keep() to choose chainsto preserve.
#' @param object stanfit object
#' @param chains numeric, chains to keep, Default: 1
#' @return stanfit object
#' @examples 
#' rats <- rats_example(nCores = 1)
#' 
#' #keep first chain only
#' rats%>%
#'   stan_keep()
#'   
#' #keep chains 1 and 3
#' rats%>%
#'   stan_keep(c(1,3))
#'   
#' @rdname stan_keep
#' @family utility
#' @export 
stan_keep <- function(object,chains = 1){
  UseMethod('stan_keep',object)
}

#' @export 
stan_keep.brmsfit <- function(object, chains = 1){
  object$fit <- stan_keep(object$fit, chains = chains)
  object
}

#' @export 
stan_keep.stanfit <- function(object, chains = 1){
  
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
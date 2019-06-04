#' @title split stanfit object into smaller pieces
#' @description Split stanfit post-warmup samples into smaller objects to
#'   facilitate parallel post processing.
#' @param object stanfit
#' @param ncut numeric, number of smaller objects to create, Default: 10
#' @param inc_warmup logical, include warmup in the smaller objects, Default: TRUE
#' @return list of stanfits objects
#' @examples 
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%
#'   stan_split(ncut = 4)
#'   
#' rats%>%
#'   stan_split(ncut = 4,inc_warmup = FALSE)
#'
#' @seealso 
#'  [stan_slice][shredder::stan_slice]
#' @rdname stan_split
#' @family utility
#' @export 
#' @importFrom purrr map_dbl map
stan_split <- function(object, ncut = 10, inc_warmup = TRUE){
  UseMethod('stan_split',object)
}

#' @export  
stan_split.brmsfit <- function(object, ncut = 10, inc_warmup = TRUE){
  
  fit_list <- stan_split(object$fit, ncut = ncut, inc_warmup = inc_warmup)
  
  list_ret <- vector('list',length(fit_list))
  
  for(i in seq_along(list_ret)){
    list_ret[[i]] <- object
    list_ret[[i]]$fit <- fit_list[[i]]
  }
  
  list_ret
}

#' @export
stan_split.stanfit <- function(object, ncut = 10, inc_warmup = TRUE){
  
  N <- unique(purrr::map_dbl(object@stan_args,.f=function(x) x$iter - x$warmup))
  
  if(length(N)>1)
    stop('unequal post-warmup samples across chains not supported')
  
  bin_number <- sort(rep(1:ncut, each = N%/%ncut, length.out = N))
  
  purrr::map(split(1:N,bin_number),.f=function(this, x, inc_warmup) {
    stan_slice(object = this, x, inc_warmup = inc_warmup)
  },
  this = object,
  inc_warmup = inc_warmup
  )
  
}

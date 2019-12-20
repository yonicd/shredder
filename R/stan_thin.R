#' @title thin n post-warumps samples from a stanfit object
#' @description This is a wrapper around stan_slice() to make it easy to
#'  thin samples from each parameter in a stanfit object.
#' @param object stanfit object
#' @param size numeric, for [stan_thin_n][shredder::stan_thin_n] size of thin, for 
#'   [stan_thin_frac][shredder::stan_thin_frac] fraction of samples to sample.
#' @param inc_warmup logical, include warmup in output, Default: TRUE
#' @return stanfit
#' @examples 
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_thin_n(30)
#'   
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_thin_frac(0.5)
#'
#' rats%>%
#'   stan_select(mu_alpha)%>%
#'   stan_thin_n(30,inc_warmup = FALSE)
#'
#' @rdname stan_thin
#' @family filtering
#' @export 
stan_thin_n <- function(object, size, inc_warmup = TRUE){
  UseMethod('stan_thin_n',object)
}

#' @rdname stan_thin
#' @export 
stan_thin_frac <- function(object, size, inc_warmup = TRUE){
  UseMethod('stan_thin_frac',object)
}

#' @export 
stan_thin_n.brmsfit <- function(object, size, inc_warmup = TRUE){
  n_iter <- object$fit@sim$iter - object$fit@sim$warmup
  seq_ <- seq(1,object@sim$iter,by = size)
  stan_slice(object, seq_, inc_warmup = inc_warmup)
}

#' @export 
stan_thin_n.stanfit <- function(object, size, inc_warmup = TRUE){
  n_iter <- object@sim$iter - object@sim$warmup
  seq_ <- seq(1,n_iter,by = size)
  stan_slice(object, seq_, inc_warmup = inc_warmup)
}

#' @export 
stan_thin_frac.brmsfit <- function(object, size, inc_warmup = TRUE){
  n_iter <- object$fit@sim$iter - object$fit@sim$warmup
  seq_ <- floor(seq(1,n_iter,length.out = floor(n_iter*size)))
  stan_slice(object,seq_, inc_warmup = inc_warmup)
}

#' @export 
stan_thin_frac.stanfit <- function(object, size, inc_warmup = TRUE){
  n_iter <- object@sim$iter - object@sim$warmup
  seq_ <- floor(seq(1,n_iter,length.out = floor(n_iter*size)))
  stan_slice(object, seq_, inc_warmup = inc_warmup)
}
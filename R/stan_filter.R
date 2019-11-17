#' @title Return post-warmup samples with matching conditions
#' @description Use stan_filter() to choose indicies of samples across parameters 
#'   where conditions are true.
#' @param object stanfit object
#' @param \dots Logical predicates defined in terms of the parameters in object
#' @param chain numeric, chain to apply filter predicated on, Default: 1
#' @return stanfit object
#' @examples 
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%
#'   stan_select(mu_alpha,mu_beta)
#'   
#' rats%>%
#'   stan_select(mu_alpha,mu_beta)%>%
#'   stan_filter(mu_beta < 6)
#'   
#' @rdname stan_filter
#' @family filtering
#' @export 
#' @importFrom rlang quo_squash quo
#' @importFrom stringi stri_extract_all_regex
#' @importFrom purrr discard flatten_chr map_df map_dfc map
stan_filter <- function(object, ...,chain = 1){
  UseMethod('stan_filter',object)
}

#' @export   
stan_filter.brmsfit <- function(object, ...,chain = 1){
  object$fit <- stan_filter(object$fit,...,chain = chain)
  object
}

#' @export   
stan_filter.stanfit <- function(object, ...,chain = 1){
  
  on.exit({clear_summary(object)},add = TRUE)
  
  warm_x <- seq_len(object@sim$warmup)
  iter_x <- seq_len(object@sim$iter)[-warm_x]
  
  squish <- rlang::quo_squash(rlang::quo(...))
  
  idcs_fnames_oi <- stringi::stri_extract_all_regex(as.character(squish),pattern = '`(.*?)`')%>%
    purrr::discard(is.na)%>%
    purrr::flatten_chr()
  
  idcs_pars_oi <- intersect(as.character(squish),stan_names(object))
  
  idcs <- c(idcs_pars_oi,idcs_fnames_oi)
  
  if(!length(idcs)){
    stop('Invalid parameter names selected\nUse stan_names(object) to list parameter names',call. = FALSE)
  }
  
  if(!chain%in%chain_ids(object)){
    stop(sprintf(
      'Invalid chain number "%s", expected "%s"',
      chain, paste0(chain_ids(object),collapse = ', ')
      ),
      call. = FALSE)
  }
  
  samp_df <- purrr::map_df(object@sim$samples[chain],.f=function(x,idc,warm_x){
    ret <- purrr::map_dfc(x[gsub('`','',idc)],identity)
    ret$n_ <- 1:nrow(ret)
    ret <- ret[-warm_x,]
    ret <- ret%>%subset({eval(squish)})
    ret
  },idc=idcs,warm_x = warm_x)
  
  if(!length(samp_df$n_)){
    warning('Boolean returned no samples',call. = FALSE)
    return(object)
  }
  
  inits_x <- samp_df$n_ - length(warm_x)
  
  samp <- c(warm_x,samp_df$n_) 
  
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

# This breaks rstan::extract because of assumption of equal sized iterations 
# in chains in rstan summary method. 
# https://github.com/stan-dev/rstan/blob/develop/rstan/rstan/R/stanfit-class.R#L487
stan_filter_ <- function(object, ..., chains = NULL){
  
  chains_ <- seq_len(object@sim$chains)
  
  if(is.null(chains)){
    
    chains <- chains_
    
  }else{
    
    length(setdiff(chains,chains_)>0)
    stop('Invalid Chains Specified',call. = FALSE)
    
  }
  
  warm_x <- seq_len(object@sim$warmup)
  iter_x <- seq_len(object@sim$iter)[-warm_x]
  
  squish <- rlang::quo_squash(rlang::quo(...))
  
  idcs_fnames_oi <- stringi::stri_extract_all_regex(as.character(squish),pattern = '`(.*?)`')%>%
    purrr::discard(is.na)%>%
    purrr::flatten_chr()
  
  idcs_pars_oi <- intersect(as.character(squish),stan_names(object))
  
  idcs <- c(idcs_pars_oi,idcs_fnames_oi)
  
  if(!length(idcs)){
    stop('Invalid paratameter names selected\nUse stan_names(object) to list parameter names',call. = FALSE)
  }
  
  samp_df <- purrr::map_df(object@sim$samples[chains],
                           .f = function(X,idc, warm_x){
                             ret <- purrr::map_dfc(X[gsub('`','',idc)],identity)
                             ret$n_ <- 1:nrow(ret)
                             ret <- ret[-warm_x,]
                             ret <- ret%>%subset({eval(squish)})
                             ret
                           },idc=idcs,warm_x = warm_x,.id = 'chain')
  
  if(!length(samp_df$n_)){
    warning('Boolean returned no samples',call. = FALSE)
    return(object)
  }
  
  samp_df_chain <- split(samp_df, samp_df$chain)
  
  inits_x <- samp_df$n_ - length(warm_x)
  
  init_x_chain <- split(inits_x, samp_df$chain)
  
  n_chain <- split(samp_df$n_, samp_df$chain)
  
  samp_chain <- purrr::map(n_chain,.f = function(x,w) c(w,x), w = warm_x)
  
  iter_chain <- purrr::map(samp_chain,length)
  
  object@sim$iter <- length(warm_x) + length(unlist(n_chain))
  
  object@stan_args <- purrr::map2(object@stan_args,iter_chain,.f=function(x,i){
    x$iter <- i
    x
  })
  
  object@inits <- purrr::map2(object@inits,init_x_chain, stan_trim_postwarm)
  
  object@sim$permutation <- purrr::map2(object@sim$permutation,init_x_chain, .f = function(y,idx) y[idx])
  
  object@sim$samples <- purrr::map2(object@sim$samples,samp_chain,stan_subset)
  
  object@sim$n_save <- as.numeric(length(warm_x) + purrr::map_dbl(n_chain,length))
  
  object
  
}

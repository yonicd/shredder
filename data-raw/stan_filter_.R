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
    warning('filter returned no samples',call. = FALSE)
    return(object)
  }
  
  n_chain <- split(samp_df$n_, samp_df$chain)
  
  if(!identical(length(n_chain),length(shredder:::chain_ids(object)))){
    miss_id <- shredder:::chain_ids(object)[!shredder:::chain_ids(object)%in%as.numeric(names(n_chain))]

    warning(sprintf('filter returned no samples for chains: %s',
                    paste0(miss_id,collapse = ', ')
                    ),call. = FALSE)
    
    object <- stan_retain(object,as.numeric(names(n_chain)))
  }
    
  inits_x <- samp_df$n_ - length(warm_x)
  
  init_x_chain <- split(inits_x, samp_df$chain)
  
  init_x_chain <- purrr::modify(init_x_chain,.f=function(x,m){
    x[1:m]
  } , m = min(sapply(n_chain,length)))
  
  n_chain <- purrr::modify(n_chain,.f=function(x,m){
    x[1:m]
  } , m = min(sapply(n_chain,length)))
  
  samp_chain <- purrr::map(n_chain,.f = function(x,w) c(w,x), w = warm_x)
  
  iter_chain <- purrr::map(samp_chain,length)

  object@sim$iter <- unique(sapply(samp_chain,length))
  
  object@stan_args <- purrr::map2(object@stan_args,iter_chain,.f=function(x,i){
    x$iter <- i
    x
  })
  
  #object@inits <- purrr::map2(object@inits,init_x_chain, shredder:::stan_trim_postwarm)
  
  object@sim$permutation <- purrr::map2(object@sim$permutation,init_x_chain, .f = function(y,idx) y[idx])
  
  object@sim$samples <- purrr::map2(object@sim$samples,samp_chain,shredder:::stan_subset)
  
  #as.numeric(length(warm_x) + purrr::map_dbl(n_chain,length))
  object@sim$n_save <- as.numeric(iter_chain)
  
  object
  
}

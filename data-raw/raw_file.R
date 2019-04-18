stan_subset <- function(x,idx){
  x <- purrr::map(x,.f=function(y,idx) y[idx],idx=idx)
  
  obj <- attr(x,"sampler_params")
  sub_obj <- purrr::map(obj,.f=function(y,idx) y[idx],idx=idx)
  attr(x,"sampler_params") <- sub_obj
  
  
  
  x
  
}

stan_trim_postwarm <- function(x,idx){
  purrr::map(x,.f = function(y,idx) y[idx] , idx=idx)
}

stan_select <- function(object, ...){
  
  pars <- unlist(lapply(rlang::enquos(...),rlang::quo_text))
  
  object@sim$pars_oi <- intersect(object@sim$pars_oi,pars)
  object@sim$dims_oi <- object@sim$dims_oi[object@sim$pars_oi]
  object@sim$fnames_oi <- grep(sprintf('^(%s)',paste0(pars,collapse = '|')),object@sim$fnames_oi,value = TRUE)
  object@sim$n_flatnames <- length(object@sim$fnames_oi)
  
  object@inits <- purrr::map(object@inits,.f=function(x,y) x[y], y = pars)
  
  object@model_pars <- intersect(object@model_pars,pars)
  object@par_dims <- object@par_dims[pars]
  
  this <- grep(paste0(pars,collapse = '|'),object@sim$fnames_oi,value = TRUE)
  
  new_samples <- purrr::map(object@sim$samples,.f=function(x,y) x[y], y = this)
  
  for(i in seq_len(length(new_samples)))
    attr(new_samples[[i]],'sampler_params') <- attr(object@sim$samples[[i]],'sampler_params')
  
  object@sim$samples <- new_samples
  
  if(exists('summary',envir = object@.MISC))
    rm(list = 'summary',envir = object@.MISC)
  
  object
  
}

stan_split <- function(object, ncut = 10, inc_warmup = TRUE){
  
  N <- unique(purrr::map_dbl(object@stan_args,.f=function(x) x$iter - x$warmup))
  
  if(length(N)>1)
    stop('unequal post-warmup samples across chains not supported')
  
  bin_number <- sort(rep(1:ncut, each = N%/%ncut, length.out = N))
  
  purrr::map(split(1:N,bin_number),.f=function(obj, x, inc_warmup) {
    stan_slice(obj = object, x, inc_warmup = inc_warmup)
  },
  obj = object,
  inc_warmup = inc_warmup
  )
  
}

stan_slice <- function(object,..., inc_warmup = TRUE){
  
  dots <- list(...)[[1]]
  
  if(inc_warmup){
    
    warm_x <- seq_len(object@sim$warmup)
    iter_x <- seq_len(object@sim$iter)[-warm_x]
    inits_x <- iter_x[dots] - length(warm_x)
    samp <- c(warm_x,iter_x[dots])
    object@sim$iter <- length(samp)
    
  }else{
    
    warm_x <- seq_len(object@sim$warmup)
    iter_x <- seq_len(object@sim$iter)[-warm_x]
    inits_x <- iter_x[dots] - length(warm_x)
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
  object@sim$permutation <- purrr::map(object@sim$permutation,.f = function(y,idx) y[idx] , idx=inits_x)
  
  object@sim$samples <- purrr::map(object@sim$samples,stan_subset,idx=samp)
  object@sim$n_save <- rep(object@sim$iter,length(object@sim$n_save))
  
  object
  
}

stan_sample_n <- function(object,size){
  
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

stan_sample_frac <- function(object,size){
  
  warm_x <- seq_len(object@sim$warmup)
  iter_x <- seq_len(object@sim$iter)[-warm_x]
  
  samp <- sample(iter_x,size=floor(size*length(iter_x)))
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

stan_filter <- function(object, ...,chain = 1){
  
  warm_x <- seq_len(object@sim$warmup)
  iter_x <- seq_len(object@sim$iter)[-warm_x]
  
  squish <- rlang::quo_squash(rlang::quo(...))
  
  idcs <- stringi::stri_extract_all_regex(as.character(squish),pattern = '`(.*?)`')%>%
    purrr::discard(is.na)%>%
    purrr::flatten_chr()
  
  samp_df <- purrr::map_df(object@sim$samples[chain],.f=function(x,idc,warm_x){
    ret <- purrr::map_dfc(x[gsub('`','',idc)],identity)
    ret$n_ <- 1:nrow(ret)
    ret <- ret[-warm_x,]
    ret <- ret%>%subset({eval(squish)})
    ret
  },idc=idcs,warm_x = warm_x)
  
  if(!length(samp_df$n_))
    return(message('Boolean returned no samples'))
  
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
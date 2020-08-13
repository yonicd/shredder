#' @title Return post-warmup samples with matching conditions
#' @description Use stan_filter() to choose indicies of samples across parameters 
#'   where conditions are true.
#' @param object stanfit object
#' @param \dots Logical predicates defined in terms of the parameters in object
#' @param permuted A logical scalar indicating whether the draws after the warmup 
#' period in each chain should be permuted and merged, Default: TRUE
#' @return stanfit object
#' @details 
#' 
#' - If no elements are returned for any chain then `NULL` is returned with a warning.
#' - If there is a chain that results in no samples then the chain is dropped with a warning.
#' - If permuted is FALSE then uneven chains may be returned depending on the result of the filter.
#' - To comply with [extract][rstan::extract] with `permuted=TRUE` chains in which chaines are 
#' assumed to be of equal size. 
#'   - Chain size returned is the length of the shortest filtered chain. 
#' 
#' @examples 
#' \donttest{
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%
#'   stan_select(mu_alpha,mu_beta)
#'   
#' rats%>%
#'   stan_select(mu_alpha,mu_beta)%>%
#'   stan_filter(mu_beta < 6)
#'   
#' rats%>%
#'   stan_select(mu_alpha,mu_beta)%>%
#'   stan_filter(mu_beta < 6, permuted = FALSE)
#'   
#' rats%>%
#'  stan_select(`alpha[1]`,`alpha[2]`,mu_alpha,mu_beta)%>%
#'  stan_filter(mu_beta < 6 & `alpha[1]` > 240)
#' }
#' @rdname stan_filter
#' @family filtering
#' @export 
#' @importFrom rlang quo_squash quo
#' @importFrom stringi stri_extract_all_regex
#' @importFrom purrr map_df map_dfc modify map map2
stan_filter <- function(object, ..., permuted = TRUE){
  UseMethod('stan_filter',object)
}

#' @export   
stan_filter.brmsfit <- function(object, ..., permuted = TRUE){
  object$fit <- stan_filter(object$fit,..., permuted = permuted)
  object
}

#' @export   
stan_filter.stanfit <- function(object, ..., permuted = TRUE){
  
  on.exit({clear_summary(object)},add = TRUE)

    warm_x <- seq_len(object@sim$warmup)
    iter_x <- seq_len(object@sim$iter)[-warm_x]
    
    squish <- rlang::quo_squash(rlang::quo(...))
    squish_chr <- as.character(squish)
    squish_chr <- gsub('[`]','',squish_chr)
    
    model_names <- paste0(pars_regex(stan_names(object,expand = TRUE)),collapse = '|')
    
    idcs <- stringi::stri_extract_all_regex(squish_chr,model_names)
    idcs <- unique(unlist(idcs))
    idcs <- idcs[!is.na(idcs)]

    if(!length(idcs)){
      stop('Invalid parameter names selected\nUse stan_names(object) to list parameter names',call. = FALSE)
    }
    
    samp_df <- purrr::map_df(object@sim$samples,
                             .f = function(X,idc, warm_x){
                               ret <- purrr::map_dfc(X[gsub('`','',idc)],identity)
                               ret$n_ <- 1:nrow(ret)
                               ret <- ret[-warm_x,]
                               ret <- subset(ret,{eval(squish)})
                               ret
                             },idc=idcs,warm_x = warm_x,.id = 'chain')
    
    
    if(!length(samp_df$n_)){
      warning('filter returned no samples',call. = FALSE)
      return(NULL)
    }
    
    n_chain <- split(samp_df$n_, samp_df$chain)

    if(!identical(length(n_chain),length(chain_ids(object)))){
      
        miss_id <- chain_ids(object)[!chain_ids(object)%in%as.numeric(names(n_chain))]
        
        warning(sprintf('filter returned no samples for chains: %s',
                        paste0(miss_id,collapse = ', ')
        ),call. = FALSE)
        
        object <- stan_retain(object,as.numeric(names(n_chain)))
    }

    inits_x <- samp_df$n_ - length(warm_x)
    
    init_x_chain <- split(inits_x, samp_df$chain)
    
    if(permuted){
      
      init_x_chain <- purrr::modify(init_x_chain,.f=function(x,m){
        x[1:m]
      } , m = min(sapply(n_chain,length)))      
  
      n_chain <- purrr::modify(n_chain,.f=function(x,m){
        x[1:m]
      } , m = min(sapply(n_chain,length)))
          
    }

    samp_chain <- purrr::map(n_chain,.f = function(x,w) c(w,x), w = warm_x)
    
    iter_chain <- purrr::map(samp_chain,length)
    
    object@sim$iter <- length(warm_x) + mean(sapply(init_x_chain,length))

    object@stan_args <- purrr::map2(object@stan_args,iter_chain,.f=function(x,i){
      x$iter <- i
      x
    })
    
    object@sim$permutation <- purrr::map2(object@sim$permutation,init_x_chain, .f = function(y,idx) y[idx])
    
    object@sim$samples <- purrr::map2(object@sim$samples,samp_chain,stan_subset)
    
    object@sim$n_save <- as.numeric(iter_chain)
    
    object
    
  }

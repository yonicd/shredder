#' @title Select parameters by name
#' @description Choose variables from a stanfit object
#' @param object a stanfit object
#' @param ... One or more unquoted expressions separated by commas
#' @return stanfit object
#' @examples 
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%stan_select(mu_beta)
#' 
#' rats%>%stan_select(mu_beta,beta)
#' 
#' rats%>%stan_select(!!!rlang::syms(c('mu_beta','mu_alpha')))
#' 
#' @seealso 
#' [quotation][rlang::quotation], [quo_label][rlang::quo_label], [map][purrr::map]
#' @rdname stan_select
#' @family subsetting
#' @export 
#' @importFrom rlang enquos quo_text eval_tidy
#' @importFrom purrr map
stan_select <- function(object, ...){
  
  check_stanfit(object)
  
  all_pars <- union(object@sim$pars_oi,object@sim$fnames_oi)
  
  assign('pars',all_pars,envir = pars_env)
  
  pars <- unlist(lapply(rlang::enquos(...),{
    FUN = function(x,data){
      
      ret <- rlang::quo_text(x)

      if(grepl('(stan_contains|stan_starts_with|stan_ends_with)',ret)){
        ret <- rlang::eval_tidy(x)
      }

      # remove back ticks from templates of "`par[index]`" to be "par[index]"
      # this is needed for quot_text output
      if(grepl('(?=.*`)(?=.*\\[(.*?)\\])','`alpha[1]`',perl = TRUE)){
        ret <- gsub('`','',ret)
      }
      
      ret
    }
  })
  )
  
  if(!length(pars))
    return(message('no pars selected'))
  
  pars <- unique(pars)
  
  fnames_object <- find_fnames(object,pars)
  
  object <- fnames_object$object
  pars <- fnames_object$pars
  
  object@sim$pars_oi <- intersect(object@sim$pars_oi,pars)
  object@sim$dims_oi <- object@sim$dims_oi[object@sim$pars_oi]
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

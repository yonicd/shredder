#' @importFrom purrr map
stan_subset <- function(x,idx){
  
  x <- purrr::map(x,.f=function(y,idx) y[idx],idx=idx)
  
  obj <- attr(x,"sampler_params")
  sub_obj <- purrr::map(obj,.f=function(y,idx) y[idx],idx=idx)
  attr(x,"sampler_params") <- sub_obj

  x
  
}

#' @importFrom purrr map
stan_trim_postwarm <- function(x,idx){
  
  purrr::map(x,.f = function(y,idx) y[idx] , idx = idx)
  
}

#' @title The Par Names of a Stanfit Object
#' @description Functions to get the names of a stanfit object.
#' @param x a stanfit object
#' @param expand logical, if TRUE par names are returned including dimesnion 
#'   indicies (fnames_oi), Default: FALSE
#' @examples 
#' rats <- rats_example(nCores = 1)
#' 
#' rats%>%stan_names()
#' 
#' rats%>%stan_names(expand = TRUE)
#' 
#' @return character
#' @rdname stan_names
#' @family utility
#' @export 
stan_names <- function(x,expand = FALSE){
  UseMethod('stan_names',x)
}

#' @export 
stan_names.brmsfit <- function(x,expand = FALSE){
  stan_names(x$fit,expand=expand)
}

#' @export 
stan_names.stanfit <- function(x,expand = FALSE){
  
  if(expand){
    
    x@sim$fnames_oi
    
  }else{
    
    x@sim$pars_oi
    
  }
}

clear_summary <- function(object){
  
  if(exists('summary',envir = object@`.MISC`))
    rm('summary',envir = object@`.MISC`)
  
  object
}

#' @importFrom purrr rerun
reset_perm <- function(object,inits_x){
  nx <- length(inits_x)
  nc <- length(object@sim$permutation)
  object@sim$permutation <- purrr::rerun(nc,sample(seq_len(nx),size = nx))
  object
}

find_fnames <- function(object,pars){
  
  f_names <- intersect(object@sim$fnames_oi,grep('\\[',pars,value = TRUE))
  
  if(length(f_names)){
    
    oi_names     <- unique(gsub('\\[(.*?)$','',f_names))
    pars         <- union(setdiff(pars,f_names),oi_names)
    
    f_names_keep <- grep_ext(pars,object@sim$fnames_oi,value = TRUE)
    f_names_l    <- grepl_ext(oi_names,f_names_keep)
      
    object@sim$fnames_oi <- c(intersect(f_names_keep[f_names_l],f_names),
                              f_names_keep[!f_names_l])
    
    for(nm in oi_names){
      object@sim$dims_oi[nm] <- length(grep(nm,f_names))
      object@par_dims[nm]    <- object@sim$dims_oi[nm]
    }
    
    
  }else{
    
    object@sim$fnames_oi <- grep(sprintf('^(%s)',paste0(pars,collapse = '|')),object@sim$fnames_oi,value = TRUE)
    
  }
  
  list(object = object, pars = pars)
}

grep_ext <- function(pattern,x,...){
  grep(sprintf('^(%s)',paste0(sprintf('\\b%s\\b',pattern),collapse = '|')),x = x,...)
}

grepl_ext <- function(pattern,x,...){
  grepl(sprintf('^(%s)',paste0(sprintf('\\b%s\\b',pattern),collapse = '|')),x = x,...)
}

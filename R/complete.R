#borrowed main bits from https://github.com/jimhester/completeme (when it is put on CRAN will import directly from it)

the <- new.env(parent = emptyenv())
the$completions <- list()
complete_token <- get(".completeToken", asNamespace("utils"))

# Register completion functions
#
# Completion functions should take one parameter `env`, the completion
# environment, see `?rc.settings` for details of this environment. They should
# simply return any completions found or `return(NULL)` otherwise.
#
# If all registered completions do not have any completions for a given
# context, than R's standard completions are used.
# @param ... One or more completion functions specified as named parameters.
#' @importFrom utils modifyList
register_completion <- function(...) {
  funs <- list(...)
  
  nms <- names(funs)
  if (is.null(nms) || any(nms == "" | is.na(nms))) {
    wch <- if (is.null(nms)) 1 else which(nms == "" | is.na(nms))
    stop("All arguments must be named")
  }
  
  old <- the$completions
  the$completions <- utils::modifyList(the$completions, funs)
  
  invisible(old)
}

#' @importFrom utils rc.options
completeme <- function(env) {
  env$fileName <- FALSE
  for (fun in the$completions) {
    env$comps <- fun(env)
    if (length(env$comps) > 0) {
      attributes(env$comps) <- list(class = "completions", type = 15)
      # this_type <- attr(env$comps, "type") %||% 15
      return(invisible(env$comps))
    }
  }
  
  env$comps <- character()
  
  # if in the IDE, throw an error to fallback on normal completion
  if (identical(.Platform$GUI, "RStudio")) {
    stop("No custom completions")
  }
  
  # If on the command line, fall back to using the default completer
  on.exit(rc.options(custom.completer = completeme))
  rc.options(custom.completer = NULL)
  complete_token()
  
  invisible(env$comps)
}

#' @importFrom rematch2 re_match
current_function <- function(env) {
  buffer <- env[["linebuffer"]]
  fun <- rematch2::re_match(buffer, "(?<fun>[^[:space:](]+)[(][^(]*$")$fun
  if (is.na(fun)) {
    return("")
  }
  fun
}

populate <- function(env){
  
  fun <- current_function(env)
  
  this_ns <- find_the()
  
  comp <- NULL
  
  if(this_ns=='shredder'){
    
    
    if(grepl('%>%',fun)){
      fun1 <- strsplit(fun,'%>%')[[1]]
      
      comp <- names(formals(fun1[length(fun1)]))      
    }

    if(grepl('stan_select$',fun)){

      object <- get(gsub('%>%(.*?)$','',fun),envir = globalenv())
      
      if(check_stanfit(object)){
        
        comp <- union(object@sim$pars_oi,object@sim$fnames_oi)
        
        assign('pars',comp,envir = pars_env)  
        
      }
      
    }
    
  }
  
  return(comp)
  
}

find_the <- function(){
  names(which(sapply(loadedNamespaces(),function(x) any(grepl('^the$',ls(envir = asNamespace(x)))))))
}

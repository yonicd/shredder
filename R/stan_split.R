#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param object PARAM_DESCRIPTION
#' @param ncut PARAM_DESCRIPTION, Default: 10
#' @param inc_warmup PARAM_DESCRIPTION, Default: TRUE
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[purrr]{map}}
#' @rdname stan_split
#' @export 
#' @importFrom purrr map_dbl map
stan_split <- function(object, ncut = 10, inc_warmup = TRUE){
  
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

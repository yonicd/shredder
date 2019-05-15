#' @title Rats model
#' @description Run Rats data model
#' @return stanfit object
#' @examples 
#' set.seed(123)
#' rats <- rats_example()
#' rats
#' @seealso 
#'  [stan][rstan::stan]
#'  [detectCores][parallel::detectCores]
#' @rdname rats_example
#' @family examples
#' @export 
#' @importFrom rstan stan
#' @importFrom parallel detectCores
rats_example <- function(){
  
  if(exists('rats',envir = example_env))
    return(get('rats',envir = example_env))
  
  attachNamespace('rstan')
  
  days <- as.numeric(regmatches(colnames(rat_raw), regexpr("[0-9]*$", colnames(rat_raw))))
  
  rat_data <- list(N = nrow(rat_raw), T = ncol(rat_raw), x = days,y = rat_raw, xbar = median(days))   
  
  ret <- rstan::stan(file = system.file('rats.stan',package='shredder'),
                     data = rat_data,cores = pmin(parallel::detectCores(),4))  
  
  assign('rats',ret,envir = example_env)
  
  ret
  
}

example_env <- new.env()
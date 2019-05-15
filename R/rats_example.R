#' @title Rats model
#' @description Run Rats data model
#' @param seed numeric, seed for [rstan][rstan::stan], Default: 123
#' @return stanfit object
#' @examples 
#' rats <- rats_example()
#' rats
#' @seealso 
#'  [rstan][rstan::stan]
#'  [detectCores][parallel::detectCores]
#' @rdname rats_example
#' @family examples
#' @source [Data Description](https://www.mrc-bsu.cam.ac.uk/wp-content/uploads/WinBUGS_Vol1.pdf), 
#'   [Data and Script](https://github.com/stan-dev/example-models/tree/master/bugs_examples/vol1/rats)
#' @export 
#' @importFrom rstan stan
#' @importFrom parallel detectCores
rats_example <- function(seed=123){
  
  if(exists('rats',envir = example_env)){
    if(exists('seed',envir = example_env)){
      if(seed==get('seed',envir = example_env)){
        return(get('rats',envir = example_env))
      }
    }
  }

  if(!('package:rstan' %in% search()))
    attachNamespace('rstan')
  
  ret <- rstan::stan(
    file  = system.file('rats.stan',package='shredder'),
    data  = rat_data,
    cores = pmin(parallel::detectCores(),4),
    seed  = seed
  )
  
  assign('rats',ret,envir = example_env)
  assign('seed',seed,envir = example_env)
  
  ret
  
}

example_env <- new.env()
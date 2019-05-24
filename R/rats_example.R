#' @title Rats model
#' @description Run Rats data model
#' @param seed numeric, seed for [rstan][rstan::stan], Default: 123
#' @param nCores numeric, Maximum number of cores to use, Default: pmin(parallel::detectCores(),4)
#' @return stanfit object
#' @examples 
#'   library(shredder)
#'   rats <- rats_example(nCores = 1)
#'   rats
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
rats_example <- function(seed=123, nCores = pmin(parallel::detectCores(),4)){

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
    cores = nCores,
    seed  = seed
  )
  
  assign('rats',ret,envir = example_env)
  assign('seed',seed,envir = example_env)
  
  ret
  
}

example_env <- new.env()

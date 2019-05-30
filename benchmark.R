# Load Libraries ----

library(tidybayes)
library(future)
library(furrr)
library(shredder)
library(tictoc)
library(aws.s3)

# the stanfit object is accessed via the {aws.S3} package
# assuming you have read access credentials set them using Sys.getenv

# Sys.setenv(
#   'AWS_ACCESS_KEY_ID' = 'XXX',
#   'AWS_SECRET_ACCESS_KEY' = 'XXX',
#   'AWS_DEFAULT_REGION' = 'us-east-1'
#   )

# Setup SGE ----

sge_libpath <- function(...){
  libdir <- c(...)
  .libPaths(c(libdir, .libPaths()))
  Sys.setenv(R_LIBS = paste(libdir, Sys.getenv("R_LIBS"), sep=.Platform$path.sep))
}

sge_libpath('lib')

sge <- future::tweak(
  future.batchtools::batchtools_sge,
  label = 'test',
  template = 'batchtools.sge-mrg.tmpl'
)

future::availableCores()
# system 
# 8 

## Helper fn to extract stanfit dim info

stan_size <- function(fit,label = 'object') tibble::tibble(object = label, size = format(object.size(fit),units = 'auto'))

stan_dims <- function(fit){
  
  # expected output dim
  ## rows
  nr <- fit@par_dims[[1]]*(fit@sim$n_save[1] - fit@sim$warmup)*fit@sim$chains
  
  #columns
  # .chain .iteration .draw par_index (always part of the output)
  nc <- 4 + length(fit@par_dims)
  
  #total rectangle size after using tidybayes::spread_draws
  total <- nr*nc
  
  c(nrows = nr, ncols = nc, total = total)
  
}

# Read STANFIT Object ----

# general locations on S3
bucket <- 'metrumrg-sandbox'
root_aws <- 'yonis/mer0501'

obj_name <- 'yonis/mer0501/stage2/data/joint_model_invariant_base_max.Rds'
tf <- tempfile(fileext = '.Rds')
aws.s3::save_object(obj_name, file = tf, bucket = bucket)

fit <- readRDS(tf)

## stanfit object characteristics

#chains
fit@sim$chains
# [1] 4

#post warmup samples
fit@sim$n_save - fit@sim$warmup
# [1] 1000 1000 1000 1000

## Subset the medium example ----

fit_medium <- fit%>%
  stan_select(log_kg,log_kd)

fit_medium%>%stan_dims()
#   nrows    ncols    total 
# 2332000        6 13992000 

# split the fit into smaller elements
fit_medium_list <- fit_medium%>%
  stan_split(inc_warmup = FALSE,ncut = 32)

fit_medium_list[[1]]%>%stan_dims()
# nrows  ncols  total 
# 90948      6 545688

## Subset the larger example ----

fit_large <- fit%>%
  stan_select(y_hat,sd_y)
  
fit_large%>%stan_dims()
# nrows     ncols     total 
# 56260000         6 337560000

# that is too big for tidy to handle in memory on the master, we will take a smaller sample to test on

fit_large_sample <- fit_large%>%
  stan_sample_n(96)

fit_large_sample%>%stan_dims()
# nrows    ncols    total 
# 5400960        6 32405760 

fit_large_list <- fit_large_sample%>%
  stan_split(inc_warmup = FALSE,ncut = 32)

fit_large_list[[1]]%>%stan_dims()
# nrows   ncols   total 
# 168780       6 1012680 


# size of all the objects

list('original'             = fit,
     'medium'               = fit_medium,
     'medium element'       = fit_medium_list[[1]],
     'large'                = fit_large,
     'large sample'         = fit_large_sample,
     'large sample element' = fit_large_list[[1]])%>%
  purrr::imap_dfr(stan_size)

# A tibble: 6 x 2
# object               size    
# <chr>                <chr>   
# 1 original             3.5 Gb  
# 2 medium               54.7 Mb 
# 3 medium element       2.4 Mb  
# 4 large                1.3 Gb  
# 5 large sample         527.7 Mb
# 6 large sample element 19.5 Mb

tic.clearlog()

#medium size times ----

## MASTER SINGLE CORE

tic(msg = 'master single object')
  obj <- fit_medium_list%>%
    tidybayes::spread_draws(log_kg[i],log_kd[i])
toc(log = TRUE,quiet = TRUE)

## MASTER SINGLE CORE MAP

tic(msg = 'master list')
  obj1 <- fit_medium_list%>%
    purrr::map_df(.f=function(x){
      x%>%tidybayes::spread_draws(log_kg[i],log_kd[i])
    },.id='chunk')
toc(log = TRUE,quiet = TRUE)

## MASTER MULTICORE MAP

mp <- future::tweak(future::multiprocess,gc = TRUE)

future::plan(mp)

tic(msg = 'master multicore list')
  obj2 <- fit_medium_list%>%
    furrr::future_map_dfr(.f=function(x){
      x%>%tidybayes::spread_draws(log_kg[i],log_kd[i])
    },.id='chunk')
toc(log = TRUE,quiet = TRUE)

## SGE
# reserving 4 workers of 8 cores each

future::plan(list(mp,sge))

tic(msg = 'sge list')

  obj_out <- future::future({
      furrr::future_map_dfr(fit_medium_list,.f=function(x){
        x%>%tidybayes::spread_draws(log_kg[i],log_kd[i])
      },.id='chunk')  
    })
    
  f <- future::futureOf(obj_out)
  
  while(!future::resolved(f)){
    Sys.sleep(0.1)
  }
  
  obj3 <- future::value(obj_out)

toc(log = TRUE,quiet = TRUE)

medium.log <- tic.log()

## RESULTS

# > medium.log
# [[1]]
# [1] "master single object: 24.195 sec elapsed"
# 
# [[2]]
# [1] "master list: 32.697 sec elapsed"
# 
# [[3]]
# [1] "master multicore list: 29.131 sec elapsed"
# 
# [[4]]
# [1] "sge list: 74.845 sec elapsed"

#large size times ----

# this {future} constraint can be worked around, it doesnt matter for this example
options('future.globals.maxSize'=700000000)

## MASTER SINGLE CORE
# not run on the single core
# tic(msg = 'master single object')
#   obj <- fit_large_sample%>%
#     tidybayes::spread_draws(y_hat[i],sd_y[i])
# toc(log = TRUE,quiet = TRUE)

## MASTER SINGLE CORE MAP
# not run on the single core
# tic(msg = 'master list')
#   obj1 <- fit_large_list%>%
#     purrr::map_df(.f=function(x){
#       x%>%tidybayes::spread_draws(y_hat[i],sd_y[i])
#     },.id='chunk')
# toc(log = TRUE,quiet = TRUE)

## MASTER MULTICORE MAP

mp <- future::tweak(future::multiprocess,gc = TRUE)

future::plan(mp)

tic(msg = 'master multicore list')
  obj2 <- fit_large_list%>%
    furrr::future_map_dfr(.f=function(x){
      x%>%tidybayes::spread_draws(y_hat[i],sd_y[i])
    },.id='chunk')
toc(log = TRUE,quiet = TRUE)

## SGE
# reserving 4 workers of 8 cores each

future::plan(list(mp,sge))

tic(msg = 'sge list')

  obj_out <- future::future({
    furrr::future_map_dfr(fit_large_list,.f=function(x){
      x%>%tidybayes::spread_draws(y_hat[i],sd_y[i])
    },.id='chunk')  
  })
  
  f <- future::futureOf(obj_out)
  
  while(!future::resolved(f)){
    Sys.sleep(0.1)
  }
  
  obj3 <- future::value(obj_out)

toc(log = TRUE,quiet = TRUE)

large.log <- tic.log()

## RESULTS

# > large.log
# [[1]]
# [1] "master multicore list: 928.541 sec elapsed"
#
# [[2]]
# [1] "sge list: 595.374 sec elapsed"

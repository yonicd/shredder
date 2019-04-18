
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shredder

<!-- badges: start -->

<!-- badges: end -->

The goal of shredder is to apply tidylike verbs to rstan simulation
objects. The usage is similar to the `dplyr` verbs, the input is a
stanfit object and the output is a manipulated stanfit object.

## Installation

You can install shredder from `GHE` with:

``` r
remotes::install_github(
  repo = 'internal-projects/shredder',
  host = 'ghe.metrumrg.com/api/v3',
  auth_token = Sys.getenv('GHE_PAT')
)
```

## Verbs

  - Dimension
      - pars:
          - `stan_select` : extract specific pars
      - post-warmup samples
          - `stan_slice` : extract specific samples by index
          - `stan_sample_n` : extract random n samples
          - `stan_frac_n` : extract fraction of total samples
          - `stan_filter` : extract subset of samples conditional on
            filter of parameter values
          - `stan_split` : create a list with ncut slices of the samples

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(shredder)
library(rstan)
#> Loading required package: ggplot2
#> Loading required package: StanHeaders
#> Warning: package 'StanHeaders' was built under R version 3.5.2
#> rstan (Version 2.18.2, GitRev: 2e1f913d3ca3)
#> For execution on a local, multicore CPU with excess RAM we recommend calling
#> options(mc.cores = parallel::detectCores()).
#> To avoid recompilation of unchanged Stan programs, we recommend calling
#> rstan_options(auto_write = TRUE)

objsize <- function(x) sprintf('Object Size: %s',format(object.size(x),units = 'auto'))
```

``` r

excode <- '
  transformed data {
    real y[20];
    y[1] = 0.5796;  y[2] = 0.2276;   y[3]  = -0.2959; 
    y[4] = -0.3742; y[5] = 0.3885;   y[6]  = -2.1585;
    y[7] = 0.7111;  y[8] = 1.4424;   y[9]  = 2.5430; 
    y[10] = 0.3746; y[11] = 0.4773;  y[12] = 0.1803; 
    y[13] = 0.5215; y[14] = -1.6044; y[15] = -0.6703; 
    y[16] = 0.9459; y[17] = -0.382;  y[18] = 0.7619;
    y[19] = 0.1006; y[20] = -1.7461;
  }
  parameters {
    real mu;
    real<lower=0, upper=10> sigma;
    vector[2] z[3];
    real<lower=0> alpha;
  } 
  model {
    y ~ normal(mu, sigma);
    for (i in 1:3) 
      z[i] ~ normal(0, 1);
    alpha ~ exponential(2);
  } 
'
```

``` r
fit <- stan(model_code = excode, iter = 500, verbose = FALSE)
```

``` r
objsize(fit)
#> [1] "Object Size: 348.7 Kb"

fit
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=500; warmup=250; thin=1; 
#> post-warmup draws per chain=250, total post-warmup draws=1000.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.09    0.01 0.28  -0.50  -0.08   0.10   0.28   0.61  1282 1.00
#> sigma    1.17    0.01 0.20   0.85   1.03   1.14   1.28   1.66  1297 1.00
#> z[1,1]   0.00    0.02 1.03  -2.02  -0.70   0.03   0.71   2.04  1905 1.00
#> z[1,2]  -0.02    0.02 1.00  -2.09  -0.66  -0.04   0.63   1.98  1620 1.00
#> z[2,1]  -0.02    0.03 0.96  -1.90  -0.68  -0.03   0.70   1.78  1387 1.00
#> z[2,2]   0.02    0.03 1.01  -1.98  -0.66   0.03   0.70   1.98  1600 1.00
#> z[3,1]   0.01    0.02 0.99  -1.90  -0.65   0.01   0.67   1.94  2381 1.00
#> z[3,2]  -0.01    0.02 1.00  -1.98  -0.73  -0.02   0.66   2.02  1639 1.00
#> alpha    0.52    0.02 0.54   0.01   0.14   0.36   0.71   1.90  1137 1.00
#> lp__   -17.69    0.10 2.12 -22.82 -18.87 -17.39 -16.16 -14.49   416 1.01
#> 
#> Samples were drawn using NUTS(diag_e) at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

``` r
fit1 <- fit%>%
  stan_select(mu)

objsize(fit1)
#> [1] "Object Size: 173.6 Kb"

fit1
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=500; warmup=250; thin=1; 
#> post-warmup draws per chain=250, total post-warmup draws=1000.
#> 
#>    mean se_mean   sd 2.5%   25% 50%  75% 97.5% n_eff Rhat
#> mu 0.09    0.01 0.28 -0.5 -0.08 0.1 0.28  0.61  1282    1
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).

fit2 <- fit%>%
  stan_select(mu,sigma)

objsize(fit2)
#> [1] "Object Size: 190.6 Kb"

fit2
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=500; warmup=250; thin=1; 
#> post-warmup draws per chain=250, total post-warmup draws=1000.
#> 
#>       mean se_mean   sd  2.5%   25%  50%  75% 97.5% n_eff Rhat
#> mu    0.09    0.01 0.28 -0.50 -0.08 0.10 0.28  0.61  1282    1
#> sigma 1.17    0.01 0.20  0.85  1.03 1.14 1.28  1.66  1297    1
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).

fit3 <- fit%>%
  stan_select(!!!rlang::syms(c('z','alpha')))

objsize(fit3)
#> [1] "Object Size: 272.3 Kb"

fit3
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=500; warmup=250; thin=1; 
#> post-warmup draws per chain=250, total post-warmup draws=1000.
#> 
#>         mean se_mean   sd  2.5%   25%   50%  75% 97.5% n_eff Rhat
#> z[1,1]  0.00    0.02 1.03 -2.02 -0.70  0.03 0.71  2.04  1905    1
#> z[1,2] -0.02    0.02 1.00 -2.09 -0.66 -0.04 0.63  1.98  1620    1
#> z[2,1] -0.02    0.03 0.96 -1.90 -0.68 -0.03 0.70  1.78  1387    1
#> z[2,2]  0.02    0.03 1.01 -1.98 -0.66  0.03 0.70  1.98  1600    1
#> z[3,1]  0.01    0.02 0.99 -1.90 -0.65  0.01 0.67  1.94  2381    1
#> z[3,2] -0.01    0.02 1.00 -1.98 -0.73 -0.02 0.66  2.02  1639    1
#> alpha   0.52    0.02 0.54  0.01  0.14  0.36 0.71  1.90  1137    1
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

``` r

  fit4 <- fit%>%
    stan_slice(1:50,inc_warmup = TRUE)

  objsize(fit4)
#> [1] "Object Size: 165.5 Kb"

  fit4
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=300; warmup=250; thin=1; 
#> post-warmup draws per chain=50, total post-warmup draws=200.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.10    0.02 0.26  -0.37  -0.05   0.10   0.27   0.60   258 1.00
#> sigma    1.15    0.01 0.19   0.83   1.02   1.11   1.26   1.60   382 1.00
#> z[1,1]   0.12    0.05 1.02  -1.77  -0.51   0.12   0.75   2.22   484 0.99
#> z[1,2]  -0.04    0.03 0.89  -2.02  -0.49  -0.03   0.53   1.55   908 1.00
#> z[2,1]  -0.05    0.05 0.91  -1.79  -0.73  -0.09   0.62   1.53   408 0.99
#> z[2,2]  -0.02    0.04 1.00  -1.99  -0.64  -0.01   0.63   1.88   657 0.99
#> z[3,1]  -0.01    0.05 1.07  -1.87  -0.80  -0.03   0.78   1.97   476 0.99
#> z[3,2]  -0.05    0.04 0.97  -1.99  -0.72  -0.06   0.62   1.88   518 0.99
#> alpha    0.60    0.06 0.62   0.01   0.19   0.44   0.83   2.81    98 1.00
#> lp__   -17.40    0.22 1.98 -22.04 -18.58 -17.27 -15.94 -14.19    81 1.05
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).

  fit5 <- fit%>%
    stan_slice(1:50,inc_warmup = FALSE)

  objsize(fit5)
#> [1] "Object Size: 87.4 Kb"
  
  fit5
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=50; warmup=0; thin=1; 
#> post-warmup draws per chain=50, total post-warmup draws=200.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.10    0.02 0.26  -0.37  -0.05   0.10   0.27   0.60   258 1.00
#> sigma    1.15    0.01 0.19   0.83   1.02   1.11   1.26   1.60   382 1.00
#> z[1,1]   0.12    0.05 1.02  -1.77  -0.51   0.12   0.75   2.22   484 0.99
#> z[1,2]  -0.04    0.03 0.89  -2.02  -0.49  -0.03   0.53   1.55   908 1.00
#> z[2,1]  -0.05    0.05 0.91  -1.79  -0.73  -0.09   0.62   1.53   408 0.99
#> z[2,2]  -0.02    0.04 1.00  -1.99  -0.64  -0.01   0.63   1.88   657 0.99
#> z[3,1]  -0.01    0.05 1.07  -1.87  -0.80  -0.03   0.78   1.97   476 0.99
#> z[3,2]  -0.05    0.04 0.97  -1.99  -0.72  -0.06   0.62   1.88   518 0.99
#> alpha    0.60    0.06 0.62   0.01   0.19   0.44   0.83   2.81    98 1.00
#> lp__   -17.40    0.22 1.98 -22.04 -18.58 -17.27 -15.94 -14.19    81 1.05
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
  
  fit6 <- fit%>%
    stan_sample_n(100)

  objsize(fit6)
#> [1] "Object Size: 188.2 Kb"
  
  fit6
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=350; warmup=250; thin=1; 
#> post-warmup draws per chain=100, total post-warmup draws=400.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.10    0.02 0.26  -0.37  -0.05   0.10   0.27   0.60   258 1.00
#> sigma    1.15    0.01 0.19   0.83   1.02   1.11   1.26   1.60   382 1.00
#> z[1,1]   0.12    0.05 1.02  -1.77  -0.51   0.12   0.75   2.22   484 0.99
#> z[1,2]  -0.04    0.03 0.89  -2.02  -0.49  -0.03   0.53   1.55   908 1.00
#> z[2,1]  -0.05    0.05 0.91  -1.79  -0.73  -0.09   0.62   1.53   408 0.99
#> z[2,2]  -0.02    0.04 1.00  -1.99  -0.64  -0.01   0.63   1.88   657 0.99
#> z[3,1]  -0.01    0.05 1.07  -1.87  -0.80  -0.03   0.78   1.97   476 0.99
#> z[3,2]  -0.05    0.04 0.97  -1.99  -0.72  -0.06   0.62   1.88   518 0.99
#> alpha    0.60    0.06 0.62   0.01   0.19   0.44   0.83   2.81    98 1.00
#> lp__   -17.40    0.22 1.98 -22.04 -18.58 -17.27 -15.94 -14.19    81 1.05
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
  
  fit7 <- fit%>%
    stan_sample_frac(0.5)
  
  objsize(fit7)
#> [1] "Object Size: 199.5 Kb"
  
  fit7
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=375; warmup=250; thin=1; 
#> post-warmup draws per chain=125, total post-warmup draws=500.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.10    0.02 0.26  -0.37  -0.05   0.10   0.27   0.60   258 1.00
#> sigma    1.15    0.01 0.19   0.83   1.02   1.11   1.26   1.60   382 1.00
#> z[1,1]   0.12    0.05 1.02  -1.77  -0.51   0.12   0.75   2.22   484 0.99
#> z[1,2]  -0.04    0.03 0.89  -2.02  -0.49  -0.03   0.53   1.55   908 1.00
#> z[2,1]  -0.05    0.05 0.91  -1.79  -0.73  -0.09   0.62   1.53   408 0.99
#> z[2,2]  -0.02    0.04 1.00  -1.99  -0.64  -0.01   0.63   1.88   657 0.99
#> z[3,1]  -0.01    0.05 1.07  -1.87  -0.80  -0.03   0.78   1.97   476 0.99
#> z[3,2]  -0.05    0.04 0.97  -1.99  -0.72  -0.06   0.62   1.88   518 0.99
#> alpha    0.60    0.06 0.62   0.01   0.19   0.44   0.83   2.81    98 1.00
#> lp__   -17.40    0.22 1.98 -22.04 -18.58 -17.27 -15.94 -14.19    81 1.05
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

``` r
  fit8 <- fit%>%
    stan_select(mu)%>%
    stan_slice(1:50)

  fit8
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=300; warmup=250; thin=1; 
#> post-warmup draws per chain=50, total post-warmup draws=200.
#> 
#>    mean se_mean   sd  2.5%   25% 50%  75% 97.5% n_eff Rhat
#> mu  0.1    0.02 0.26 -0.37 -0.05 0.1 0.27   0.6   258    1
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

``` r

fit9 <- fit%>%
    stan_split(inc_warmup = TRUE)

length(fit9)
#> [1] 10

purrr::map_chr(fit9,objsize)
#>                       1                       2                       3 
#> "Object Size: 154.3 Kb" "Object Size: 154.3 Kb" "Object Size: 154.3 Kb" 
#>                       4                       5                       6 
#> "Object Size: 154.3 Kb" "Object Size: 154.3 Kb" "Object Size: 154.3 Kb" 
#>                       7                       8                       9 
#> "Object Size: 154.3 Kb" "Object Size: 154.3 Kb" "Object Size: 154.3 Kb" 
#>                      10 
#> "Object Size: 154.3 Kb"

fit9[[1]]
#> Warning in sqrt(ess): NaNs produced
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=275; warmup=250; thin=1; 
#> post-warmup draws per chain=25, total post-warmup draws=100.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.09    0.02 0.27  -0.39  -0.05   0.06   0.25   0.64   141 0.98
#> sigma    1.17    0.01 0.23   0.83   1.02   1.11   1.31   1.69   267 0.99
#> z[1,1]   0.15    0.06 0.96  -1.63  -0.47   0.12   0.75   2.01   281 0.98
#> z[1,2]  -0.03    0.03 0.95  -2.06  -0.46  -0.03   0.56   1.52   764 0.98
#> z[2,1]  -0.13    0.05 0.87  -2.01  -0.69  -0.13   0.39   1.50   260 0.98
#> z[2,2]   0.02    0.05 0.94  -1.96  -0.56   0.07   0.62   1.87   334 1.00
#> z[3,1]  -0.08    0.07 0.99  -1.84  -0.80  -0.12   0.62   1.75   232 0.96
#> z[3,2]  -0.06     NaN 0.93  -1.77  -0.72  -0.01   0.58   1.63 -3403 0.97
#> alpha    0.56    0.02 0.47   0.03   0.21   0.44   0.85   1.52   383 0.97
#> lp__   -17.26    0.24 1.91 -21.81 -18.42 -17.26 -15.78 -14.28    64 1.01
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).

fit10 <- fit%>%
    stan_split(inc_warmup = FALSE)

purrr::map_chr(fit10,objsize)
#>                      1                      2                      3 
#> "Object Size: 76.2 Kb" "Object Size: 76.2 Kb" "Object Size: 76.2 Kb" 
#>                      4                      5                      6 
#> "Object Size: 76.2 Kb" "Object Size: 76.2 Kb" "Object Size: 76.2 Kb" 
#>                      7                      8                      9 
#> "Object Size: 76.2 Kb" "Object Size: 76.2 Kb" "Object Size: 76.2 Kb" 
#>                     10 
#> "Object Size: 76.2 Kb"

fit10[[1]]
#> Warning in sqrt(ess): NaNs produced
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=25; warmup=0; thin=1; 
#> post-warmup draws per chain=25, total post-warmup draws=100.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.09    0.02 0.27  -0.39  -0.05   0.06   0.25   0.64   141 0.98
#> sigma    1.17    0.01 0.23   0.83   1.02   1.11   1.31   1.69   267 0.99
#> z[1,1]   0.15    0.06 0.96  -1.63  -0.47   0.12   0.75   2.01   281 0.98
#> z[1,2]  -0.03    0.03 0.95  -2.06  -0.46  -0.03   0.56   1.52   764 0.98
#> z[2,1]  -0.13    0.05 0.87  -2.01  -0.69  -0.13   0.39   1.50   260 0.98
#> z[2,2]   0.02    0.05 0.94  -1.96  -0.56   0.07   0.62   1.87   334 1.00
#> z[3,1]  -0.08    0.07 0.99  -1.84  -0.80  -0.12   0.62   1.75   232 0.96
#> z[3,2]  -0.06     NaN 0.93  -1.77  -0.72  -0.01   0.58   1.63 -3403 0.97
#> alpha    0.56    0.02 0.47   0.03   0.21   0.44   0.85   1.52   383 0.97
#> lp__   -17.26    0.24 1.91 -21.81 -18.42 -17.26 -15.78 -14.28    64 1.01
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).

fit11 <- fit%>%
    stan_split(ncut = 4, inc_warmup = FALSE)

length(fit11)
#> [1] 4

purrr::map_chr(fit11,objsize)
#>                      1                      2                      3 
#> "Object Size: 93.8 Kb" "Object Size: 92.9 Kb" "Object Size: 92.9 Kb" 
#>                      4 
#> "Object Size: 92.9 Kb"

fit11[[1]]
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=64; warmup=0; thin=1; 
#> post-warmup draws per chain=64, total post-warmup draws=256.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.10    0.02 0.28  -0.50  -0.06   0.10   0.28   0.61   267 1.01
#> sigma    1.15    0.01 0.19   0.84   1.02   1.11   1.26   1.59   423 1.00
#> z[1,1]   0.09    0.04 0.99  -1.86  -0.51   0.10   0.68   2.10   617 0.99
#> z[1,2]  -0.05    0.03 0.97  -2.09  -0.60  -0.04   0.53   1.67  1220 0.99
#> z[2,1]  -0.03    0.04 0.96  -1.92  -0.73  -0.08   0.73   1.59   691 0.99
#> z[2,2]  -0.03    0.04 0.99  -1.96  -0.65  -0.03   0.59   1.91   701 1.00
#> z[3,1]  -0.02    0.05 1.08  -1.96  -0.80  -0.05   0.73   1.96   536 0.99
#> z[3,2]  -0.04    0.06 1.02  -2.06  -0.75  -0.09   0.62   2.06   325 1.01
#> alpha    0.57    0.05 0.59   0.02   0.18   0.42   0.75   2.52   131 1.01
#> lp__   -17.62    0.20 1.97 -22.06 -18.73 -17.41 -16.23 -14.26    96 1.04
#> 
#> Samples were drawn using  at Thu Apr 18 15:42:52 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

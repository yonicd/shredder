
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shredder

<!-- badges: start -->

<!-- badges: end -->

The goal of shredder is to apply tidylike verbs to rstan simulation
objects. The usage is similar to the `dplyr` verbs, the input is a
stanfit object and the output is a manipulated stanfit object.

It is very powerful to use with [`tidybayes`](#tidybayes) verbs to
manipulate the shape of the output.

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
          - `stan_contains`, `stan_starts_with`,`stan_ends_with`:
            partial par extractions (used within `stan_select`)
          - `stan_names` : return names within the stanfit object
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
library(tidybayes)
#> Warning: package 'tidybayes' was built under R version 3.5.2
#> NOTE: As of tidybayes version 1.0, several functions, arguments, and output column names
#>       have undergone significant name changes in order to adopt a unified naming scheme.
#>       See help('tidybayes-deprecated') for more information.
```

``` r
objsize <- function(x){
  sprintf(
    'Object Size: %s',
    format(object.size(x),units = 'auto')
  )
} 
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
fit <- rstan::stan(model_code = excode, iter = 500, verbose = FALSE)
```

``` r
objsize(fit)
#> [1] "Object Size: 348.8 Kb"

fit
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=500; warmup=250; thin=1; 
#> post-warmup draws per chain=250, total post-warmup draws=1000.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.12    0.01 0.27  -0.41  -0.06   0.11   0.29   0.68  1189    1
#> sigma    1.19    0.01 0.22   0.84   1.03   1.16   1.31   1.70  1102    1
#> z[1,1]   0.04    0.02 0.99  -2.01  -0.62   0.06   0.70   1.92  1992    1
#> z[1,2]   0.00    0.02 0.94  -1.78  -0.66   0.00   0.66   1.77  1765    1
#> z[2,1]  -0.03    0.02 0.97  -1.97  -0.67  -0.02   0.61   1.82  1548    1
#> z[2,2]   0.00    0.03 0.98  -1.86  -0.69   0.02   0.69   1.91  1382    1
#> z[3,1]   0.02    0.02 0.91  -1.80  -0.58   0.01   0.60   1.90  1772    1
#> z[3,2]   0.06    0.03 1.02  -1.95  -0.66   0.08   0.77   2.02  1461    1
#> alpha    0.50    0.01 0.49   0.02   0.14   0.35   0.71   1.81  1597    1
#> lp__   -17.48    0.09 2.11 -22.04 -18.69 -17.22 -15.95 -14.32   503    1
#> 
#> Samples were drawn using NUTS(diag_e) at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

## Pars

### Names

``` r
fit%>%stan_names()
#> [1] "mu"    "sigma" "z"     "alpha" "lp__"

fit%>%stan_names(expand = TRUE)
#>  [1] "mu"     "sigma"  "z[1,1]" "z[2,1]" "z[3,1]" "z[1,2]" "z[2,2]"
#>  [8] "z[3,2]" "alpha"  "lp__"
```

### Select

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
#>    mean se_mean   sd  2.5%   25%  50%  75% 97.5% n_eff Rhat
#> mu 0.12    0.01 0.27 -0.41 -0.06 0.11 0.29  0.68  1189    1
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
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
#> mu    0.12    0.01 0.27 -0.41 -0.06 0.11 0.29  0.68  1189    1
#> sigma 1.19    0.01 0.22  0.84  1.03 1.16 1.31  1.70  1102    1
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
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
#> z[1,1]  0.04    0.02 0.99 -2.01 -0.62  0.06 0.70  1.92  1992    1
#> z[1,2]  0.00    0.02 0.94 -1.78 -0.66  0.00 0.66  1.77  1765    1
#> z[2,1] -0.03    0.02 0.97 -1.97 -0.67 -0.02 0.61  1.82  1548    1
#> z[2,2]  0.00    0.03 0.98 -1.86 -0.69  0.02 0.69  1.91  1382    1
#> z[3,1]  0.02    0.02 0.91 -1.80 -0.58  0.01 0.60  1.90  1772    1
#> z[3,2]  0.06    0.03 1.02 -1.95 -0.66  0.08 0.77  2.02  1461    1
#> alpha   0.50    0.01 0.49  0.02  0.14  0.35 0.71  1.81  1597    1
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

### Select with Partials

``` r
fit%>%
  stan_select(stan_contains('z'))
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=500; warmup=250; thin=1; 
#> post-warmup draws per chain=250, total post-warmup draws=1000.
#> 
#>         mean se_mean   sd  2.5%   25%   50%  75% 97.5% n_eff Rhat
#> z[1,1]  0.04    0.02 0.99 -2.01 -0.62  0.06 0.70  1.92  1992    1
#> z[1,2]  0.00    0.02 0.94 -1.78 -0.66  0.00 0.66  1.77  1765    1
#> z[2,1] -0.03    0.02 0.97 -1.97 -0.67 -0.02 0.61  1.82  1548    1
#> z[2,2]  0.00    0.03 0.98 -1.86 -0.69  0.02 0.69  1.91  1382    1
#> z[3,1]  0.02    0.02 0.91 -1.80 -0.58  0.01 0.60  1.90  1772    1
#> z[3,2]  0.06    0.03 1.02 -1.95 -0.66  0.08 0.77  2.02  1461    1
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).

fit%>%
  stan_select(stan_ends_with('a'))
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=500; warmup=250; thin=1; 
#> post-warmup draws per chain=250, total post-warmup draws=1000.
#> 
#>       mean se_mean   sd 2.5%  25%  50%  75% 97.5% n_eff Rhat
#> sigma 1.19    0.01 0.22 0.84 1.03 1.16 1.31  1.70  1102    1
#> alpha 0.50    0.01 0.49 0.02 0.14 0.35 0.71  1.81  1597    1
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).

fit%>%
  stan_select(mu,stan_ends_with('a'))
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=500; warmup=250; thin=1; 
#> post-warmup draws per chain=250, total post-warmup draws=1000.
#> 
#>       mean se_mean   sd  2.5%   25%  50%  75% 97.5% n_eff Rhat
#> mu    0.12    0.01 0.27 -0.41 -0.06 0.11 0.29  0.68  1189    1
#> sigma 1.19    0.01 0.22  0.84  1.03 1.16 1.31  1.70  1102    1
#> alpha 0.50    0.01 0.49  0.02  0.14 0.35 0.71  1.81  1597    1
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

## Post-warmup samples

### Subsetting post warmup samples

``` r

  fit4 <- fit%>%
    stan_slice(1:50,inc_warmup = TRUE)

  objsize(fit4)
#> [1] "Object Size: 165.6 Kb"

  fit4
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=300; warmup=250; thin=1; 
#> post-warmup draws per chain=50, total post-warmup draws=200.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.14    0.02 0.28  -0.43  -0.04   0.12   0.30   0.65   187 1.00
#> sigma    1.18    0.01 0.23   0.81   1.03   1.17   1.30   1.69   559 0.99
#> z[1,1]   0.08    0.05 1.12  -2.16  -0.71   0.19   0.77   2.12   448 0.99
#> z[1,2]   0.01    0.04 0.95  -1.67  -0.70   0.00   0.73   1.65   480 1.00
#> z[2,1]  -0.01    0.05 0.97  -1.71  -0.68   0.00   0.71   1.72   398 0.99
#> z[2,2]   0.06    0.04 0.97  -1.70  -0.68   0.06   0.75   1.67   560 0.99
#> z[3,1]  -0.05    0.04 0.88  -1.70  -0.59  -0.09   0.49   1.61   604 0.99
#> z[3,2]   0.08    0.06 1.03  -1.93  -0.64   0.17   0.67   2.10   333 0.99
#> alpha    0.51    0.03 0.52   0.03   0.13   0.34   0.71   1.77   300 1.00
#> lp__   -17.68    0.21 2.21 -22.68 -18.95 -17.33 -16.11 -14.77   113 1.00
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).

  fit5 <- fit%>%
    stan_slice(1:50,inc_warmup = FALSE)

  objsize(fit5)
#> [1] "Object Size: 87.5 Kb"
  
  fit5
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=50; warmup=0; thin=1; 
#> post-warmup draws per chain=50, total post-warmup draws=200.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.14    0.02 0.28  -0.43  -0.04   0.12   0.30   0.65   187 1.00
#> sigma    1.18    0.01 0.23   0.81   1.03   1.17   1.30   1.69   559 0.99
#> z[1,1]   0.08    0.05 1.12  -2.16  -0.71   0.19   0.77   2.12   448 0.99
#> z[1,2]   0.01    0.04 0.95  -1.67  -0.70   0.00   0.73   1.65   480 1.00
#> z[2,1]  -0.01    0.05 0.97  -1.71  -0.68   0.00   0.71   1.72   398 0.99
#> z[2,2]   0.06    0.04 0.97  -1.70  -0.68   0.06   0.75   1.67   560 0.99
#> z[3,1]  -0.05    0.04 0.88  -1.70  -0.59  -0.09   0.49   1.61   604 0.99
#> z[3,2]   0.08    0.06 1.03  -1.93  -0.64   0.17   0.67   2.10   333 0.99
#> alpha    0.51    0.03 0.52   0.03   0.13   0.34   0.71   1.77   300 1.00
#> lp__   -17.68    0.21 2.21 -22.68 -18.95 -17.33 -16.11 -14.77   113 1.00
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
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
#> mu       0.14    0.02 0.28  -0.43  -0.04   0.12   0.30   0.65   187 1.00
#> sigma    1.18    0.01 0.23   0.81   1.03   1.17   1.30   1.69   559 0.99
#> z[1,1]   0.08    0.05 1.12  -2.16  -0.71   0.19   0.77   2.12   448 0.99
#> z[1,2]   0.01    0.04 0.95  -1.67  -0.70   0.00   0.73   1.65   480 1.00
#> z[2,1]  -0.01    0.05 0.97  -1.71  -0.68   0.00   0.71   1.72   398 0.99
#> z[2,2]   0.06    0.04 0.97  -1.70  -0.68   0.06   0.75   1.67   560 0.99
#> z[3,1]  -0.05    0.04 0.88  -1.70  -0.59  -0.09   0.49   1.61   604 0.99
#> z[3,2]   0.08    0.06 1.03  -1.93  -0.64   0.17   0.67   2.10   333 0.99
#> alpha    0.51    0.03 0.52   0.03   0.13   0.34   0.71   1.77   300 1.00
#> lp__   -17.68    0.21 2.21 -22.68 -18.95 -17.33 -16.11 -14.77   113 1.00
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
  
  fit7 <- fit%>%
    stan_sample_frac(0.5)
  
  objsize(fit7)
#> [1] "Object Size: 199.6 Kb"
  
  fit7
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=375; warmup=250; thin=1; 
#> post-warmup draws per chain=125, total post-warmup draws=500.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.14    0.02 0.28  -0.43  -0.04   0.12   0.30   0.65   187 1.00
#> sigma    1.18    0.01 0.23   0.81   1.03   1.17   1.30   1.69   559 0.99
#> z[1,1]   0.08    0.05 1.12  -2.16  -0.71   0.19   0.77   2.12   448 0.99
#> z[1,2]   0.01    0.04 0.95  -1.67  -0.70   0.00   0.73   1.65   480 1.00
#> z[2,1]  -0.01    0.05 0.97  -1.71  -0.68   0.00   0.71   1.72   398 0.99
#> z[2,2]   0.06    0.04 0.97  -1.70  -0.68   0.06   0.75   1.67   560 0.99
#> z[3,1]  -0.05    0.04 0.88  -1.70  -0.59  -0.09   0.49   1.61   604 0.99
#> z[3,2]   0.08    0.06 1.03  -1.93  -0.64   0.17   0.67   2.10   333 0.99
#> alpha    0.51    0.03 0.52   0.03   0.13   0.34   0.71   1.77   300 1.00
#> lp__   -17.68    0.21 2.21 -22.68 -18.95 -17.33 -16.11 -14.77   113 1.00
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

### Select and Slice

``` r
  fit8 <- fit%>%
    stan_select(mu)%>%
    stan_slice(1:50)

  fit8
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=300; warmup=250; thin=1; 
#> post-warmup draws per chain=50, total post-warmup draws=200.
#> 
#>    mean se_mean   sd  2.5%   25%  50% 75% 97.5% n_eff Rhat
#> mu 0.14    0.02 0.28 -0.43 -0.04 0.12 0.3  0.65   187    1
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

### Split

``` r

fit9 <- fit%>%
    stan_split(inc_warmup = TRUE)

length(fit9)
#> [1] 10

purrr::map_chr(fit9,objsize)
#>                       1                       2                       3 
#> "Object Size: 154.4 Kb" "Object Size: 154.4 Kb" "Object Size: 154.4 Kb" 
#>                       4                       5                       6 
#> "Object Size: 154.4 Kb" "Object Size: 154.4 Kb" "Object Size: 154.4 Kb" 
#>                       7                       8                       9 
#> "Object Size: 154.4 Kb" "Object Size: 154.4 Kb" "Object Size: 154.4 Kb" 
#>                      10 
#> "Object Size: 154.4 Kb"

fit9[[1]]
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=275; warmup=250; thin=1; 
#> post-warmup draws per chain=25, total post-warmup draws=100.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.13    0.03 0.25  -0.36   0.00   0.11   0.24   0.57    86 1.03
#> sigma    1.19    0.01 0.26   0.78   1.03   1.16   1.31   1.78   305 0.97
#> z[1,1]  -0.01    0.05 1.03  -2.24  -0.67   0.10   0.60   2.00   430 0.99
#> z[1,2]  -0.01    0.05 0.96  -1.61  -0.68  -0.05   0.64   1.71   433 0.97
#> z[2,1]   0.01    0.05 1.00  -1.70  -0.68  -0.04   0.78   1.74   449 0.98
#> z[2,2]  -0.04    0.05 0.91  -1.74  -0.73   0.02   0.60   1.45   293 0.98
#> z[3,1]  -0.07    0.06 0.85  -1.65  -0.64  -0.13   0.57   1.52   225 0.99
#> z[3,2]   0.04    0.05 1.00  -1.95  -0.68   0.11   0.65   2.07   382 0.98
#> alpha    0.48    0.03 0.46   0.02   0.13   0.36   0.68   1.70   232 0.99
#> lp__   -17.52    0.36 2.26 -22.18 -18.70 -17.05 -15.80 -14.79    39 1.04
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
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
#> Inference for Stan model: 9eb770bb13e360b55b7f4acaf07142c1.
#> 4 chains, each with iter=25; warmup=0; thin=1; 
#> post-warmup draws per chain=25, total post-warmup draws=100.
#> 
#>          mean se_mean   sd   2.5%    25%    50%    75%  97.5% n_eff Rhat
#> mu       0.13    0.03 0.25  -0.36   0.00   0.11   0.24   0.57    86 1.03
#> sigma    1.19    0.01 0.26   0.78   1.03   1.16   1.31   1.78   305 0.97
#> z[1,1]  -0.01    0.05 1.03  -2.24  -0.67   0.10   0.60   2.00   430 0.99
#> z[1,2]  -0.01    0.05 0.96  -1.61  -0.68  -0.05   0.64   1.71   433 0.97
#> z[2,1]   0.01    0.05 1.00  -1.70  -0.68  -0.04   0.78   1.74   449 0.98
#> z[2,2]  -0.04    0.05 0.91  -1.74  -0.73   0.02   0.60   1.45   293 0.98
#> z[3,1]  -0.07    0.06 0.85  -1.65  -0.64  -0.13   0.57   1.52   225 0.99
#> z[3,2]   0.04    0.05 1.00  -1.95  -0.68   0.11   0.65   2.07   382 0.98
#> alpha    0.48    0.03 0.46   0.02   0.13   0.36   0.68   1.70   232 0.99
#> lp__   -17.52    0.36 2.26 -22.18 -18.70 -17.05 -15.80 -14.79    39 1.04
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
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
#> mu       0.13    0.02 0.27  -0.41  -0.05   0.12   0.29   0.63   245 1.00
#> sigma    1.18    0.01 0.22   0.80   1.03   1.17   1.30   1.69   517 0.99
#> z[1,1]   0.07    0.04 1.11  -2.19  -0.71   0.17   0.75   2.11   765 0.99
#> z[1,2]  -0.01    0.04 0.91  -1.67  -0.65  -0.05   0.66   1.65   563 1.00
#> z[2,1]  -0.02    0.04 0.94  -1.70  -0.64  -0.05   0.63   1.66   512 0.99
#> z[2,2]   0.07    0.04 0.98  -1.79  -0.60   0.06   0.75   1.90   642 0.99
#> z[3,1]  -0.03    0.03 0.84  -1.68  -0.58   0.00   0.49   1.59   646 0.99
#> z[3,2]   0.06    0.05 1.01  -1.92  -0.68   0.12   0.70   2.09   452 0.99
#> alpha    0.52    0.03 0.51   0.03   0.13   0.34   0.72   1.78   371 1.00
#> lp__   -17.51    0.17 2.12 -22.20 -18.63 -17.17 -16.02 -14.51   157 0.99
#> 
#> Samples were drawn using  at Thu Apr 18 17:41:28 2019.
#> For each parameter, n_eff is a crude measure of effective sample size,
#> and Rhat is the potential scale reduction factor on split chains (at 
#> convergence, Rhat=1).
```

## tidybayes

### Spread

``` r
fit%>%
  tidybayes::spread_draws(alpha,sigma)
#> # A tibble: 1,000 x 5
#>    .chain .iteration .draw  alpha sigma
#>     <int>      <int> <int>  <dbl> <dbl>
#>  1      1          1     1 0.427  0.871
#>  2      1          2     2 0.611  1.28 
#>  3      1          3     3 0.123  1.29 
#>  4      1          4     4 0.287  1.27 
#>  5      1          5     5 0.309  0.982
#>  6      1          6     6 0.748  1.31 
#>  7      1          7     7 0.0722 0.885
#>  8      1          8     8 1.32   1.40 
#>  9      1          9     9 0.107  0.806
#> 10      1         10    10 0.0542 0.877
#> # … with 990 more rows

fit%>%
  stan_sample_n(2)%>%
  tidybayes::spread_draws(alpha,sigma)
#> # A tibble: 8 x 5
#>   .chain .iteration .draw  alpha sigma
#>    <int>      <int> <int>  <dbl> <dbl>
#> 1      1          1     1 0.190  0.864
#> 2      1          2     2 0.394  1.09 
#> 3      2          1     3 0.0907 1.00 
#> 4      2          2     4 0.550  1.69 
#> 5      3          1     5 0.492  1.04 
#> 6      3          2     6 0.318  1.20 
#> 7      4          1     7 0.404  1.63 
#> 8      4          2     8 1.97   1.18

fit%>%
  stan_sample_n(2)%>%
  tidybayes::spread_draws(z[i,j])
#> # A tibble: 48 x 6
#> # Groups:   i, j [6]
#>    .chain .iteration .draw     i     j       z
#>     <int>      <int> <int> <int> <int>   <dbl>
#>  1      1          1     1     1     1  0.376 
#>  2      1          1     1     1     2  0.0282
#>  3      1          1     1     2     1 -1.11  
#>  4      1          1     1     2     2  1.91  
#>  5      1          1     1     3     1 -0.0541
#>  6      1          1     1     3     2  1.14  
#>  7      1          2     2     1     1 -0.0632
#>  8      1          2     2     1     2  0.988 
#>  9      1          2     2     2     1  0.564 
#> 10      1          2     2     2     2 -0.291 
#> # … with 38 more rows
```

### Gather

``` r
fit%>%
  tidybayes::gather_draws(alpha,sigma)
#> # A tibble: 2,000 x 5
#> # Groups:   .variable [2]
#>    .chain .iteration .draw .variable .value
#>     <int>      <int> <int> <chr>      <dbl>
#>  1      1          1     1 alpha     0.427 
#>  2      1          2     2 alpha     0.611 
#>  3      1          3     3 alpha     0.123 
#>  4      1          4     4 alpha     0.287 
#>  5      1          5     5 alpha     0.309 
#>  6      1          6     6 alpha     0.748 
#>  7      1          7     7 alpha     0.0722
#>  8      1          8     8 alpha     1.32  
#>  9      1          9     9 alpha     0.107 
#> 10      1         10    10 alpha     0.0542
#> # … with 1,990 more rows

fit%>%
  stan_sample_n(2)%>%
  tidybayes::gather_draws(alpha,sigma)
#> # A tibble: 16 x 5
#> # Groups:   .variable [2]
#>    .chain .iteration .draw .variable .value
#>     <int>      <int> <int> <chr>      <dbl>
#>  1      1          1     1 alpha     0.0596
#>  2      1          2     2 alpha     0.249 
#>  3      2          1     3 alpha     0.157 
#>  4      2          2     4 alpha     1.01  
#>  5      3          1     5 alpha     0.464 
#>  6      3          2     6 alpha     0.437 
#>  7      4          1     7 alpha     1.17  
#>  8      4          2     8 alpha     0.240 
#>  9      1          1     1 sigma     1.17  
#> 10      1          2     2 sigma     1.25  
#> 11      2          1     3 sigma     0.951 
#> 12      2          2     4 sigma     0.894 
#> 13      3          1     5 sigma     0.996 
#> 14      3          2     6 sigma     1.16  
#> 15      4          1     7 sigma     1.53  
#> 16      4          2     8 sigma     1.15

fit%>%
  stan_sample_n(2)%>%
  tidybayes::gather_draws(z[i,j])
#> # A tibble: 48 x 7
#> # Groups:   i, j, .variable [6]
#>    .chain .iteration .draw     i     j .variable  .value
#>     <int>      <int> <int> <int> <int> <chr>       <dbl>
#>  1      1          1     1     1     1 z         -2.35  
#>  2      1          1     1     1     2 z          0.474 
#>  3      1          1     1     2     1 z          1.11  
#>  4      1          1     1     2     2 z          0.729 
#>  5      1          1     1     3     1 z         -0.0937
#>  6      1          1     1     3     2 z          1.95  
#>  7      1          2     2     1     1 z         -0.111 
#>  8      1          2     2     1     2 z          1.13  
#>  9      1          2     2     2     1 z          0.0322
#> 10      1          2     2     2     2 z         -1.40  
#> # … with 38 more rows
```

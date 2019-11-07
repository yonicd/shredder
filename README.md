# shredder

<!-- badges: start -->
[![Covrpage
Summary](https://img.shields.io/badge/covrpage-Last_Build_2019_05_22-brightgreen.svg)](http://tinyurl.com/y3zvyrpx)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

The goal of shredder is to apply tidylike verbs to rstan simulation
objects. The usage is similar to the [dplyr](https://dplyr.tidyverse.org/) verbs, the input is a
stanfit object and the output is a manipulated stanfit object.

This package is also a good way to integrate [tidybayes](https://mjskay.github.io/tidybayes/) into a workflow


> Disclaimer: this is experimental, use deliberately, with caution and not on client projects

## Installation

You can install shredder from `GHE` with:

``` r
remotes::install_github(
  repo = 'yoni/shredder',
  host = 'ghe.metrumrg.com/api/v3',
  auth_token = Sys.getenv('GHE_PAT')
)
```

## Verbs

  - Dimension
      - pars:
          - `shredder::stan_select` : extract specific pars
          - `shredder::stan_contains`, `shredder::stan_starts_with`,`shredder::stan_ends_with`:
            partial par extractions (used within `shredder::stan_select`)
          - `shredder::stan_names` : return names within the stanfit object
      - post-warmup samples
          - `shredder::stan_slice` : extract specific samples by index
          - `shredder::stan_sample_n` : extract random n samples
          - `shredder::stan_sample_frac` : extract fraction of total samples
          - `shredder::stan_filter` : extract subset of samples conditional on
            filter of parameter values

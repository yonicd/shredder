
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shredder

<!-- badges: start -->
[![Build Status](https://travis.metrumrg.com/yoni/shredder.svg?token=tfrDuc83e84K9CqJKyCs&branch=master)](https://travis.metrumrg.com/yoni/shredder)
[![Build
Status](https://travis.metrumrg.com/yoni/shredder.svg?token=tfrDuc83e84K9CqJKyCs&branch=master)](https://travis.metrumrg.com/yoni/shredder)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

The goal of shredder is to apply tidylike verbs to rstan simulation
objects. The usage is similar to the `dplyr` verbs, the input is a
stanfit object and the output is a manipulated stanfit object.

It is very powerful to use with [`tidybayes`](#tidybayes) verbs to
manipulate the shape of the output.

> Disclaimer: this is experimental, use deliberately, with caution and
> not on client
projects

[proposal](https://docs.google.com/document/d/1_xFfVPPmPMQoFwpyGoL4N6kGNXLY0hZSEtmSiY03IXY/edit)
for tools committee

## TODO

  - Add unit tests

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

# shredder

<!-- badges: start -->
[![Covrpage
Summary](https://img.shields.io/badge/covrpage-Last_Build_2019_11_18-brightgreen.svg)](http://tinyurl.com/y3zvyrpx)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

The goal of shredder is to apply tidylike verbs to rstan simulation objects. The usage is similar to the [dplyr](https://dplyr.tidyverse.org/) verbs. 

The verbs are `S3` methods that have built in suport for `stanfit` and `brmsfit` class objects and the output is the manipulated object remaining in the same class.

This package is also a good way to integrate [tidybayes](https://mjskay.github.io/tidybayes/) into a workflow

> Important: The shredder API is still maturing. Please see ?shredder::lifecycle for the list of functions that are considered stable.

## Installation

``` r
remotes::install_github('metrumreseaerchgroup/shredder')
```

## Verbs

  - Dimension
      - chains
          - `shredder::stan_retain` : extract specific chains
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

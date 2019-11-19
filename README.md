# shredder

<!-- badges: start -->
[![Covrpage
Summary](https://img.shields.io/badge/covrpage-Last_Build_2019_11_18-brightgreen.svg)](http://tinyurl.com/y3zvyrpx)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

The goal of __shredder__ is to apply tidy-like verbs to rstan simulation objects. 

  - With these new verbs users can: 
    - Manipulate fit objects without needing to convert arrays into recatangular form.
    - Generate task specifc subsets of the parent fit object for fit diagnostics and post-processing
    - Use pipe operators to create more user-friendly workflows
    
  - The verbs are `S3` methods that have built-in support for the `stanfit` and `brmsfit` classes.

__Important__: The __shredder__ API is still maturing. Please see `?shredder::lifecycle` for the list of functions that are considered stable.

## Installation

``` r
remotes::install_github('metrumreseaerchgroup/shredder')
```

## Current Verbs

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

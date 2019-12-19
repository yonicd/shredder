
<!-- README.md is generated from README.Rmd. Please edit that file -->

## This package should be considered a thought experiment that we are interested to get feedback around the implementation and whether it can help solve your problems.

## It is under development and the API will break as we better understand the problems it is attempting to solve. Use at your own risk.

<hr>

# shredder <img src="man/figures/logo.png" align="right" class="logo"/>

<!-- badges: start -->

[![Covrpage
Summary](https://img.shields.io/badge/covrpage-Last_Build_2019_12_11-brightgreen.svg)](http://tinyurl.com/s3fr6gn)
[![Travis build
status](https://travis-ci.org/metrumresearchgroup/shredder.svg?branch=master)](https://travis-ci.org/metrumresearchgroup/shredder)
[![Codecov test
coverage](https://codecov.io/gh/metrumresearchgroup/shredder/branch/master/graph/badge.svg)](https://codecov.io/gh/metrumresearchgroup/shredder?branch=master)
<!-- badges: end -->

The goal of **shredder** is to create an API that incites exploration
and iteration of rstan simulation objects.

  - With this API users can:
      - Manipulate fit objects without needing to convert arrays into
        rectangular form.
      - Generate task specifc subsets of the parent fit object for fit
        diagnostics and post-processing
      - Use pipe operators to create more user-friendly workflows
      - Manipulate various classes that contain a `stanfit` object, such
        as `rstan` and `brms`.
  - RStudio specific feature: Tab autocomplete in
    `shredder::stan_select` and `shredder::stan_filter` for the
    parameter names stored in the fit object.

## Installation

``` r
remotes::install_github('metrumresearchgroup/shredder')
```

## Current API Verbs

  - Dimension
      - chains
          - `shredder::stan_retain` : extract specific chains
      - pars
          - `shredder::stan_select` : extract specific pars
          - `shredder::stan_contains`,
            `shredder::stan_starts_with`,`shredder::stan_ends_with`:
            partial par extractions (used within
            `shredder::stan_select`)
          - `shredder::stan_names` : return names within the stanfit
            object
      - post-warmup samples
          - `shredder::stan_slice` : extract specific samples by index
          - `shredder::stan_sample_n` : extract random n samples
          - `shredder::stan_sample_frac` : extract fraction of total
            samples
          - `shredder::stan_filter` : extract subset of samples
            conditional on filter of parameter values

## Code of Conduct

Please note that the ‘shredder’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.

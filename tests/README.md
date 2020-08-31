Tests and Coverage
================
31 August, 2020 11:06:24

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/metrumresearchgroup/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                   | Coverage (%) |
| :--------------------------------------- | :----------: |
| shredder                                 |    74.51     |
| [R/rats\_example.R](../R/rats_example.R) |     0.00     |
| [R/complete.R](../R/complete.R)          |    12.50     |
| [R/zzz.R](../R/zzz.R)                    |    50.00     |
| [R/stan\_thin.R](../R/stan_thin.R)       |    57.14     |
| [R/utils.R](../R/utils.R)                |    66.67     |
| [R/stan\_names.R](../R/stan_names.R)     |    80.00     |
| [R/stan\_retain.R](../R/stan_retain.R)   |    91.30     |
| [R/stan\_select.R](../R/stan_select.R)   |    92.31     |
| [R/stan\_slice.R](../R/stan_slice.R)     |    93.94     |
| [R/stan\_filter.R](../R/stan_filter.R)   |    96.23     |
| [R/partials.R](../R/partials.R)          |    100.00    |
| [R/stan\_axe.R](../R/stan_axe.R)         |    100.00    |
| [R/stan\_utils.R](../R/stan_utils.R)     |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                        |  n |  time | error | failed | skipped | warning |
| :------------------------------------------ | -: | ----: | ----: | -----: | ------: | ------: |
| [test-axe.R](testthat/test-axe.R)           |  2 | 0.016 |     0 |      0 |       0 |       0 |
| [test-filter.R](testthat/test-filter.R)     |  7 | 0.209 |     0 |      0 |       0 |       0 |
| [test-names.R](testthat/test-names.R)       |  2 | 0.003 |     0 |      0 |       0 |       0 |
| [test-retain.R](testthat/test-retain.R)     |  6 | 0.376 |     0 |      0 |       0 |       0 |
| [test-sampling.R](testthat/test-sampling.R) |  7 | 0.257 |     0 |      0 |       0 |       0 |
| [test-select.R](testthat/test-select.R)     | 15 | 0.368 |     0 |      0 |       0 |       0 |
| [test-slice.R](testthat/test-slice.R)       |  5 | 0.328 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results </summary>

| file                                            | context  | test                               | status | n |  time |
| :---------------------------------------------- | :------- | :--------------------------------- | :----- | -: | ----: |
| [test-axe.R](testthat/test-axe.R#L11)           | axe      | axe elements: no fit\_instance     | PASS   | 1 | 0.015 |
| [test-axe.R](testthat/test-axe.R#L16)           | axe      | axe elements: no stanmodel         | PASS   | 1 | 0.001 |
| [test-filter.R](testthat/test-filter.R#L9)      | filter   | filters: default                   | PASS   | 1 | 0.021 |
| [test-filter.R](testthat/test-filter.R#L14)     | filter   | filters: not permuted              | PASS   | 1 | 0.020 |
| [test-filter.R](testthat/test-filter.R#L18)     | filter   | filters: not permuted              | PASS   | 1 | 0.011 |
| [test-filter.R](testthat/test-filter.R#L23)     | filter   | filters: indexed name              | PASS   | 1 | 0.011 |
| [test-filter.R](testthat/test-filter.R#L30)     | filter   | filters: compound query            | PASS   | 1 | 0.009 |
| [test-filter.R](testthat/test-filter.R#L34)     | filter   | filters: no samples                | PASS   | 1 | 0.007 |
| [test-filter.R](testthat/test-filter.R#L38)     | filter   | filters: invalid pars              | PASS   | 1 | 0.130 |
| [test-names.R](testthat/test-names.R#L9)        | names    | names: default                     | PASS   | 1 | 0.002 |
| [test-names.R](testthat/test-names.R#L14)       | names    | names: expand                      | PASS   | 1 | 0.001 |
| [test-retain.R](testthat/test-retain.R#L8)      | retain   | retain: default                    | PASS   | 1 | 0.003 |
| [test-retain.R](testthat/test-retain.R#L13)     | retain   | retain: null                       | PASS   | 1 | 0.353 |
| [test-retain.R](testthat/test-retain.R#L18)     | retain   | retain: single                     | PASS   | 1 | 0.002 |
| [test-retain.R](testthat/test-retain.R#L23)     | retain   | retain: multiple                   | PASS   | 1 | 0.001 |
| [test-retain.R](testthat/test-retain.R#L28)     | retain   | retain: all                        | PASS   | 1 | 0.001 |
| [test-retain.R](testthat/test-retain.R#L32)     | retain   | retain: bad                        | PASS   | 1 | 0.016 |
| [test-sampling.R](testthat/test-sampling.R#L10) | sampling | slice: default                     | PASS   | 1 | 0.232 |
| [test-sampling.R](testthat/test-sampling.R#L15) | sampling | slice: no warmup                   | PASS   | 1 | 0.003 |
| [test-sampling.R](testthat/test-sampling.R#L21) | sampling | slice: bad indexs                  | PASS   | 2 | 0.008 |
| [test-sampling.R](testthat/test-sampling.R#L32) | sampling | thinning: thin\_n                  | PASS   | 1 | 0.005 |
| [test-sampling.R](testthat/test-sampling.R#L37) | sampling | thinning: thin\_frac               | PASS   | 1 | 0.005 |
| [test-sampling.R](testthat/test-sampling.R#L42) | sampling | thinning: no warmup                | PASS   | 1 | 0.004 |
| [test-select.R](testthat/test-select.R#L6)      | select   | names: no pars                     | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L11)     | select   | names: single par                  | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L16)     | select   | names: multiple pars               | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L21)     | select   | names: par index                   | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L26)     | select   | names: character par               | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L31)     | select   | names: character par syms          | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L37)     | select   | names: regex character pars        | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L44)     | select   | names: remove summary              | PASS   | 1 | 0.336 |
| [test-select.R](testthat/test-select.R#L52)     | select   | partials: no pars                  | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L57)     | select   | partials: starts\_with             | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L62)     | select   | partials: ends\_with               | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L67)     | select   | partials: starts\_contains         | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L72)     | select   | partials: mixed                    | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L77)     | select   | partials: par regex index          | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L82)     | select   | partials: par regex multiple index | PASS   | 1 | 0.002 |
| [test-slice.R](testthat/test-slice.R#L7)        | slice    | slice: empty                       | PASS   | 1 | 0.312 |
| [test-slice.R](testthat/test-slice.R#L12)       | slice    | slice: single                      | PASS   | 1 | 0.004 |
| [test-slice.R](testthat/test-slice.R#L17)       | slice    | slice: single no warmup            | PASS   | 1 | 0.003 |
| [test-slice.R](testthat/test-slice.R#L22)       | slice    | slice: vector                      | PASS   | 1 | 0.004 |
| [test-slice.R](testthat/test-slice.R#L27)       | slice    | slice: reset permut                | PASS   | 1 | 0.005 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                             |                                                                                                                                                                                                                                                                  |
| :------- | :-------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Version  | R version 4.0.2 (2020-06-22)      |                                                                                                                                                                                                                                                                  |
| Platform | x86\_64-apple-darwin17.0 (64-bit) | <a href="https://github.com/yonicd/shredder/commit/32e86777617a11d624a77f5dd883b8be372e3aa4/checks" target="_blank"><span title="Built on Github Actions">![](https://github.com/metrumresearchgroup/covrpage/blob/actions/inst/logo/gh.png?raw=true)</span></a> |
| Running  | macOS Catalina 10.15.6            |                                                                                                                                                                                                                                                                  |
| Language | en\_US                            |                                                                                                                                                                                                                                                                  |
| Timezone | UTC                               |                                                                                                                                                                                                                                                                  |

| Package  | Version |
| :------- | :------ |
| testthat | 2.3.2   |
| covr     | 3.3.2   |
| covrpage | 0.0.71  |

</details>

<!--- Final Status : pass --->

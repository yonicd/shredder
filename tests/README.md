Tests and Coverage
================
17 November, 2019 11:13:13

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/metrumresearchgroup/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                   | Coverage (%) |
| :--------------------------------------- | :----------: |
| shredder                                 |    76.24     |
| [R/rats\_example.R](../R/rats_example.R) |     0.00     |
| [R/complete.R](../R/complete.R)          |    13.33     |
| [R/utils.R](../R/utils.R)                |    50.00     |
| [R/zzz.R](../R/zzz.R)                    |    50.00     |
| [R/stan\_names.R](../R/stan_names.R)     |    80.00     |
| [R/stan\_sample.R](../R/stan_sample.R)   |    89.74     |
| [R/stan\_keep.R](../R/stan_keep.R)       |    91.30     |
| [R/stan\_slice.R](../R/stan_slice.R)     |    93.94     |
| [R/stan\_select.R](../R/stan_select.R)   |    94.59     |
| [R/stan\_filter.R](../R/stan_filter.R)   |    95.24     |
| [R/partials.R](../R/partials.R)          |    100.00    |
| [R/stan\_utils.R](../R/stan_utils.R)     |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat)
package.

| file                                        |  n |  time | error | failed | skipped | warning |
| :------------------------------------------ | -: | ----: | ----: | -----: | ------: | ------: |
| [test-filter.R](testthat/test-filter.R)     |  6 | 0.079 |     0 |      0 |       0 |       0 |
| [test-keep.R](testthat/test-keep.R)         |  6 | 0.720 |     0 |      0 |       0 |       0 |
| [test-names.R](testthat/test-names.R)       |  2 | 0.002 |     0 |      0 |       0 |       0 |
| [test-sampling.R](testthat/test-sampling.R) |  7 | 0.270 |     0 |      0 |       0 |       0 |
| [test-select.R](testthat/test-select.R)     | 14 | 0.267 |     0 |      0 |       0 |       0 |
| [test-slice.R](testthat/test-slice.R)       |  5 | 0.526 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results
</summary>

| file                                            | context | test                               | status | n |  time |
| :---------------------------------------------- | :------ | :--------------------------------- | :----- | -: | ----: |
| [test-filter.R](testthat/test-filter.R#L9)      | filter  | filters: default                   | PASS   | 1 | 0.006 |
| [test-filter.R](testthat/test-filter.R#L14)     | filter  | filters: different chain           | PASS   | 1 | 0.040 |
| [test-filter.R](testthat/test-filter.R#L19)     | filter  | filters: indexed name              | PASS   | 1 | 0.022 |
| [test-filter.R](testthat/test-filter.R#L23)     | filter  | filters: no samples                | PASS   | 1 | 0.005 |
| [test-filter.R](testthat/test-filter.R#L27)     | filter  | filters: invalid pars              | PASS   | 1 | 0.003 |
| [test-filter.R](testthat/test-filter.R#L31)     | filter  | filters: invalid chain             | PASS   | 1 | 0.003 |
| [test-keep.R](testthat/test-keep.R#L8)          | keep    | keep: default                      | PASS   | 1 | 0.002 |
| [test-keep.R](testthat/test-keep.R#L13)         | keep    | keep: null                         | PASS   | 1 | 0.713 |
| [test-keep.R](testthat/test-keep.R#L18)         | keep    | keep: single                       | PASS   | 1 | 0.002 |
| [test-keep.R](testthat/test-keep.R#L23)         | keep    | keep: multiple                     | PASS   | 1 | 0.001 |
| [test-keep.R](testthat/test-keep.R#L28)         | keep    | keep: all                          | PASS   | 1 | 0.001 |
| [test-keep.R](testthat/test-keep.R#L32)         | keep    | keep: bad                          | PASS   | 1 | 0.001 |
| [test-names.R](testthat/test-names.R#L9)        | names   | names: default                     | PASS   | 1 | 0.001 |
| [test-names.R](testthat/test-names.R#L14)       | names   | names: expand                      | PASS   | 1 | 0.001 |
| [test-sampling.R](testthat/test-sampling.R#L10) | slicing | slice: default                     | PASS   | 1 | 0.206 |
| [test-sampling.R](testthat/test-sampling.R#L15) | slicing | slice: no warmup                   | PASS   | 1 | 0.026 |
| [test-sampling.R](testthat/test-sampling.R#L21) | slicing | slice: bad indexs                  | PASS   | 2 | 0.008 |
| [test-sampling.R](testthat/test-sampling.R#L32) | slicing | sample: sample\_n                  | PASS   | 1 | 0.006 |
| [test-sampling.R](testthat/test-sampling.R#L37) | slicing | sample: sample\_frac               | PASS   | 1 | 0.021 |
| [test-sampling.R](testthat/test-sampling.R#L42) | slicing | sample: no warmup                  | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L6)      | select  | names: no pars                     | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L11)     | select  | names: single par                  | PASS   | 1 | 0.032 |
| [test-select.R](testthat/test-select.R#L16)     | select  | names: multiple pars               | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L21)     | select  | names: par index                   | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L26)     | select  | names: character pars              | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L33)     | select  | names: regex character pars        | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L40)     | select  | names: remove summary              | PASS   | 1 | 0.211 |
| [test-select.R](testthat/test-select.R#L48)     | select  | partials: no pars                  | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L53)     | select  | partials: starts\_with             | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L58)     | select  | partials: ends\_with               | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L63)     | select  | partials: starts\_contains         | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L68)     | select  | partials: mixed                    | PASS   | 1 | 0.001 |
| [test-select.R](testthat/test-select.R#L73)     | select  | partials: par regex index          | PASS   | 1 | 0.001 |
| [test-select.R](testthat/test-select.R#L78)     | select  | partials: par regex multiple index | PASS   | 1 | 0.001 |
| [test-slice.R](testthat/test-slice.R#L7)        | slice   | slice: empty                       | PASS   | 1 | 0.514 |
| [test-slice.R](testthat/test-slice.R#L12)       | slice   | slice: single                      | PASS   | 1 | 0.004 |
| [test-slice.R](testthat/test-slice.R#L17)       | slice   | slice: single no warmup            | PASS   | 1 | 0.002 |
| [test-slice.R](testthat/test-slice.R#L22)       | slice   | slice: vector                      | PASS   | 1 | 0.003 |
| [test-slice.R](testthat/test-slice.R#L27)       | slice   | slice: reset permut                | PASS   | 1 | 0.003 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                               |
| :------- | :---------------------------------- |
| Version  | R version 3.6.1 (2019-07-05)        |
| Platform | x86\_64-apple-darwin15.6.0 (64-bit) |
| Running  | macOS Mojave 10.14.5                |
| Language | en\_US                              |
| Timezone | America/New\_York                   |

| Package  | Version |
| :------- | :------ |
| testthat | 2.2.1   |
| covr     | 3.3.0   |
| covrpage | 0.0.70  |

</details>

<!--- Final Status : pass --->

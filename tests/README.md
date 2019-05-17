Tests and Coverage
================
16 May, 2019 15:48:40

  - [Coverage](#coverage)
  - [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/metrumresearchgroup/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                            | Coverage (%) |
| :------------------------------------------------ | :----------: |
| shredder                                          |    90.96     |
| [R/rats\_example.R](../R/rats_example.R)          |     0.00     |
| [R/stan\_split.R](../R/stan_split.R)              |    90.91     |
| [R/partials.R](../R/partials.R)                   |    100.00    |
| [R/stan\_filter.R](../R/stan_filter.R)            |    100.00    |
| [R/stan\_sample\_frac.R](../R/stan_sample_frac.R) |    100.00    |
| [R/stan\_sample\_n.R](../R/stan_sample_n.R)       |    100.00    |
| [R/stan\_select.R](../R/stan_select.R)            |    100.00    |
| [R/stan\_slice.R](../R/stan_slice.R)              |    100.00    |
| [R/stan\_utils.R](../R/stan_utils.R)              |    100.00    |
| [R/utils.R](../R/utils.R)                         |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat)
package.

| file                                        | n |  time | error | failed | skipped | warning |
| :------------------------------------------ | -: | ----: | ----: | -----: | ------: | ------: |
| [test-filter.R](testthat/test-filter.R)     | 5 | 0.026 |     0 |      0 |       0 |       0 |
| [test-names.R](testthat/test-names.R)       | 2 | 0.003 |     0 |      0 |       0 |       0 |
| [test-sampling.R](testthat/test-sampling.R) | 6 | 0.266 |     0 |      0 |       0 |       0 |
| [test-select.R](testthat/test-select.R)     | 9 | 0.280 |     0 |      0 |       0 |       0 |
| [test-split.R](testthat/test-split.R)       | 4 | 0.245 |     0 |      0 |       0 |       0 |

<details closed>

<summary> Show Detailed Test Results
</summary>

| file                                            | context | test                       | status | n |  time |
| :---------------------------------------------- | :------ | :------------------------- | :----- | -: | ----: |
| [test-filter.R](testthat/test-filter.R#L9)      | filter  | filters: default           | PASS   | 1 | 0.007 |
| [test-filter.R](testthat/test-filter.R#L14)     | filter  | filters: different chain   | PASS   | 1 | 0.006 |
| [test-filter.R](testthat/test-filter.R#L19)     | filter  | filters: indexed name      | PASS   | 1 | 0.007 |
| [test-filter.R](testthat/test-filter.R#L23)     | filter  | filters: no samples        | PASS   | 1 | 0.004 |
| [test-filter.R](testthat/test-filter.R#L27)     | filter  | filters: no pars           | PASS   | 1 | 0.002 |
| [test-names.R](testthat/test-names.R#L9)        | names   | names: default             | PASS   | 1 | 0.002 |
| [test-names.R](testthat/test-names.R#L14)       | names   | names: expand              | PASS   | 1 | 0.001 |
| [test-sampling.R](testthat/test-sampling.R#L10) | slicing | slice: default             | PASS   | 1 | 0.210 |
| [test-sampling.R](testthat/test-sampling.R#L15) | slicing | slice: no warmup           | PASS   | 1 | 0.029 |
| [test-sampling.R](testthat/test-sampling.R#L21) | slicing | slice: bad indexs          | PASS   | 2 | 0.018 |
| [test-sampling.R](testthat/test-sampling.R#L32) | slicing | sample: sample\_n          | PASS   | 1 | 0.004 |
| [test-sampling.R](testthat/test-sampling.R#L37) | slicing | sample: sample\_frac       | PASS   | 1 | 0.005 |
| [test-select.R](testthat/test-select.R#L7)      | select  | names: single name         | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L12)     | select  | names: multiple names      | PASS   | 1 | 0.028 |
| [test-select.R](testthat/test-select.R#L17)     | select  | names: character names     | PASS   | 1 | 0.002 |
| [test-select.R](testthat/test-select.R#L23)     | select  | names: remove summary      | PASS   | 1 | 0.230 |
| [test-select.R](testthat/test-select.R#L31)     | select  | partials: no pars          | PASS   | 1 | 0.004 |
| [test-select.R](testthat/test-select.R#L36)     | select  | partials: starts\_with     | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L41)     | select  | partials: ends\_with       | PASS   | 1 | 0.003 |
| [test-select.R](testthat/test-select.R#L46)     | select  | partials: starts\_contains | PASS   | 1 | 0.004 |
| [test-select.R](testthat/test-select.R#L51)     | select  | partials: mixed            | PASS   | 1 | 0.003 |
| [test-split.R](testthat/test-split.R#L7)        | split   | names: default             | PASS   | 1 | 0.162 |
| [test-split.R](testthat/test-split.R#L12)       | split   | names: specify cut         | PASS   | 1 | 0.066 |
| [test-split.R](testthat/test-split.R#L17)       | split   | names: no warmup           | PASS   | 2 | 0.017 |

</details>

<details>

<summary> Session Info </summary>

| Field    | Value                               |
| :------- | :---------------------------------- |
| Version  | R version 3.5.1 (2018-07-02)        |
| Platform | x86\_64-apple-darwin15.6.0 (64-bit) |
| Running  | macOS 10.14.4                       |
| Language | en\_US                              |
| Timezone | America/New\_York                   |

| Package  | Version |
| :------- | :------ |
| testthat | 2.0.1   |
| covr     | 3.2.1   |
| covrpage | 0.0.70  |

</details>

<!--- Final Status : pass --->

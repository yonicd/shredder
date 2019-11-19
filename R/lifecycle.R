#' Life cycle of the shredder package
#'
#' @description
#'
#' \lifecycle{maturing}
#'
#' The shredder package is currently maturing. Unless otherwise stated,
#' this applies to all its exported functions. Maturing functions are
#' susceptible to API changes. Only use these in packages if you're
#' prepared to make changes as the package evolves. See sections below
#' for a list of functions marked as stable.
#'
#' The documentation pages of retired functions contain life cycle
#' sections that explain the reasons for their retirements.
#'
#'
#' @section Stable functions:
#'
#' \lifecycle{stable}
#'
#' * [stan_retain()]
#' * [stan_select()]
#' * [stan_contains()], [stan_starts_with()], [stan_ends_with()]
#' * [stan_names()]
#' * [stan_slice()]
#' * [stan_sample_n()], [stan_sample_frac()]
#' 
#' \lifecycle{maturing}
#' 
#' * [stan_filter()]
#'
#' @keywords internal
#' @name lifecycle
NULL
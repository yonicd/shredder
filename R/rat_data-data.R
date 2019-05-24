#' @title rats model data
#' @description Data used in rats example model
#' @format A List containing 5 elements:
#' \describe{
#'   \item{\code{N}}{integer Number of subjects}
#'   \item{\code{T}}{integer Number of measurements}
#'   \item{\code{x}}{numeric Day of measurement}
#'   \item{\code{Y}}{tibble Values of measurements}
#'   \item{\code{xbar}}{numeric Mean days of measurements} 
#'}
#' @source [Data Description](https://www.mrc-bsu.cam.ac.uk/wp-content/uploads/WinBUGS_Vol1.pdf), 
#'   [Data and Script](https://github.com/stan-dev/example-models/tree/master/bugs_examples/vol1/rats)
#' @docType data
#' @family examples
"rat_data"
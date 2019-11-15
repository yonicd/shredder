.onLoad <- function(lib,pkg) {
  rc.options(custom.completer = completeme)
  register_completion(thispkg = populate)
}

.onAttach <- function(lib,pkg) {
  rc.options(custom.completer = completeme)
  register_completion(thispkg = populate)
}

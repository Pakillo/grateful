#' Get citations for packages
#'
#' @param pkgs Character vector of package names, e.g. as produced by \code{scan_packages}.
#' @param filename Optional. Name of BibTeX file containing packages references.
#'
#' @return Nothing by default. If assigned a name, a list with package citations in BibTeX format. Optionally, a file with references in BibTeX format.
#' @export
#' @import utils
#'
#' @examples
#' library(grateful)
#' pkgs <- scan_packages()
#' cites <- get_citations(pkgs)
get_citations <- function(pkgs, filename = NULL) {

  cites <- lapply(pkgs, utils::citation)
  cites.bib <- lapply(cites, utils::toBibtex)

  if (!is.null(filename)) writeLines(unlist(cites.bib), con = filename)

  invisible(cites.bib)
}

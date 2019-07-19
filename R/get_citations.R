#' Get citations for packages
#'
#' @param pkgs Character vector of package names, e.g. as produced by \code{scan_packages}.
#' @param filename Optional. Name of BibTeX file containing packages references.
#' @param out.dir Directory to save the BibTeX file with the references. Defaults to working directory.
#'
#' @return Nothing by default. If assigned a name, a list with package citations in BibTeX format. Optionally, a file with references in BibTeX format.
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#' pkgs <- scan_packages()
#' cites <- get_citations(pkgs)
#' }
get_citations <- function(pkgs, filename = "pkg-refs.bib", out.dir = getwd()) {

  cites <- lapply(pkgs, utils::citation)
  cites.bib <- lapply(cites, utils::toBibtex)

  # generate reference key
  for (i in seq_len(length(cites.bib))) {
    cites.bib[[i]] <- sub(pattern = "\\{,$", replacement = paste0("{", pkgs[i], ","), x = cites.bib[[i]])
  }

  ## write bibtex references to file
  writeLines(enc2utf8(unlist(cites.bib)), con = file.path(out.dir, filename), useBytes = TRUE)

  ## return named list of bibtex references
  names(cites.bib) <- pkgs
  invisible(cites.bib)

}

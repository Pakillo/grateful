#' Get citations for packages
#'
#' @param pkgs Character vector of package names, e.g. as produced by \code{scan_packages}.
#' @param filename Optional. Name of BibTeX file containing packages references.
#' @param out.dir Directory to save the BibTeX file with the references. Defaults to working directory.
#' @param includeRStudio Logical. If TRUE, adds a citation for the current version of RStudio, if run within RStudio interactively.
#'
#' @return Nothing by default. If assigned a name, a list with citation keys for each citation (without). Optionally, a file with references in BibTeX format.
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#' pkgs <- scan_packages()
#' cites <- get_citations(pkgs)
#' }
get_citations <- function(pkgs, filename = "pkg-refs.bib",
                          out.dir = getwd(), includeRStudio = FALSE) {

  cites.bib <- lapply(cit.list, get_citation_and_citekey)

  if (includeRStudio == TRUE) {
    # Put an RStudio citation on the end
    cites.bib[[length(cites.bib) + 1]] <- add_citekey("rstudio", RStudio.Version()$citation)
  }

  ## write bibtex references to file
  writeLines(enc2utf8(unlist(cites.bib)), con = file.path(out.dir, filename), useBytes = TRUE)

  # get the citekeys and format them appropriately before returning them
  citekeys <- unname(grep("\\{[[:alnum:]]+,$", unlist(cites.bib), value = TRUE))
  citekeys <- gsub(".*\\{([[:alnum:]]+),$", "\\1", citekeys)
  invisible(citekeys)
}

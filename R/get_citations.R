#' Get citations for packages
#'
#' @param pkgs Character vector of package names, e.g. as produced by
#'   \code{scan_packages}.
#' @param out.dir Directory to save the BibTeX file with the references.
#'   Defaults to working directory.
#' @param bibfile Name of the file to save the package BibTeX references.
#' @param include.RStudio Logical. If TRUE, adds a citation for the current
#'   version of RStudio, if run within RStudio interactively.
#'
#' @return A file on the specified \code{out.dir} containing the package references in BibTeX
#'   format. If assigned a name, \code{get_citations} will also return a list with citation keys for
#'   each citation (without @@).
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#' pkgs <- scan_packages()
#' cites <- get_citations(pkgs)
#' }
get_citations <- function(pkgs,
                          out.dir = getwd(),
                          bibfile = "pkg-refs.bib",
                          include.RStudio = FALSE) {

  cites.bib <- lapply(pkgs, get_citation_and_citekey)

  if (include.RStudio == TRUE) {
    # Put an RStudio citation on the end

    if (!require(rstudioapi)) {
      stop("Please install the {rstudioapi} package to cite RStudio.")
    } else {
      rstudio_cit <- tryCatch(rstudioapi::versionInfo()$citation,
                              error = function(e) NULL)
      if (!is.null(rstudio_cit)) {
        cites.bib[[length(cites.bib) + 1]] <- add_citekey("rstudio", rstudio_cit)
      }
    }

  }

  ## write bibtex references to file
  writeLines(enc2utf8(unlist(cites.bib)), con = file.path(out.dir, bibfile),
             useBytes = TRUE)

  # get the citekeys and format them appropriately before returning them
  citekeys <- unname(grep("\\{[[:alnum:]]+,$", unlist(cites.bib), value = TRUE))
  citekeys <- gsub(".*\\{([[:alnum:]]+),$", "\\1", citekeys)
  invisible(citekeys)
}

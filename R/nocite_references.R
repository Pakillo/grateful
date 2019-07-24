#' Generate Nocite Block
#'
#' Include a metadata block of citation keys for including citations in
#' references file without in-text citations.
#'
#' When passed a list of citation keys, adds the @@ to each, then builds the
#' nocite metadata field, returning via "as-is" output. Run this function either
#' inline or within a code chunk (with \code{echo = FALSE}) to include this
#' metadata block within an RMarkdown document. The code chunk need not
#' explicitly state \code{results = 'asis'}.
#'
#' This function is intended to cite R packages with citation keys passed from
#' \code{\link{get_citations}}, but can accept an arbitrary vector of
#' citation keys (without @@) found in a BibTeX file referenced in the YAML
#' header.
#'
#' @param citekeys Vector of citation keys in reference to a relevant BibTex
#'   file.
#'
#' @return "As is" text of metadata block, with comma-separated list of citation
#'   keys.
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#'
#' # include in YAML header:
#' bibliography: pkg-refs.bib
#'
#' # Get citation keys for the current RMarkdown document
#' # (run after all packages have been loaded).
#' citekeys <- cite_packages(generate.document = FALSE, all.pkgs = FALSE)
#'
#' # Include in RMarkdown body:
#' `r nocite_references(citekeys)`
#' }
nocite_references <- function(citekeys) {
  nocites <- paste0("@", citekeys, collapse = ", ")
  nocite_block <- c("---\nnocite: |\n\t", nocites, "\n...")
  asis_output(nocite_block)
}

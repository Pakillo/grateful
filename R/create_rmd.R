#' Create template rmarkdown file with package citations
#'
#' @param bib.list List of package citations in BibTeX format, as produced by \code{get_citations}.
#' @param bibfile Name of the file containing references in BibTeX format, as produced by \code{get_citations}.
#' @param csl Optional. Citation style to format references. See \url{http://citationstyles.org/styles/}.
#' @param filename Name of the rmarkdown file
#'
#' @return An rmarkdown file
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#' pkgs <- scan_packages()
#' cites <- get_citations(pkgs)
#' rmd <- create_rmd(cites)
#' }
create_rmd <- function(bib.list, bibfile = "pkg-refs.bib", csl = NULL,
                       filename = "refs.Rmd", out.dir = getwd()) {

  use.csl <- ifelse(is.null(csl), "#csl: null", "csl: ")

  # ensure CSL file is available, otherwise download
  if (!is.null(csl))
    if (!file.exists(file.path(out.dir, paste0(csl, ".csl")))) get_csl(csl)

  if (out.dir != getwd()) {
    bibfile = file.path(out.dir, bibfile)
    csl = file.path(out.dir, csl)
    filename = file.path(out.dir, filename)
  }

  yaml.header <- c(
    "---",
    "title: R packages used",
    paste0("bibliography: ", bibfile),
    paste0(use.csl, csl, ".csl"),
    "---",
    "")


  ## list package citations
  plist <- paste("- ", names(bib.list), " [@", names(bib.list), "]", sep = "")


  ## write Rmd to disk
  writeLines(c(yaml.header, plist, "", "## References"), con = filename)

  ## Return Rmd filename
  filename

}

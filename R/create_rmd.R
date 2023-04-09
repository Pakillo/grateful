#' Create template Rmarkdown file with package citations
#'
#' @param pkgs.df Data.frame with package names, versions, and citation keys,
#' as produced by [get_pkgs_info()].
#' @param bib.file Name of the file containing references in BibTeX format,
#' as produced by [get_pkgs_info()].
#' @param csl Optional. Citation style to format references.
#' See <https://www.zotero.org/styles>.
#' @param out.format Output format. One of: "html", docx" (Word), "pdf", "Rmd", or "md" (markdown).
#' @param Rmd.file Name of the Rmarkdown file to be created.
#' @param out.dir Directory to save the output document. Default is the working directory.
#' @param include.RStudio Include RStudio?
#' @param ... Further arguments for [render_citations()].
#'
#' @return An Rmarkdown file, if out.format = "Rmd", or a rendered document otherwise.
#' @noRd
#'

create_rmd <- function(pkgs.df = NULL,
                       bib.file = "grateful-refs.bib",
                       csl = NULL,
                       Rmd.file = "grateful-report.Rmd",
                       out.format = c("html", "docx", "pdf", "Rmd", "md"),
                       out.dir = getwd(),
                       include.RStudio = FALSE,
                       ...) {

  out.format <- match.arg(out.format)

  use.csl <- ifelse(is.null(csl), "#csl: null", "csl: ")

  # ensure CSL file is available, otherwise download
  if (!is.null(csl)) {
    if (!file.exists(file.path(out.dir, paste0(csl, ".csl")))) {
      get_csl(csl)
    }
  }

  if (out.dir != getwd()) {
    bibfile <- file.path(out.dir, bib.file)
    csl <- file.path(out.dir, csl)
    filename <- file.path(out.dir, Rmd.file)
  }

  yaml.header <- c(
    "---",
    'title: "`grateful` citation report"',
    paste0("bibliography: ", bib.file),
    paste0(use.csl, csl, ".csl"),
    "---",
    "")

  table <- knitr::asis_output(knitr::kable(output_table(pkgs.df)))

  parag <- write_citation_paragraph(pkgs.df, include.RStudio = include.RStudio)

  ## write Rmd to disk
  writeLines(c(yaml.header,
               "## R packages used",
               "",
               table,
               "",
               "**You can paste this paragraph directly in your report:**",
               "",
               parag,
               "",
               "## Package citations",
               ""),
             con = Rmd.file)

  if (tolower(out.format) == "rmd") {
    return(Rmd.file)
  } else {
    render_citations(Rmd.file, out.format = out.format, out.dir = out.dir, ...)
    file.remove(Rmd.file)
  }

}


#' Create template Rmarkdown file with package citations
#'
#' @param pkgs.df Data.frame with package names, versions, and citation keys,
#' as produced by [get_pkgs_info()].
#' @param out.dir Directory to save the output document.
#' @param bib.file Name of the file containing references in BibTeX format,
#' as produced by [get_pkgs_info()].
#' @param csl Optional. Citation style to format references.
#' See <https://www.zotero.org/styles>.
#' @param out.format Output format. One of: "html", docx" (Word), "pdf", "Rmd", or "md" (markdown).
#' @param Rmd.file Name of the Rmarkdown file to be created.
#' @param include.RStudio Include RStudio?
#' @param passive.voice Logical. If `TRUE`, uses passive voice in any paragraph
#'   generated for citations.
#' @param ... Further arguments for [render_citations()]. Currently not used.
#'
#' @return An Rmarkdown file, if out.format = "Rmd", or a rendered document otherwise.
#' @noRd
#'

create_rmd <- function(pkgs.df = NULL,
                       out.dir = NULL,
                       bib.file = "grateful-refs",
                       csl = NULL,
                       Rmd.file = "grateful-report",
                       out.format = c("html", "docx", "pdf", "Rmd", "md"),
                       include.RStudio = FALSE,
                       passive.voice = FALSE,
                       ...) {

  if (is.null(pkgs.df)) {
    stop("pkgs.df must be provided")
  }

  if (is.null(out.dir)) {
    stop("Please specify where to save the citation report, e.g. out.dir = getwd()")
  }

  out.format <- match.arg(out.format)

  use.csl <- ifelse(is.null(csl), "#csl: null", "csl: ")

  # ensure CSL file is available, otherwise download
  if (!is.null(csl)) {
    if (!file.exists(file.path(out.dir, paste0(csl, ".csl")))) {
      get_csl(csl, out.dir = out.dir)
    }
  }


  bib.file <- paste0(bib.file, ".bib")
  Rmd.file <- paste0(Rmd.file, ".Rmd")

  if (out.dir != getwd()) {
    # bibfile <- file.path(out.dir, bib.file)
    # csl <- file.path(out.dir, csl)
    Rmd.file <- file.path(out.dir, Rmd.file)
  }

  yaml.header <- c(
    "---",
    'title: "`grateful` citation report"',
    paste0("bibliography: ", bib.file),
    paste0(use.csl, csl, ".csl"),
    "---",
    "")

  table <- knitr::asis_output(knitr::kable(output_table(pkgs.df)))

  parag <- write_citation_paragraph(pkgs.df,
                                    include.RStudio = include.RStudio,
                                    passive.voice = passive.voice)

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
    out.file <- Rmd.file
  } else {
    out.file <- render_citations(Rmd.file,
                                 out.format = out.format,
                                 out.dir = out.dir,
                                 ...)
    file.remove(Rmd.file)
  }

  invisible(out.file)

}


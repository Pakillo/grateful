#' Get a journal citation style from the official internet repository
#'
#' @param name Name of the journal,
#' exactly as found in <https://github.com/citation-style-language/styles>.
#' @param out.dir Directory to save the CSL file.
#'
#' @return The CSL file is saved in the selected directory, and the path is
#' returned invisibly.
#' @export
#'
#' @examplesIf interactive()
#' get_csl("peerj", out.dir = tempdir())

get_csl <- function(name = NULL, out.dir = NULL) {

  if (is.null(out.dir)) {
    stop("Please specify where you would like to save the CSL file, e.g. out.dir = getwd()")
  }

  styles.repo <- "https://raw.githubusercontent.com/citation-style-language/styles/master/"

  destfile <- file.path(out.dir, paste0(name, ".csl"))

  utils::download.file(paste0(styles.repo, name, ".csl"), mode = "wb",
                       destfile = destfile)

  invisible(destfile)
}

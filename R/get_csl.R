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

  if (is.null(name)) {
    stop("Please specify the journal name")
  }

  gsub("\\.csl", "", name)     # remove .csl from journal name

  if (is.null(out.dir)) {
    stop("Please specify where you would like to save the CSL file, e.g. out.dir = getwd()")
  }

  styles.repo <- "https://raw.githubusercontent.com/citation-style-language/styles/master/"

  destfile <- file.path(out.dir, paste0(name, ".csl"))

  # First try downloading CSL file from repo root
  # this will fail for styles hosted in the "dependent" subfolder
  out <- tryCatch(utils::download.file(paste0(styles.repo, name, ".csl"),
                                mode = "wb", destfile = destfile, quiet = TRUE),
           warning = function(w){})

  # if the style could not be downloaded, try the "dependent" folder
  if (is.null(out)) {
    out <- tryCatch(utils::download.file(paste0(styles.repo, "dependent/", name, ".csl"),
                                  mode = "wb", destfile = destfile, quiet = TRUE),
             warning = function(w){})
  }

  if (is.null(out)) {
    if (file.exists(destfile)) file.remove(destfile)
    stop("The citation style '", name, "' could not be downloaded. Please check the style name and your internet connection.")
  } else {
    destfile
  }

}

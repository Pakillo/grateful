#' Get a journal citation style from internet repository
#'
#' @param name Name of the journal, exactly as in <https://github.com/citation-style-language/styles>.
#'
#' @return The CSL file is saved in the working directory
#' @export
#'
#' @examples
#' \dontrun{
#' get_csl("peerj")
#' }
get_csl <- function(name) {
  styles.repo <- "https://raw.githubusercontent.com/citation-style-language/styles/master/"

  utils::download.file(paste0(styles.repo, name, ".csl"), mode = "wb",
                       destfile = file.path(getwd(), paste0(name, ".csl")))
}

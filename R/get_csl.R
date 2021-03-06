#' Get a journal citation style from internet repository
#'
#' @param name Name of the journal, exactly as in \url{https://github.com/citation-style-language/styles}.
#'
#' @return The CSL file is saved in the working directory
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#' get_csl("ecosistemas")
#' }
get_csl <- function(name) {

  styles.repo <- "https://raw.githubusercontent.com/citation-style-language/styles/master/"

  download.file(paste0(styles.repo, name, ".csl"), mode = "wb",
                destfile = file.path(getwd(), paste0(name, ".csl")))
}

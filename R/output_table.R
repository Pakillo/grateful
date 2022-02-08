output_table <- function(pkgs.df) {

  pkgs.df$Citation <- lapply(pkgs.df$citekeys,
                             function(x) {
                               x <- sort(x)
                               ck <- paste0("@", x)
                               ck <- paste(ck, collapse = "; ")
                               ck})

  pkgs.df <- pkgs.df[, c("pkg", "version", "Citation")]
  names(pkgs.df) <- c("Package", "Version", "Citation")
  return(pkgs.df)

}

output_table <- function(pkgs.df, include.RStudio = FALSE) {

  pkgs.df$Citation <- lapply(pkgs.df$citekeys,
                             function(x) {
                               x <- sort(x)
                               ck <- paste0("@", x)
                               ck <- paste(ck, collapse = "; ")
                               ck})

  pkgs.df <- pkgs.df[, c("pkg", "version", "Citation")]
  names(pkgs.df) <- c("Package", "Version", "Citation")

  if (include.RStudio) {
    rstudio <- data.frame(Package = "RStudio",
                          Version = as.character(rstudioapi::versionInfo()$version),
                          Citation = "@rstudio")
    pkgs.df <- rbind(pkgs.df, rstudio)
  }

  return(pkgs.df)

}

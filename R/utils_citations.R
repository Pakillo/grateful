# for a name and a bibtex citation, cretae unique citekey for each citation
add_citekey <- function(pkg_name, citation_bibtex) {
  refbeginnings <- grep(pattern = "\\{,$", x = citation_bibtex)
  for (i in 1:length(refbeginnings)) {
    if (length(refbeginnings) == 1) {
      replaceString <- paste0("{", pkg_name, ",")
    } else {
      replaceString <- paste0("{", pkg_name, i, ",")
    }
    citation_bibtex[refbeginnings[i]] <- sub(pattern = "\\{,$", replacement = replaceString,
                                             x = citation_bibtex[refbeginnings[i]])
  }
  return(citation_bibtex)
}

# For a package, get the bibtex citation, then pass along the name and the bibtex
bibtex_and_name <- function(pkg_name) {
  refs <- utils::toBibtex(utils::citation(pkg_name))
  return(add_name(pkg_name, refs))
}

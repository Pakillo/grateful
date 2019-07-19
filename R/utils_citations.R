# for a name and citation, cretae unique citekey for each citation
add_citekey <- function(pkg_name, citation) {
  citation_bibtex <- utils::toBibtex(citation)
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

# For a package, get the citation, then pass along the name and citation
get_citation_and_citekey <- function(pkg_name) {
  return(add_name(pkg_name, utils::citation(pkg_name)))
}

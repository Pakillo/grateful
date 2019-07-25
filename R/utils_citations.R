# for a name and citation, create unique citekey for each citation
add_citekey <- function(pkg_name, citation) {
  citation_bibtex <- utils::toBibtex(citation)
  refbeginnings <- grep(pattern = "\\{,$", x = citation_bibtex)
  for (i in 1:length(refbeginnings)) {
    if (length(refbeginnings) == 1) {
      # only one citation, citekey = package name
      replace_string <- paste0("{", pkg_name, ",")
    } else if (length(unique(unlist(citation$year))) == length(unlist(citation$year))) {
      # multiple citations, unique years. citekey = packagename + year
      replace_string <- paste0("{", pkg_name, citation[[i]]$year, ",")
    } else {
      # multiple citations, duplicate years. citekey = packagename + year + letter
      replace_string <- paste0("{", pkg_name, citation[[i]]$year, letters[i], ",")
    }
    citation_bibtex[refbeginnings[i]] <- sub(pattern = "\\{,$", replacement = replace_string,
                                             x = citation_bibtex[refbeginnings[i]])
  }
  return(citation_bibtex)
}

# For a package, get the citation, remove special characters from the name,
# then pass along the name and citation
get_citation_and_citekey <- function(pkg_name) {
  pkgname_clean <- gsub("[^[:alnum:]]", "", pkg_name)
  return(add_citekey(pkgname_clean, utils::citation(pkg_name)))
}

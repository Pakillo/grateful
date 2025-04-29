# fix formatting of titles for bibtex
fix_title <- function(titlestring) {
  # maintain capitalization of package name at the beginning
  titlestring <- gsub("^ *title ?= ?\\{([a-zA-Z._]*):", "title = \\{\\{\\1\\}:", titlestring)
  # always capitalize "R"
  titlestring <- gsub(" r([^a-zA-Z0-9])", " \\{R\\}\\1", titlestring)
  # get opening and closing quotation marks right, and preserve capitalization
  titlestring <- gsub("[`']([^`']*)[`']", "`\\{\\1\\}'", titlestring)
  titlestring <- gsub('"([^"]*)"', "``\\{\\1\\}''", titlestring)
  return(titlestring)
}

# for a name and citation, create unique citekey for each citation
add_citekey <- function(pkg_name, citation) {
  # fix the titles with proper bibtex formatting
  citation_bibtex <- utils::toBibtex(citation)
  title_rows <- (names(citation_bibtex) == "title")
  citation_bibtex[title_rows] <- fix_title(citation_bibtex[title_rows])

  refbeginnings <- grep(pattern = "\\{[[:alnum:]_-]*,$", x = citation_bibtex)
  for (i in seq_along(refbeginnings)) {
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
    citation_bibtex[refbeginnings[i]] <- sub(pattern = "\\{[[:alnum:]_-]*,$",
                                             replacement = replace_string,
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

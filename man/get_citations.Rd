% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_citations.R
\name{get_citations}
\alias{get_citations}
\title{Get citations for packages}
\usage{
get_citations(
  pkgs = NULL,
  out.dir = NULL,
  bib.file = "grateful-refs",
  include.RStudio = FALSE
)
}
\arguments{
\item{pkgs}{Character vector of package names, e.g. obtained by \code{\link[=scan_packages]{scan_packages()}}.}

\item{out.dir}{Directory to save the output document and a BibTeX file with
the references. It is recommended to set \code{out.dir = getwd()}.}

\item{bib.file}{Desired name for the BibTeX file containing packages references
("grateful-refs" by default).}

\item{include.RStudio}{Logical. If \code{TRUE}, adds a citation for the
current version of RStudio.}
}
\value{
A file on the specified \code{out.dir} containing the package references
in BibTeX format. If assigned a name, \code{get_citations} will also return a list
with citation keys for each package (without @).
}
\description{
Get citations for packages
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
citekeys <- get_citations(c("knitr", "renv"), out.dir = tempdir())

pkgs <- scan_packages()
citekeys <- get_citations(pkgs$pkg, out.dir = tempdir())
\dontshow{\}) # examplesIf}
}

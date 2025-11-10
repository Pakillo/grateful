# Get citations for packages

Get citations for packages

## Usage

``` r
get_citations(
  pkgs = NULL,
  out.dir = NULL,
  bib.file = "grateful-refs",
  include.RStudio = FALSE,
  skip.missing = FALSE
)
```

## Arguments

- pkgs:

  Character vector of package names, e.g. obtained by
  [`scan_packages()`](https://pakillo.github.io/grateful/reference/scan_packages.md).

- out.dir:

  Directory to save the output document and a BibTeX file with the
  references. It is recommended to set `out.dir = getwd()`.

- bib.file:

  Desired name for the BibTeX file containing packages references
  ("grateful-refs" by default).

- include.RStudio:

  Logical. If `TRUE`, adds a citation for the current version of
  RStudio.

- skip.missing:

  Logical. If FALSE (the default), will return an error if some
  package(s) are used somewhere in the project but they are not
  currently installed. If TRUE, will skip those missing packages,
  issuing a warning. Note such packages will thus not be included in the
  citation list, even though they might have been used in the project.

## Value

A file on the specified `out.dir` containing the package references in
BibTeX format. If assigned a name, `get_citations` will also return a
list with citation keys for each package (without @).

## Examples

``` r
if (FALSE) { # interactive()
citekeys <- get_citations(c("knitr", "renv"), out.dir = tempdir())

pkgs <- scan_packages()
citekeys <- get_citations(pkgs$pkg, out.dir = tempdir())
}
```

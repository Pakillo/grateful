# Get information about packages used in a project

This function scans the project for R packages used, saves a BibTeX file
with package references, and returns a data frame with package names,
version, and citation keys.

## Usage

``` r
get_pkgs_info(
  pkgs = "All",
  out.dir = NULL,
  omit = c("grateful"),
  cite.tidyverse = TRUE,
  dependencies = FALSE,
  bib.file = "grateful-refs",
  include.RStudio = FALSE,
  desc.path = NULL,
  skip.missing = FALSE,
  ...
)
```

## Arguments

- pkgs:

  Character. Either "All" to include all packages used in scripts within
  the project/folder (the default), "Session" to include only packages
  used in the current session, or the path to an R script (including
  `.R` extension), 'Rmarkdown' (`.Rmd`) or 'Quarto' document (`qmd`) to
  scan only the packages used in that single script or document.
  Alternatively, `pkgs` can also be a character vector of package names
  to get citations for. To cite R as well as the given packages, include
  "base" in `pkgs` (see examples). Finally, `pkgs` can be a character
  vector of `Depends`, `Imports`, `Suggests`, `LinkingTo` and their
  combination, to obtain the dependencies of an R package as stated in
  its DESCRIPTION file (see `desc.path`). Note that in this case,
  package versions will be 'NA' unless required versions are stated in
  the DESCRIPTION file (e.g. 'testthat (\>= 3.0.0)'), and package
  citations will use the information from installed versions of those
  packages in the user computer.

- out.dir:

  Directory to save the BibTeX file with references. It is recommended
  to set `out.dir = getwd()`.

- omit:

  Character vector of package names to be omitted from the citation
  report. `grateful` is omitted by default. Use `omit = NULL` to include
  all packages.

- cite.tidyverse:

  Logical. If `TRUE`, all tidyverse packages (dplyr, ggplot2, etc) will
  be collapsed into a single citation of the 'tidyverse', as recommended
  by the tidyverse team.

- dependencies:

  Logical. Include the dependencies of your used packages? If `TRUE`,
  will include all the packages that your used packages depend on.

- bib.file:

  Desired name for the BibTeX file containing packages references
  ("grateful-refs" by default).

- include.RStudio:

  Logical. If `TRUE`, adds a citation for the current version of
  RStudio.

- desc.path:

  Optional. Path to the package DESCRIPTION file from which to parse the
  package dependencies (see `pkgs`). If NULL, will default to the
  working directory.

- skip.missing:

  Logical. If FALSE (the default), will return an error if some
  package(s) are used somewhere in the project but they are not
  currently installed. If TRUE, will skip those missing packages,
  issuing a warning. Note such packages will thus not be included in the
  citation list, even though they might have been used in the project.

- ...:

  Other parameters passed to
  [`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html).

## Value

A data.frame with package info, and a file containing package references
in BibTeX format.

## Examples

``` r
if (FALSE) { # interactive()
get_pkgs_info(out.dir = tempdir())
get_pkgs_info(pkgs = c("renv", "remotes"), out.dir = tempdir())
}
```

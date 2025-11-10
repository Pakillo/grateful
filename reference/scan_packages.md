# Scan a project or folder for packages used

Scan a project or folder for packages used

## Usage

``` r
scan_packages(
  pkgs = "All",
  omit = c("grateful"),
  cite.tidyverse = TRUE,
  dependencies = FALSE,
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

a data.frame with package names and versions

## Examples

``` r
if (FALSE) { # interactive()
scan_packages()
scan_packages(pkgs = "Session")
scan_packages(pkgs = c("renv", "remotes", "knitr"))
}
```

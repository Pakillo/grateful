# Cite R packages used in a project

Find R packages used in a project or package, create a BibTeX file of
references, and generate a document with formatted package citations.
Alternatively, `cite_packages` can be run directly within an 'R
Markdown' or 'Quarto' document to automatically include a paragraph
citing all used packages and generate a bibliography.

## Usage

``` r
cite_packages(
  output = c("file", "paragraph", "table", "citekeys"),
  out.dir = NULL,
  out.format = c("html", "docx", "pdf", "Rmd", "md", "tex-fragment", "tex-document"),
  citation.style = NULL,
  pkgs = "All",
  omit = c("grateful"),
  cite.tidyverse = TRUE,
  dependencies = FALSE,
  include.RStudio = FALSE,
  passive.voice = FALSE,
  text.start = NULL,
  text.pkgs = NULL,
  text.RStudio = NULL,
  out.file = "grateful-report",
  bib.file = "grateful-refs",
  desc.path = NULL,
  skip.missing = FALSE,
  ...
)
```

## Arguments

- output:

  Either

  - "file" to generate a separate document with formatted citations for
    all packages;

  - "paragraph" to return a paragraph with in-text citations of used
    packages, suitable to be used within an 'R Markdown' or 'Quarto'
    document;

  - "table" to return a table with package name, version, and citations,
    to be used in 'R Markdown' or 'Quarto';

  - "citekeys" to return a vector with citation keys.

  In all cases, a BibTeX file with package references is saved on disk
  (see `bib.file`).

- out.dir:

  Directory to save the output document and a BibTeX file with the
  references. It is recommended to set `out.dir = getwd()`.

- out.format:

  Output format when `output = "file"`: either "html" (the default),
  "docx" (Word), "pdf", "tex-fragment" (LaTeX fragment to be inserted
  into another LaTeX document), "tex-document" (full LaTeX document),
  "Rmd", or "md" (markdown). (Note that choosing "pdf" requires a
  working installation of LaTeX, see <https://yihui.org/tinytex/>).

- citation.style:

  Optional. Citation style to format references for a particular journal
  (see
  <https://bookdown.org/yihui/rmarkdown-cookbook/bibliography.html>). If
  the CSL is not available in `out.dir`, it will be downloaded
  automatically from the official [GitHub
  repository](https://github.com/citation-style-language/styles) using
  [`get_csl()`](https://pakillo.github.io/grateful/reference/get_csl.md).
  If using `cite_packages()` within an R Markdown or Quarto document,
  `citation.style` should be `NULL` (the default). The citation style
  should instead be defined in the YAML metadata of the document (see
  <https://pakillo.github.io/grateful/#using-grateful-with-rmarkdown-or-quarto>).

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

- include.RStudio:

  Logical. If `TRUE`, adds a citation for the current version of
  RStudio.

- passive.voice:

  Logical. If `TRUE`, uses passive voice in any paragraph generated for
  citations.

- text.start:

  Optional. Text string to use to start the citation paragraph. If NULL
  (the default), will use "We used" or "This work was completed using"
  if `passive.voice = TRUE`. Note this allows for customising the
  language of citation paragraphs.

- text.pkgs:

  Optional. Text string to use to introduce the packages used. If NULL
  (the default), will use "(and) the following R packages".

- text.RStudio:

  Optional. Text string to use to introduce RStudio. If NULL (the
  default), will use "running in".

- out.file:

  Desired name of the citation report to be created if
  `output = "file"`. Default is "grateful-report" (without extension).

- bib.file:

  Desired name for the BibTeX file containing packages references
  ("grateful-refs" by default).

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

If `output = "file"`, `cite_packages` will save a citation report in
`out.dir` with formatted citations, and `cite_packages` will return the
path to the citation report invisibly. If `output = "table"` or
`output = "paragraph"`, `cite_packages` will return a table or paragraph
with package citations suitable to be used within 'R Markdown' or
'Quarto' documents. A BibTeX file containing package references is saved
in all cases in `out.dir`.

## Details

`cite_packages` is a wrapper function that collects package names and
versions and saves their citation information in a BibTeX file (using
[`get_pkgs_info()`](https://pakillo.github.io/grateful/reference/get_pkgs_info.md)).

Then, the function is designed to handle different use cases:

If `output = "file"`, `cite_packages()` will generate an 'R Markdown'
file which includes a paragraph with in-text citations of all packages,
as well as a references list. This document can be knitted to various
formats via `out.format`. References can be formatted for a particular
journal using `citation.style`. Thus, `output = "file"` is best for
obtaining a document separate from R, to just cut and paste citations.

If `output = "paragraph"`, `cite_packages()` will return a paragraph
with in-text citations of all packages, suitable to be used directly in
an 'R Markdown' or 'Quarto' document. To do so, include a reference to
the generated `bib.file` bibliography file in the YAML header of the
document (see
<https://pakillo.github.io/grateful/index.html#using-grateful-within-rmarkdown>).

Alternatively, if `output = "table"`, `cite_packages()` will return a
table with package names, versions, and citations. Thus, if using 'R
Markdown' or 'Quarto', you can choose between getting a table or a text
paragraph citing all packages.

Finally, you can use `output = "citekeys"` to obtain a vector of
citation keys, and then call
[`nocite_references()`](https://pakillo.github.io/grateful/reference/nocite_references.md)
within an 'R Markdown' or 'Quarto' document to cite these packages in
the reference list without mentioning them in the text.

## Limitations

Citation keys are not guaranteed to be preserved when regenerated,
particularly when packages are updated. This instability is not an issue
when citations are used programmatically, as in the example below. But
if references are put into the text manually, they may need to be
updated periodically.

## Examples

``` r
if (FALSE) { # interactive()

# To build a standalone document for citations
cite_packages(out.dir = tempdir())

# Format references for a particular journal:
cite_packages(citation.style = "peerj", out.dir = tempdir())

# Choose different output format:
cite_packages(out.format = "docx", out.dir = tempdir())

# Cite only packages currently loaded:
cite_packages(pkgs = "Session", out.dir = tempdir())

# Cite only user-provided packages:
cite_packages(pkgs = c("renv", "remotes", "knitr"), out.dir = tempdir())

# Cite R as well as user-provided packages
cite_packages(pkgs = c("base", "renv", "remotes", "knitr"), out.dir = tempdir())

# To change the language of the citation paragraph:
cite_packages(output = "paragraph", out.dir = tempdir(),
  text.start = "Para desarrollar este trabajo se utilizó",
  text.pkgs = "y los siguientes paquetes")


# To include citations in an R Markdown or Quarto file

# include this in YAML header:
# bibliography: grateful-refs.bib

# then call cite_packages within an R chunk:
cite_packages(output = "paragraph", out.dir = tempdir())

# To include package citations in the reference list of an Rmarkdown document
# without citing them in the text, include this in a chunk:
nocite_references(cite_packages(output = "citekeys", out.dir = tempdir()))
}
```

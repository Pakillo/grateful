
<!-- README.md is generated from README.Rmd. Please edit that file -->

# grateful

[![Travis-CI Build
Status](https://travis-ci.org/connorp/grateful.svg?branch=master)](https://travis-ci.org/connorp/grateful)

The goal of `grateful` is to make it very easy to cite the R packages
used in any report or publication. By calling a single function, it will
scan the project for R packages used and generate a BibTeX file
containing all citations for those packages. `grateful` can then either
generate a new document with citations in the desired output format
(Word, PDF, HTML, Markdown), or list citation keys to incorporate into
an existing RMarkdown document. Importantly, these references can be
formatted for a specific journal so that we can just paste them directly
into the bibliography list of our manuscript or report.

## Installation

``` r
library(devtools)
install_github("connorp/grateful")
```

## Basic Usage

`grateful` can be used in one of two ways: to generate a new document
listing each package and its citation, as well as a references list, or
to build citation keys to incorporate into an existing RMarkdown
document.

Imagine a project where we are using the following packages: readr,
dplyr, vegan, lme4, and ggplot2. We want to collect all the citations
listed for these packages, as well as a citation for base R (and for
RStudio, if applicable).

### Generate a New References Document

Calling `cite_packages(generate.document = TRUE)` will scan the project,
find these packages, and generate a document with formatted citations.

``` r
library(grateful)
cite_packages(generate.document = TRUE)
```

![](example-output.PNG)

This document can also be a Word document, PDF file, markdown file, or
left as the source Rmarkdown file using `out.format`. We can specify the
citation style for a particular journal using `style`.

``` r
cite_packages(style = "ecology", out.format = "docx")
```

You can also save the output of `cite_packages` to a specified
directory.

``` r
# Save the output in RMarkdown format only and to a docs subfolder.
cite_packages(out.format = "rmd", out.dir = file.path(getwd(), "docs"))
```

### Add Citations to an Existing Document

If you are building a document in RMarkdown and want to cite R packages,
`grateful` can generate a BibTeX file and return the citation keys.

First, include a reference to the BibTeX file in your YAML header.

    bibliography: pkg-refs.bib

RMarkdown lets you reference multiple BibTeX files, if needed.

    bibliography: 
    - document_citations.bib
    - pkg-refs.bib

Then call `cite_packages(generate.document = FALSE)` to return a vector
of citation
keys.

``` r
citationkeys <- cite_packages(generate.document = FALSE, all.pkgs = FALSE)
```

These citation keys can then be referenced within the document, or to
just include citations in the References section, concatenate them into
a list (with `@` before each key) and place them in a [metadata
block](https://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html#unused_references_\(nocite\))
to include them without an in-text citation.

    ---
    nocite: |
      `r  paste0("@", citationkeys, collapse = ", ")`
    ...

<!-- That inline R expression is a big yikes but it's tough to render verbatim inline R code INSIDE a verbatim chunk -->

Note that `all.pkgs = TRUE` does not work when being knitted within an
RMarkdown document, due to a limitation of
`checkpoint::scanForPackages()`.

## Workflow

`cite_packages` is a wrapper function which internally performs the
following steps:

1.  Scan the project for packages

<!-- end list -->

``` r
pkgs <- scan_packages()
```

2.  Get citations for each package

<!-- end list -->

``` r
cites <- get_citations(pkgs)
```

3.  If an output file is requested (`generate.document = TRUE`),
    generate and render the file.

<!-- end list -->

``` r
rmd <- create_rmd(cites)
render_citations(rmd, output = "html")
```

## Limitations

`all.pkgs = TRUE` fails if run within `knitr` when compiling an
RMarkdown document. `checkpoint::scanForPackages` is unable to search
for packages within the temporary directory used by `knitr::knit`.

`include.RStudio = TRUE` fails if run from an R session that is not in
an RStudio interactive session, including being run by `knitr`, even
when initiated by knitting in RStudio. The function `RStudio.Version()`
is only defined in RStudio interactive sessions.

Citation keys are not guaranteed to be preserved when regenerated,
particularly when packages are updated. This instability is not an issue
when citations are used programmatically, as in the example below. But
if references are put into the text manually, they may need to be
updated periodically.

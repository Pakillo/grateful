<!-- README.md is generated from README.Rmd. Please edit that file -->
grateful
========

[![Travis-CI Build Status](https://travis-ci.org/Pakillo/grateful.svg?branch=master)](https://travis-ci.org/Pakillo/grateful)

The goal of `grateful` is to make it very easy to cite the R packages used in any report or publication. By calling a single function, it will scan the project for R packages used and generate a document with citations in the desired output format (Word, PDF, HTML, Markdown). Importantly, these references can be formatted for a specific journal so that we can just paste them directly into the bibliography list of our manuscript or report.

Installation
------------

``` r
library(devtools)
install_github("Pakillo/grateful")
```

Basic usage
-----------

Imagine a project where we are using the following packages: readr, dplyr, vegan, lme4, and ggplot2. Calling `cite_packages` will scan the project, find these packages, and generate a document with formatted citations.

``` r
library(grateful)
cite_packages()
```

![](example-output.PNG)

This document can also be a Word document, or PDF, or markdown. And use the citation style of a particular journal:

``` r
cite_packages(style = "ecology", out.format = "docx")
```

Workflow
--------

`cite_packages` is a wrapper function which internally performs the following steps:

1 Scan the project for packages

``` r
pkgs <- scan_packages()
```

2 Get citations for each package

``` r
cites <- get_citations(pkgs)
```

3 Create an rmarkdown document citing all these packages

``` r
rmd <- create_rmd(cites)
```

4 Rendering the rmarkdown document to the desired output format

``` r
render_citations(rmd, output = "html")
```

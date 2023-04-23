## Resubmission

This is a resubmission where I have fixed the issues raised by the CRAN review:

* CITATION now uses bibentry() rather than citEntry().

* Package and software names now mentioned within single quotes ('R Markdown', 'Quarto').

* All functions writing to disk now require `out.dir` to be provided by the user 
(`out.dir = getwd()` has been replaced by `out.dir = NULL`). 
Examples and tests write to a `tempdir()`.

In addition, I have added many more tests and argument checks to increase the package robustness.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

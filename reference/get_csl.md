# Get a journal citation style from the official internet repository

Get a journal citation style from the official internet repository

## Usage

``` r
get_csl(name = NULL, out.dir = NULL)
```

## Arguments

- name:

  Name of the journal, exactly as found in
  <https://github.com/citation-style-language/styles>.

- out.dir:

  Directory to save the CSL file.

## Value

The CSL file is saved in the selected directory, and the path is
returned invisibly.

## Examples

``` r
if (FALSE) { # interactive()
get_csl("peerj", out.dir = tempdir())
}
```

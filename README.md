
<!-- README.md is generated from README.Rmd. Please edit that file -->

# grkstyle

<!-- badges: start -->

<!-- badges: end -->

`grkstyle` is an extension package for
[styler](https://styler.r-lib.org) that holds my personal code style
preferences.

## Installation

You can install the grkstyle from Github

``` r
# install.packages("devtools")
devtools::install_github("grkstyle")
```

## Usage

To use `grkstyle` by default in styler functions and addins

``` r
# Set default code style for {styler} functions
grkstyle::use_grk_style()
```

Or add the following to your `~/.Rprofile`

    options(styler.addins_style_transformer = "grkstyle::grk_style_transformer()")

## Examples

A few examples drawn from the [tidyverse style
guide](https://style.tidyverse.org).

### Line Breaks Inside Function Calls

**unstyled**

``` r
do_something_very_complicated(something = "that", requires = many,
                              arguments = "some of which may be long")
```

**grkstyle**

``` r
do_something_very_complicated(
  something = "that",
  requires = many,
  arguments = "some of which may be long"
) 
```

**styler::tidyverse\_style**

``` r
do_something_very_complicated(
  something = "that", requires = many,
  arguments = "some of which may be long"
) 
```

### Indentation of Function Arguments

**unstyled**

``` r
long_function_name <- function(a = "a long argument",
                               b = "another argument",
                               c = "another long argument") {
  # As usual code is indented by two spaces.
}
```

**grkstyle**

``` r
long_function_name <- function(
  a = "a long argument",
  b = "another argument",
  c = "another long argument"
) {
  # As usual code is indented by two spaces.
} 
```

**styler::tidyverse\_style**

``` r
long_function_name <- function(a = "a long argument",
                               b = "another argument",
                               c = "another long argument") {
  # As usual code is indented by two spaces.
} 
```

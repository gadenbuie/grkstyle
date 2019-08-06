
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

## Examples

``` r
library(grkstyle)

# Set default code style for {styler} functions
use_grk_style()
```

A few examples drawn from the [tidyverse style
guide](https://style.tidyverse.org).

**Unstyled**

``` r
do_something_very_complicated(something = "that", requires = many,
                              arguments = "some of which may be long")
```

**Styled**

``` r
do_something_very_complicated(
  something = "that",
  requires = many,
  arguments = "some of which may be long"
) 
```

**Unstyled**

``` r
long_function_name <- function(a = "a long argument",
                               b = "another argument",
                               c = "another long argument") {
  # As usual code is indented by two spaces.
}
```

**Styled**

``` r
long_function_name <- function(
  a = "a long argument",
  b = "another argument",
  c = "another long argument"
) {
  # As usual code is indented by two spaces.
} 
```

grk_transform_indentation <- function(indent_by = 1, indent_character = "\t") {
	indention <- styler::tidyverse_style(indent_by = indent_by)$indention
	indention$unindent_fun_dec <- NULL
	indention$update_indention_ref_fun_dec <- NULL

	styler::create_style_guide(
		style_guide_name = sprintf("Indent with %s '%s'", indent_by, indent_character),
		style_guide_version = "1.0.0",
		indention = indention,
		indent_character = indent_character,
		reindention = styler::specify_reindention(
			indention = indent_by,
			comments_only = FALSE
		)
	)
}

#' Re-indent R code using tabs or spaces
#'
#' Quickly convert from spaces to tabs or from tabs to spaces in R code
#' throught a file, directory or package.
#'
#' @param indent_by The number of spaces by which to indent the code.
#' @name grk_reindent
NULL


# Auto --------------------------------------------------------------------

#' @describeIn grk_reindent Re-indent text using tabs or spaces according to the
#'   RStudio project settings or the `grkstyle.use_tabs` option.
#' @inheritParams styler::style_text
#' @export
grk_reindent_auto_text <- function(text, ...) {
	indent_transformer <- do.call(grk_transform_indentation, args = grk_use_tabs())
	styler::style_text(text, ..., transformers = indent_transformer)
}

#' @describeIn grk_reindent Re-indent a file using tabs or spaces according to
#'   the RStudio project settings or the `grkstyle.use_tabs` option.
#' @inheritParams styler::style_file
#' @export
grk_reindent_auto_file <- function(path, ...) {
	indent_transformer <- do.call(grk_transform_indentation, grk_use_tabs())
	styler::style_file(path, ..., transformers = indent_transformer)
}

#' @describeIn grk_reindent Re-indent a directory using tabs or spaces according
#'   to the RStudio project settings or the `grkstyle.use_tabs` option.
#' @export
grk_reindent_auto_dir <- function(path, ...) {
	indent_transformer <- do.call(grk_transform_indentation, grk_use_tabs())
	styler::style_dir(path, ..., transformers = indent_transformer)
}

#' @describeIn grk_reindent Re-indent a package using tabs or spaces according
#'   to the RStudio project settings or the `grkstyle.use_tabs` option.
#' @export
grk_reindent_auto_pkg <- function(pkg = ".", ...) {
	indent_transformer <- do.call(grk_transform_indentation, grk_use_tabs())
	styler::style_pkg(pkg, ..., transformers = indent_transformer)
}

# Tabs --------------------------------------------------------------------

#' @describeIn grk_reindent Re-indent text using tabs
#' @inheritParams styler::style_text
#' @export
grk_reindent_tabs_text <- function(text, ...) {
	styler::style_text(
		text,
		...,
		transformers = grk_transform_indentation(
			indent_by = 1L,
			indent_character = "\t"
		)
	)
}

#' @describeIn grk_reindent Re-indent a file using tabs
#' @inheritParams styler::style_file
#' @export
grk_reindent_tabs_file <- function(path, ...) {
	styler::style_file(
		path,
		...,
		transformers = grk_transform_indentation(
			indent_by = 1L,
			indent_character = "\t"
		)
	)
}

#' @describeIn grk_reindent Re-indent a directory using tabs
#' @export
grk_reindent_tabs_dir <- function(path, ...) {
	styler::style_dir(
		path,
		...,
		transformers = grk_transform_indentation(
			indent_by = 1L,
			indent_character = "\t"
		)
	)
}

#' @describeIn grk_reindent Re-indent a package using tabs
#' @inheritParams styler::style_pkg
#' @export
grk_reindent_tabs_pkg <- function(pkg = ".", ...) {
	styler::style_pkg(
		pkg,
		...,
		transformers = grk_transform_indentation(
			indent_by = 1L,
			indent_character = "\t"
		)
	)
}

# Spaces ------------------------------------------------------------------

#' @describeIn grk_reindent Re-indent text using spaces
#' @inheritParams styler::style_text
#' @export
grk_reindent_spaces_text <- function(text, ..., indent_by = 2L) {
	styler::style_text(
		text,
		...,
		transformers = grk_transform_indentation(
			indent_by = indent_by,
			indent_character = " "
		)
	)
}

#' @describeIn grk_reindent Re-indent a file using spaces
#' @inheritParams styler::style_file
#' @export
grk_reindent_spaces_file <- function(path, ..., indent_by = 2L) {
	styler::style_file(
		path,
		...,
		transformers = grk_transform_indentation(
			indent_by = indent_by,
			indent_character = " "
		)
	)
}

#' @describeIn grk_reindent Re-indent a directory using spaces
#' @export
grk_reindent_spaces_dir <- function(path, ..., indent_by = 2L) {
	styler::style_dir(
		path,
		...,
		transformers = grk_transform_indentation(
			indent_by = indent_by,
			indent_character = " "
		)
	)
}

#' @describeIn grk_reindent Re-indent a package using spaces
#' @inheritParams styler::style_pkg
#' @export
grk_reindent_spaces_pkg <- function(pkg = ".", ..., indent_by = 2L) {
	styler::style_pkg(
		pkg,
		...,
		transformers = grk_transform_indentation(
			indent_by = indent_by,
			indent_character = " "
		)
	)
}

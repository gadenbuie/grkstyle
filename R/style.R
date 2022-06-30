#' The grkstyle Code Style
#'
#' Use [styler::style_text()] to format code according to the unofficial
#' \pkg{grkstyle} style guide. Follows the
#' [tidyverse style guide](https://style.tidyverse.org) as implemented by
#' [styler::tidyverse_style()], but with additional style rules that enforce
#' consistent line breaks inside function calls and left-justification of
#' function arguments in function definitions.
#'
#' @section Using the \pkg{grkstyle} code style: You can set the \pkg{grkstyle}
#'   code style as the default code style for \pkg{styler} (and its associated
#'   RStudio addins, like "Style active file" and "Style selection") by calling
#'   `grkstyle::use_grk_style()`. If you would rather set this option globally
#'   for all session, you can add the following to your `.Rprofile`:
#'
#'   ```
#'   options(styler.addins_style_transformer = "grkstyle::grk_style_transformer()")
#'   ```
#'
#' @examples
#' \dontrun{
#' use_grk_style()
#' # Use styler addins
#' styler:::style_selection()
#' }
#'
#' ex_code <- "mtcars %>% mutate(mpg = mpg * 2,\n\t\t     cyl = paste(cyl)) %>% head()"
#' cat(ex_code)
#'
#' grk_style_text(ex_code)
#' @param ... Arguments passed to underling \pkg{styler} functions (identified
#'   by removing the `grk_` prefix), except for `transformers`, which is set to
#'   the `grk_style_transformer()` internally.
#' @name grk_style
NULL

#' @describeIn grk_style Set the \pkg{grkstyle} style as the default style for
#'   \pkg{styler} addins.
#' @export
use_grk_style <- function() {
	options(styler.addins_style_transformer = "grkstyle::grk_style_transformer()")
}

#' @describeIn grk_style A code transformer for use with [styler::style_text()]
#' @param use_tabs Should a single tab be used for indentation? \pkg{grkstyle}
#'   functions will by default follow the `grkstyle.use_tabs` option, if set, or
#'   will attempt to look up the project settings in the current RStudio
#'   project. You can choose to use tabs or spaces for a project by changing the
#'   _Insert spaces for tab_ option in the Code Editing panel of the Project
#'   Options settings.
#'
#'   If not otherwise set via the R option or the RStudio project option, tabs
#'   are used. Tabs are recommended because they are
#'   [more accessible](https://alexandersandberg.com/articles/default-to-tabs-instead-of-spaces-for-an-accessible-first-environment/).
#'
#'   You can opt into indentation by two spaces by setting the
#'   `grkstyle.use_tabs` option:
#'
#'   ```r
#'   # two spaces
#'   options(grkstyle.use_tabs = FALSE)
#'
#'   # equivalently, but more precise
#'   options(grkstyle.use_tabs = list(indent_by = 2, indent_character = " "))
#'   ```
#' @export
grk_style_transformer <- function(
	...,
	use_tabs = getOption("grkstyle.use_tabs", NULL)
) {
	use_tabs <- grk_use_tabs(use_tabs)

	tidy_style <- styler::tidyverse_style(
		indent_by = use_tabs$indent_by
	)
	tidy_style$indent_character <- use_tabs$indent_character
	tidy_style$style_guide_name <- "grkstyle::grk_style_transformer@https://github.com/gadenbuie"
	tidy_style$style_guide_version <- pkg_version()

	# line breaks between *all* arguments if line breaks between *any*
	tidy_style$line_break$set_linebreak_each_argument_if_multi_line <- function(pd) {
		if (!(any(pd$token == "','"))) {
			return(pd)
		}
		# does this expression contain expressions with linebreaks?
		has_children <- purrr::some(pd$child, purrr::negate(is.null))
		has_internal_linebreak <- FALSE
		is_function_definition <- pd$token[1] == "FUNCTION"
		if (has_children && !is_function_definition) {
			children <- pd$child

			# don't count anything inside {} as internal linebreaks
			idx_pre_open_brace <- which(pd$token_after == "'{'")
			if (length(idx_pre_open_brace)) {
				children[idx_pre_open_brace + 1] <- NULL
			}

			has_internal_linebreak <- children %>%
				purrr::discard(is.null) %>%
				purrr::map_lgl(function(x) {
					sum(x$newlines, x$lag_newlines) > 0
				}) %>%
				any()
		}

		if (!has_internal_linebreak && sum(pd$newlines, pd$lag_newlines) < 1) {
			return(pd)
		}

		idx_comma <- which(pd$token == "','")
		idx_open_paren <- grep("'[[(]'", pd$token)
		idx_close_paren <- grep("'(]|\\))'", pd$token)
		idx_comma_has_comment <- which(pd$token[idx_comma + 1] == "COMMENT")
		idx_comma[idx_comma_has_comment] <- idx_comma[idx_comma_has_comment] + 1
		pd[idx_comma + 1L, "lag_newlines"] <- 1L
		if (length(idx_open_paren)) {
			pd[idx_open_paren[1] + 1L, "lag_newlines"] <- 1L
		}
		if (length(idx_close_paren)) {
			pd[idx_close_paren[length(idx_close_paren)], "lag_newlines"] <- 1L
		}
		pd
	}

	# Function arguments on new lines, indented with 2 spaces
	tidy_style$indention$update_indention_ref_fun_dec <- function(pd_nested) {
		if (pd_nested$token[1] == "FUNCTION" && nrow(pd_nested) > 4) {
			seq <- seq.int(3L, nrow(pd_nested) - 2L)
			pd_nested$indention_ref_pos_id[seq] <- 0L
			pd_nested$indent[seq] <- use_tabs$indent_by
		}
		pd_nested
	}

	tidy_style
}

grk_use_tabs <- function(use_tabs = getOption("grkstyle.use_tabs", NULL)) {
	if (is.null(use_tabs)) {
		root <- tryCatch(
			rprojroot::find_rstudio_root_file(),
			error = function(...) NULL
		)

		if (is.null(root)) {
			return(grk_use_tabs(TRUE))
		}

		rproj <- file.path(root, dir(root, pattern = "[.]Rproj$"))
		rproj <- readLines(rproj, warn = FALSE)

		if (any(grepl("^UseSpacesForTab: No$", rproj))) {
			return(grk_use_tabs(TRUE))
		}

		indent_by_chr <- grep("^NumSpacesForTab: \\d+", rproj, value = TRUE)
		if (!length(indent_by_chr)) {
			return(grk_use_tabs(FALSE))
		}

		indent_by <- as.numeric(sub("NumSpacesForTab: ", "", indent_by_chr))
		return(grk_use_tabs(list(indent_by = indent_by, indent_character = " ")))
	}

	if (isTRUE(use_tabs)) {
		use_tabs <- list(indent_by = 1L, indent_character = "\t")
	} else if (identical(use_tabs, FALSE)) {
		use_tabs <- list(indent_by = 2L, indent_character = " ")
	} else if (!setequal(c("indent_by", "indent_character"), names(use_tabs))) {
		stop(
			"`use_tabs` should be one of `TRUE`, `FALSE`, or a list containing ",
			"items 'intent_by' or 'indent_character'."
		)
	}
	use_tabs
}

#' @describeIn grk_style Style text using the \pkg{grkstyle} code style
#' @inheritParams styler::style_text
#' @export
grk_style_text <- function(text, ...) {
	styler::style_text(text, ..., transformers = grk_style_transformer())
}

#' @describeIn grk_style Style a file using the \pkg{grkstyle} code style
#' @inheritParams styler::style_file
#' @export
grk_style_file <- function(path, ...) {
	styler::style_file(path, ..., transformers = grk_style_transformer())
}

#' @describeIn grk_style Style a directory using the \pkg{grkstyle} code style
#' @export
grk_style_dir <- function(path, ...) {
	styler::style_dir(path, ..., transformers = grk_style_transformer())
}

#' @describeIn grk_style Style a package using the \pkg{grkstyle} code style
#' @inheritParams styler::style_pkg
#' @export
grk_style_pkg <- function(pkg = ".", ...) {
	styler::style_pkg(pkg, ..., transformers = grk_style_transformer())
}

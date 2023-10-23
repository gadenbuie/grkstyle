styler::cache_activate("grkstyle_test", verbose = FALSE)

test_that("xaringan comments work", {
	code <- 'base <- c(
\t"grep",
\t"grepl",
\t"sub", #<<
\t"gsub", #<<
\t"regexpr",
\t"gregexpr",
\t"regexec"
)'
	code_styled <- grk_style_text(code)
	expect_equal(paste(code_styled, collapse = "\n"), code)
})

as_grk_styled_text <- function(text) {
	grk <- unclass(grkstyle::grk_style_text(text))
	grk <- paste(grk, collapse = "\n")
	cat(grk)
}

get_indent_by <- function(indention) {
	rlang::eval_tidy(environment(indention$indent_without_paren)$args$indent_by)
}

test_that("grkstyle.use_tabs option", {
	use_tags_default <- grk_style_transformer()
	expect_equal(use_tags_default$indent_character, "\t")
	expect_equal(get_indent_by(use_tags_default$indention), 1L)

	use_spaces <- with_options(
		list(grkstyle.use_tabs = FALSE),
		grk_style_transformer()
	)
	expect_equal(use_spaces$indent_character, " ")
	expect_equal(get_indent_by(use_spaces$indention), 2L)

	use_custom <- with_options(
		list(grkstyle.use_tabs = list(indent_by = 6L, indent_character = "_")),
		grk_style_transformer()
	)
	expect_equal(use_custom$indent_character, "_")
	expect_equal(get_indent_by(use_custom$indention), 6L)

	with_options(
		list(grkstyle.use_tabs = list(foo = "bar")),
		expect_error(grk_use_tabs())
	)
})

test_that("tabs not spaces", {
	text_vec <- 'fruits <- c(\n  "apple",\n  "banana",\n  "mango"\n)'
	expect_snapshot(as_grk_styled_text(text_vec), variant = "tabs")

	with_options(
		list(grkstyle.use_tabs = FALSE),
		expect_snapshot(as_grk_styled_text(text_vec), variant = "spaces")
	)
})

test_that("line breaks", {
	text_line_breaks <- '
do_something_very_complicated(something = "that", requires = many,
                              arguments = "some of which may be long")
'
	expect_snapshot(as_grk_styled_text(text_line_breaks), variant = "tabs")

	with_options(
		list(grkstyle.use_tabs = FALSE),
		expect_snapshot(as_grk_styled_text(text_line_breaks), variant = "spaces")
	)
})

test_that("function args", {
	text_fn_args <- '
long_function_name <- function(a = "a long argument",
                               b = "another argument",
                               c = "another long argument") {
  # As usual code is indented by two spaces.
}
'
	expect_snapshot(as_grk_styled_text(text_fn_args), variant = "tabs")

	with_options(
		list(grkstyle.use_tabs = FALSE),
		expect_snapshot(as_grk_styled_text(text_fn_args), variant = "spaces")
	)
})

styler::cache_deactivate(FALSE)
